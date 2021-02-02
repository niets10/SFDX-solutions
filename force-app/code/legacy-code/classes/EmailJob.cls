public class EmailJob {
    
    //Map to be used when a new Contact has to be inserted. Get the relations from the email address and update those relations
    private static Map<String, List<EmailMessageRelation>> mapAddressRelations;
    private static Map<String, Map<String, List<EmailMessageRelation>>> mapEmailAddressRelations;
    private static Map<Id, EmailMessage> messages;
    private static Set<String> emailAddresses;
    
    
    private Map<Id, sObject> objectsToUpdate;
    private List<Contact> contactsToInsert;
    private List<Contact> totalContacts;
    private Map<String, List<Contact>> mapEmailContacts;
    private List<Account> totalAccounts;
    private Map<String, List<Account>> mapEmailAccounts;
    
    public EmailJob(){
        this.objectsToUpdate = new Map<Id, sObject>();  
        this.contactsToInsert = new List<Contact>();
        this.totalContacts = new List<Contact>();
        this.mapEmailContacts =  new Map<String, List<Contact>>();        
        this.totalAccounts = new List<Account>();
        this.mapEmailAccounts =  new Map<String, List<Account>>();
        
    }
    
    //Static initialization
    static {
        mapAddressRelations = new Map<String, List<EmailMessageRelation>>();
        mapEmailAddressRelations = new Map<String, Map<String, List<EmailMessageRelation>>>();
        emailAddresses = new Set<String>();    
        
        //First filter is because we don't want to query all the emails, so we will filter the emails based on some conditions.
        //Within an email, we don't want all the email relations, we only want those with the same conditions as before  
        Date yest = Date.today() -1;
        messages = new Map<Id, EmailMessage>([SELECT Id, 
                                              (SELECT EmailMessage.ManualProcessing__c, RelationAddress, RelationId 
                                               FROM EmailMessageRelations 
                                               WHERE RelationObjectType != 'Contact' 
                                               AND RelationId != '' AND (NOT RelationAddress LIKE '%dina.se')
                                              ) 
                                              FROM EmailMessage WHERE RelatedToId = '' 
                                              AND Id IN (SELECT EmailMessageId FROM EmailMessageRelation WHERE RelationObjectType != 'Contact' 
                                                         AND RelationId != '' AND (NOT RelationAddress LIKE '%dina.se')
                                                        )
                                              AND CreatedDate >: yest
                                             ]); 
        
        for(EmailMessage message : messages.values()){    
            for(EmailMessageRelation emr : message.EmailMessageRelations){
                //Populate emailAdressess
                emailAddresses.add(emr.RelationAddress);
                //Populate Map<String, Map<String, List<EmailMessageRelations>>>
                if(mapEmailAddressRelations.containsKey(emr.EmailMessageId)){
                    Map<String, List<EmailMessageRelation>> innerMap = mapEmailAddressRelations.get(emr.EmailMessageId);                
                    if(innerMap.containskey(emr.RelationAddress)){
                        innerMap.get(emr.RelationAddress).add(emr);
                    }else{
                        innerMap.put(emr.RelationAddress, new List<EmailMessageRelation>{emr});
                    }
                }else{
                    mapEmailAddressRelations.put(emr.EmailMessageId, new Map<String, List<EmailMessageRelation>>{ 
                        emr.RelationAddress => new List<EmailMessageRelation>{emr}
                    });
                }
                
                //Populate Map<String, List<EmailMessageRelations>>
                if(mapAddressRelations.containsKey(emr.RelationAddress)){
                    mapAddressRelations.get(emr.RelationAddress).add(emr);  
                }else{
                    mapAddressRelations.put(emr.RelationAddress, new List<EmailMessageRelation>{ emr });
                }
            }
        }        
    }
    
    public void processEmailJob(){ 
        
        //Get total Contacts and Accounts
        this.getTotalContacts();
        this.getTotalAccounts();
        
        //If there are existent contacts
        if(!totalContacts.isEmpty()){            
            //Call process Contact method            
            this.processContacts();
            
            //If no Contacts found, try with Accounts
        }else if(!totalAccounts.isEmpty()){            
            //Call process Account method
            this.processAccounts();             
        }
        
        /* Execute DML operations */
        this.processDmlOperations();
        
        System.debug('Queries ' + Limits.getQueries());
        System.debug('DML rows ' + Limits.getDMLRows());
        System.debug('DML statements ' + Limits.getDMLStatements());
        System.debug('CPU Time ' + Limits.getCpuTime());
        
    }
    
    private void getTotalContacts(){
        System.debug('Before remove ' +  emailAddresses);
        //Find total Contacts
        this.totalContacts = [SELECT Id, Email FROM Contact WHERE Email IN: emailAddresses];                  
        //Map of email and contacts, since there could be several contacts with the same email (duplicates)
        if(!this.totalContacts.isEmpty()){
            for(Contact c : totalContacts){
                if(this.mapEmailContacts.containsKey(c.Email)){
                    this.mapEmailContacts.get(c.Email).add(c);  
                }else{
                    this.mapEmailContacts.put(c.Email, new List<Contact>{ c });
                }
            }
            //Select Accounts by the emails that have not yet been found in Contacts (to make it more selective)
            for(String contactEmail : mapEmailContacts.keySet()){
                emailAddresses.remove(contactEmail);
            }            
        }        
    }
    
    private void getTotalAccounts(){
        System.debug('After remove ' +  emailAddresses);
        //Find total Accounts
        this.totalAccounts = [SELECT Id, Email__c FROM Account WHERE Email__c IN: emailAddresses];                          
        //Map of email and accounts, since there could be several accounts with the same email (duplicates)
        if(!this.totalAccounts.isEmpty()){
            for(Account a : totalAccounts){
                if(this.mapEmailAccounts.containsKey(a.Email__c)){
                	this.mapEmailAccounts.get(a.Email__c).add(a);  
                }else{
                	this.mapEmailAccounts.put(a.Email__c, new List<Account>{ a });
                }
            }
        }
    }
    
    //Update Manual Processing boolean
    private void updateManualProcessing(EmailMessage email){
        email.ManualProcessing__c = true;
        this.objectsToUpdate.put(email.Id, email);
    }
    
    //Update EmailRelations
    private void updateEmailRelation(String recordEmail, Id recordId, Id messageId){
        //Fetch EmailRelations for an specific Email and after for an specific EmailAddress
        Map<String, List<EmailMessageRelation>> mapEmailRelations = mapEmailAddressRelations.get(messageId);
        
        List<EmailMessageRelation> emrs = mapEmailRelations.get(recordEmail);
        Map<Id, sObject> objectsToUpdate = new Map<Id, sObject>();
        for(EmailMessageRelation emr : emrs){
            if(!this.objectsToUpdate.containsKey(emr.Id)){
                emr.RelationId = recordId;
                this.objectsToUpdate.put(emr.Id, emr);
            }
        }
    }
    
    //Call when TotalContact is empty so we directly process Accounts
    private void processAccounts(){
        for(EmailMessage message : messages.values()){
            processAccounts(message);
        }  
    }
    
    //Call when TotalContact is not empty, but Contacts for a single emails is empty
    private void processAccounts(EmailMessage message){
        //Get the relevant accounts for this Email
        List<Account> accounts = new List<Account>();                    
        for(EmailMessageRelation emr : message.EmailMessageRelations){
            if(mapEmailAccounts.keySet().contains(emr.RelationAddress)){
                accounts.addAll(mapEmailAccounts.get(emr.RelationAddress));
            }
        }
        
        //If no accounts, skip to the next iteration
        if(accounts.isEmpty()){
            return;    
            
            //Create Contact associated to the Account, with the same email, and last name info
            //and after update email relation to this contact   
        }else if(accounts.size() == 1){
            //to be replaced by code doing as an top
            System.debug('There is an account, will not process yet');
            this.insertContact(accounts[0].Email__c, accounts[0].Id);
            //this.updateEmailRelation(accounts[0].Email__c, accounts[0].Id, message.Id);
            
            //UPDATE MANUAL PROCESSING    
        }else if(accounts.size() > 1){
            this.updateManualProcessing(message);
        }
    }
    
    //Process Contacts
    private void processContacts(){
        //Process each of the emails
        for(EmailMessage message : messages.values()){
            System.debug('Email ' + message);
            //Get the relevant contacts for this Email
            List<Contact> contacts = new List<Contact>();
            for(EmailMessageRelation emr : message.EmailMessageRelations){
                if(mapEmailContacts.keySet().contains(emr.RelationAddress)){                        
                    contacts.addAll(mapEmailContacts.get(emr.RelationAddress));
                }                    
            }
            System.debug(contacts);
            /* CONTACT PROCESSING */
            
            //UPDATE UPDATE EMAIL RELATION           
            if(contacts.size() == 1){  
                System.debug('Single Contact');
                this.updateEmailRelation(contacts[0].Email, contacts[0].Id, message.Id);
                
                //UPDATE MANUAL PROCESSING 
            }else if(contacts.size() > 1){   
                System.debug('More than a contact');
                //@To be changed based on the filter of the query                    
                //Add logic for private person or company (OneNote)
                this.updateManualProcessing(message);
                
                /* ACCOUNT PROCESSING */    
            }else if(contacts.isEmpty()){
                this.processAccounts(message);
            }
        }
    }   
    
    //When we find a single account for an specific email
    private void insertContact(String accountEmail, Id accountId){
        
        Contact contact = new Contact();
        contact.LastName = 'Info';
        contact.Email = accountEmail;
        contact.AccountId = accountId;
        
        this.contactsToInsert.add(contact);
        
    }
    
    //Process DML operations
    private void processDmlOperations(){
        
        //Execute only if for each email, we find a single account, otherwise contactsToInsert should be empty
        if(!this.contactsToInsert.isEmpty()){
            insert this.contactsToInsert;            
            
            //Update the EmailMessageRelations for the inserted Contacts
            for(Contact c : this.contactsToInsert){ 
                //Get the EmailMessageRelations
                List<EmailMessageRelation> emrs = mapAddressRelations.get(c.Email);
                for(EmailMessageRelation emr : emrs){
                    emr.RelationId = c.Id;                
                    this.objectsToUpdate.put(emr.Id, emr);
                }            
            }
        }
        
        
        if(!this.objectsToUpdate.values().isEmpty()){
            update this.objectsToUpdate.values();
        }
    }
}