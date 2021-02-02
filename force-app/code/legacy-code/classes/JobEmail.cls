public class JobEmail {
    
    //Map to be used when a new Contact has to be inserted. Get the relations from the email address and update those relations
    private static Map<String, List<EmailMessageRelation>> mapAddressRelations;
    private static Map<Id, EmailMessage> messages;    
    private static Set<String> emailAddresses;
    
    private Map<Id, sObject> objectsToUpdate;
    private List<Contact> contactsToInsert;
    private List<Contact> totalContacts;
    private Map<String, List<Contact>> mapEmailContacts;
    private List<Account> totalAccounts;
    private Map<String, List<Account>> mapEmailAccounts;
    
    public JobEmail(){
        this.objectsToUpdate = new Map<Id, sObject>();  
        this.contactsToInsert = new List<Contact>();
        this.totalContacts = new List<Contact>();
        this.mapEmailContacts =  new Map<String, List<Contact>>();        
        this.totalAccounts = new List<Account>();
        this.mapEmailAccounts =  new Map<String, List<Account>>();
        
    }
    
    static {
        mapAddressRelations = new Map<String, List<EmailMessageRelation>>();
        emailAddresses = new Set<String>();
        
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
                                             ]); 
        
        for(EmailMessage message : messages.values()){
            for(EmailMessageRelation emr : message.EmailMessageRelations){
                emailAddresses.add(emr.RelationAddress);
                //Populate Map<String, List<EmailMessageRelations>>
                if(mapAddressRelations.containsKey(emr.RelationAddress)){
                    mapAddressRelations.get(emr.RelationAddress).add(emr);  
                }else{
                    mapAddressRelations.put(emr.RelationAddress, new List<EmailMessageRelation>{ emr });
                }
            }
        }        
    }
    
    public void processJobEmail(){
        
        //Get total Contacts and Accounts
        this.getTotalContacts();
        this.getTotalAccounts();
        
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
    
    private void processContacts(){
        
        for(EmailMessage message : messages.values()){
            
            for(EmailMessageRelation emr : message.EmailMessageRelations){
                
                //Get the contact for the specific EmailMessageRelation, using the RelationAddress, there could be one or several Contacts
                List<Contact> contacts = mapEmailContacts.containsKey(emr.RelationAddress) ? mapEmailContacts.get(emr.RelationAddress) : new List<Contact>();
                           
                if(contacts.size() == 1){
                    System.debug('Single contact');
                    this.updateEmailRelation(emr, Contacts[0].Id);
                }else if(contacts.size() > 1){
                    System.debug('Multiple contact');
                    //Here we need to check if the contacts are related to a company or private person (not mäklare!)
                    //If it only one contact belongs, then we update the Email Relation
                    //If no contact, we process accounts 
                    this.updateManualProcessing(message);
                }else if(contacts.isEmpty()){
                    this.processAccounts(message, emr);                
                }                
            }
        }
    }
    
    //Call when TotalContact is empty so we directly process Accounts
    private void processAccounts(){
        for(EmailMessage message : messages.values()){
            for(EmailMessageRelation emr : message.EmailMessageRelations){
                processAccounts(message, emr);
            }
        }  
    }
    
    private void processAccounts(EmailMessage message, EmailMessageRelation emr){
        
        //Get Accounts
        List<Account> accounts = mapEmailAccounts.containsKey(emr.RelationAddress) ? mapEmailAccounts.get(emr.RelationAddress) : new List<Account>();
        
        if(accounts.isEmpty()){
            return;
        }else if(accounts.size() == 1){            
            this.insertContact(accounts[0].Email__c, accounts[0].Id);            
        }else if(accounts.size() > 1){
            this.updateManualProcessing(message);
        }
    }
    
    private void updateManualProcessing(EmailMessage message){
        message.ManualProcessing__c = true;
        this.objectsToUpdate.put(message.Id, message);
    }
    
    private void updateEmailRelation(EmailMessageRelation emr, Id contactId){        
        emr.RelationId = contactId;
        this.objectsToUpdate.put(emr.Id, emr);
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
                    /*emr.RelationId = c.Id;                
                    this.objectsToUpdate.put(emr.Id, emr);*/
                    this.updateEmailRelation(emr, c.Id);
                }            
            }
        }
                
        if(!this.objectsToUpdate.values().isEmpty()){
            update this.objectsToUpdate.values();
        }
    }
}