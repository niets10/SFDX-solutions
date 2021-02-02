public class ConvertCaseToLead {
    
    /* Flow inputs */
    public class FlowInputs{

        @InvocableVariable(label='Queue DeveloperName' description='Name of the queue which will be the owner of the Case')
        public String queueDeveloperName;

        @InvocableVariable(label='Case Id' description='Id of the case which will be converted to Lead')
        public Id caseId;

        @InvocableVariable(label='Lead Description' description='Description of the Lead')
        public String leadDescription;

    }
    
    /* Flow results */
    public class FlowResults{

        @InvocableVariable(label='Error' description='Boolean variable to notify errors')
        public Boolean error;

        @InvocableVariable(label='Errors' description='Errors ocurred in the process')
        public List<String> errors;

        public FlowResults(){
            errors = new List<String>();
        }

        public void addErrors(String err){
            errors.add(err);
        }

    }

    /* Invocable method */
    @InvocableMethod(label='Convert Case to Lead' description='Creates a new Lead record from a Case')
    public static List<FlowResults> convertToLead(List<FlowInputs> inputs){

        FlowInputs input = inputs[0];
        Id caseId = input.caseId;
        String leadDescription = input.leadDescription;
        
        Case caseToConvert = [SELECT Id, CaseNumber, SuppliedEmail, SuppliedName, SuppliedCompany, SuppliedPhone, Account.Name, ContactPhone,
                              (SELECT Id, Subject, MessageIdentifier, HtmlBody, Status, FromAddress, FromName, ToAddress, ToIds FROM EmailMessages ORDER BY MessageDate DESC)
                              FROM Case WHERE Id =: caseId];

        List<FlowResults> results = new List<FlowResults>();
        FlowResults result = new FlowResults();
        Boolean error = false;                      
        
        //Set savepoint
        Savepoint sp = Database.setSavepoint();

        try {
            
            //Lead creation
            Lead convertedLead = generateLead(caseToConvert, leadDescription);        
            insert convertedLead;
            
            //Email conversion
            List<EmailMessage> messagesToInsert = generateEmails(caseToConvert, convertedLead);
            insert messagesToInsert; 
            
            //Map of message identifiers
            Map<String, EmailMessage> mapEmailsIden = new Map<String, EmailMessage>();
            for(EmailMessage em : messagesToInsert){
                mapEmailsIden.put(em.MessageIdentifier, em);
            }
            
            //Email relationships
            List<EmailMessageRelation> messageRelationsToInsert = generateEmailRelations(messagesToInsert, convertedLead);

            //Document conversion
            DocumentObject doc = generateDocuments(caseToConvert, convertedLead, mapEmailsIden);
            List<ContentVersion> newDocuments = doc.documentVersions;
            List<ContentDocumentLink> documentLinks = doc.documentLinks;

            List<sObject> toInsert = new List<sObject>();
            toInsert.addAll(messageRelationsToInsert);
            toInsert.addAll(newDocuments);
            toInsert.addAll(documentLinks);

            insert toInsert;

            result.error = error;
            results.add(result);

        } catch (Exception e) {
                
            //If there's a an error, rollback the inserted records
            Database.rollback(sp);
            System.debug('Error ' + e);

            error = true;
            result.addErrors(e.getMessage());
            result.error = error;
            results.add(result);


        }

        return results;        

        
    }
    
    public static Lead generateLead(Case caseToConvert, String leadDescription){
        
        String company;
        if( !String.isBlank( caseToConvert.Account.Name ) ){
            company = caseToConvert.Account.Name;
        }else if( !String.isBlank( caseToConvert.SuppliedCompany ) ){
            company = caseToConvert.SuppliedCompany;
        }else{
            company = 'NO COMPANY PROVIDED';
        }

        Lead convertedLead = new Lead();

        convertedLead.LastName = caseToConvert.SuppliedName;
        //convertedLead.CaseNumber__c = caseToConvert.CaseNumber;
        convertedLead.Company = company;
        convertedLead.Email = caseToConvert.SuppliedEmail;
        convertedLead.Phone = !String.isBlank(caseToConvert.SuppliedPhone) ? caseToConvert.SuppliedPhone : caseToConvert.ContactPhone;
        convertedLead.Description = leadDescription;
        
        
        return convertedLead;
        
    }   
    
    public static List<EmailMessage> generateEmails(sObject recordToConvert, sObject convertedRecord){
        
        //Convert to generic sObject so it can be used for Lead to Case conversion
        List<EmailMessage> emailMessages = recordToConvert.getSObjects('EmailMessages');        
        
        List<EmailMessage> messagesToInsert = new List<EmailMessage>();
        for(EmailMessage em : emailMessages){
            
            EmailMessage newEmail = new EmailMessage();
            newEmail.Subject = em.Subject;
            newEmail.HtmlBody = em.HtmlBody;
            newEmail.Status = em.Status;
            newEmail.FromAddress = em.FromAddress;
            newEmail.FromName = em.FromName;
            newEmail.MessageIdentifier = em.MessageIdentifier;
            
            List<String> toIds = new List<String>{convertedRecord.Id};
            newEmail.ToIds = toIds;
            messagesToInsert.add(newEmail);  
        }
        
        return messagesToInsert;
    }
    
    public static List<EmailMessageRelation> generateEmailRelations(List<EmailMessage> messagesToInsert, sObject convertedRecord){
        List<EmailMessageRelation> messageRelationsToInsert = new List<EmailMessageRelation>();
        for(EmailMessage em : messagesToInsert){            
            EmailMessageRelation emr = new EmailMessageRelation();  
            emr.emailMessageId = em.Id;  
            emr.relationId = convertedRecord.Id; 
            emr.relationType = 'ToAddress';  
            
            messageRelationsToInsert.add(emr);
        }
        
        return messageRelationsToInsert;
    }
    
    public static DocumentObject generateDocuments(sObject recordToConvert, sObject convertedRecord, Map<String, EmailMessage> mapEmailsIden){
        
        // Get attachments directly on the Case  or on the emails attached to the Case
        // Since we activate "Save Email-to-Case attachments as Salesforce Files", we can query ContentDocumentLink directly        
        
        //We will do a map of LinkedEntityId and List<ContentDocumentId>, after that we will iterate through the Emails, and get all the DocumentsIds
        //and we will use a map of ContentDocumentId and ContentVersion to get a ContentVersion for each of the documents
        Map<Id, List<Id>> mapLinkedEntityDocuments = new Map<Id, List<Id>>();
        List<Id> documentIds = new List<Id>();

        //Convert to generic sObject so it can be used for Lead to Case conversion
        List<EmailMessage> emailMessages = recordToConvert.getSObjects('EmailMessages');
        
        for(ContentDocumentLink ca : [SELECT ContentDocumentId, LinkedEntityId 
                                      FROM ContentDocumentLink 
                                      WHERE LinkedEntityId IN: emailMessages
                                      OR LinkedEntityId =: recordToConvert.Id])
        {
            documentIds.add(ca.ContentDocumentId); 
            if(mapLinkedEntityDocuments.containsKey(ca.LinkedEntityId)){
                mapLinkedEntityDocuments.get(ca.LinkedEntityId).add(ca.ContentDocumentId);  
            }else{
                mapLinkedEntityDocuments.put(ca.LinkedEntityId, new List<Id>{ ca.ContentDocumentId });
            }
        }
        
        System.debug('Combined Attachments ' + documentIds);
        
        List<ContentVersion> relatedDocuments = [SELECT ContentDocumentId,FirstPublishLocationId,Id,PathOnClient,
                                                 Title, VersionData
                                                 FROM ContentVersion 
                                                 WHERE ContentDocumentId IN: documentIds
                                                 AND IsLatest = true];
        
        //Map of ContentDocumentId and ContentVersion since we filter by the Latest version
        Map<Id, ContentVersion> mapEmailDocuments = new Map<Id, ContentVersion>();
        
        for(ContentVersion cv : relatedDocuments){
            mapEmailDocuments.put(cv.ContentDocumentId, cv);
        }        
       
        System.debug('Related documents ' + relatedDocuments.size());
        
        //For each of the emails, we get their associated ContentDocumentsId, and with these, we get the ContentDocumentVersions
        List<ContentVersion> newDocuments = new List<ContentVersion>();
        for(EmailMessage em : emailMessages){
            
            if(mapLinkedEntityDocuments.containsKey(em.Id)){
                //For each email we get the files
                List<Id> contentDocumentIds = mapLinkedEntityDocuments.get(em.Id);
                for(Id cdi : contentDocumentIds){
                    
                    //For each file we get the ContentVersion
                    ContentVersion cv = mapEmailDocuments.get(cdi); 
                    
                    ContentVersion newCont = new ContentVersion();
                    newCont.Title  = cv.Title;
                    newCont.PathOnClient  = cv.PathOnClient;
                    newCont.VersionData = cv.VersionData;
                    newCont.FirstPublishLocationId  = mapEmailsIden.get(em.MessageIdentifier).Id;
                    
                    newDocuments.add(newCont);
                }
            }
        }
        
        //Create ContentLink to the Case
        //Sharing options checking
        List<ContentDocumentLink> linksToInsert = new List<ContentDocumentLink>();
        for(ContentVersion cv : relatedDocuments){
            ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.LinkedEntityId = convertedRecord.Id;
            cdl.ContentDocumentId = cv.ContentDocumentId;
            
            linksToInsert.add(cdl);
        }
        
        DocumentObject doc = new DocumentObject(newDocuments, linksToInsert);

        //insert toInsert;        
        
        System.debug('Content Version ' + newDocuments);
        
        return doc;
        
    }

    //Class to return ContentVersion and ContentDocumentLink and reduce DML statements
    public class DocumentObject {

        public List<ContentVersion> documentVersions { get; set; }
        public List<ContentDocumentLink> documentLinks { get; set; } 

        public DocumentObject(List<ContentVersion> contentVersions, List<ContentDocumentLink> docLinks){

            documentVersions = contentVersions;
            documentLinks = docLinks;
        }

    }
    
}