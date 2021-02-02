@isTest
public class JobEmailTest {
    
    @TestSetup
    static void dataSetup(){
        
        List<sObject> toInsert = new List<sObject>();
        
        //Generate Leads to populate RelationId
        Lead lead1 = new Lead();
        lead1.LastName = 'Lead 1';
        lead1.Company = 'Lead AB';
        toInsert.add(lead1);      
        
        Lead lead2 = new Lead();
        lead2.LastName = 'Lead 2';
        lead2.Company = 'Lead AB';
        toInsert.add(lead2);
        
        //Generate Contacts
        Contact contact1 = new Contact();
        contact1.LastName = 'Contact 1';
        contact1.Email = 'contact1@random.se';
        toInsert.add(contact1);
        
        Contact contact2 = new Contact();
        contact2.LastName = 'Contact 2';
        contact2.Email = 'contact2@random.se';
        toInsert.add(contact2);
        
        Contact contact3 = new Contact();
        contact3.LastName = 'Contact 3';
        contact3.Email = 'contact3@random.se';
        toInsert.add(contact3);
        
        //Generate a duplicate contact
        Contact contact4 = new Contact();
        contact4.LastName = 'Contact Duplicated';
        contact4.Email = 'contact1@random.se';
        toInsert.add(contact4);
        
        //Generate Accounts
        Account account1 = new Account();
        account1.Name = 'Account 1';
        account1.Email__c = 'account1@random.se';
        toInsert.add(account1);  
        
        //Generate dupplicate Account
        Account account2 = new Account();
        account2.Name = 'Account Duplicated 1';
        account2.Email__c = 'accountduplicated@random.se';
        toInsert.add(account2); 
        
        Account account3 = new Account();
        account3.Name = 'Account Duplicated 2';
        account3.Email__c = 'accountduplicated@random.se';
        toInsert.add(account3); 
        
        insert toInsert;
        
    }
    
     
     /*For a single email single contact, the EmailMessageRelation will be updated to the contact
	*/
    @isTest
    static void singleEmailWithContact(){
        
        //Generate Email
        Lead lead = [SELECT Id FROM Lead WHERE LastName = 'Lead 1'];
        Contact contact = [SELECT Id FROM Contact WHERE Email = 'contact3@random.se'];
        
        EmailMessage email = new EmailMessage();
        email.Subject = 'E1';
        insert email;
        
        EmailMessageRelation emr = new EmailMessageRelation();
        emr.EmailMessageId = email.Id;
        emr.RelationAddress = 'contact3@random.se';
        emr.RelationId = lead.Id;
        emr.RelationType = 'ToAddress';
        insert emr;
        
        Test.startTest();
        JobEmail je = new JobEmail();
        je.processJobEmail();
        Test.stopTest();
        
        email = [SELECT ManualProcessing__c FROM EmailMessage WHERE Id =: email.Id];
        emr = [SELECT RelationId FROM EmailMessageRelation WHERE Id =: emr.Id];
        
        System.assertEquals(false, email.ManualProcessing__c);
        System.assertEquals(contact.Id, emr.RelationId);
        
    }
    
    /*For a single email with duplicate contacts, the email will be update to Manual Processing
	*/
    @isTest
    static void singleEmailWithDuplicateContact(){
        
        //Generate Email
        Lead lead = [SELECT Id FROM Lead WHERE LastName = 'Lead 1'];
        
        EmailMessage email = new EmailMessage();
        email.Subject = 'E1';
        insert email;
        
        EmailMessageRelation emr = new EmailMessageRelation();
        emr.EmailMessageId = email.Id;
        emr.RelationAddress = 'contact1@random.se';
        emr.RelationId = lead.Id;
        emr.RelationType = 'ToAddress';
        insert emr;
        
        Test.startTest();
        JobEmail je = new JobEmail();
        je.processJobEmail();
        Test.stopTest();
        
        email = [SELECT ManualProcessing__c FROM EmailMessage WHERE Id =: email.Id];
        emr = [SELECT RelationId FROM EmailMessageRelation WHERE Id =: emr.Id];
        
        System.assertEquals(true, email.ManualProcessing__c);
        System.assertEquals(lead.Id, emr.RelationId);
        
        
    }
   
    
    /*For a single email with no contact but account, a new contact will be inserted with LastName "Info" and Email accountEmail
	*/
    @isTest
    static void singleEmailWithAccount(){
        
        //Generate Email
        Lead lead = [SELECT Id FROM Lead WHERE LastName = 'Lead 1'];
        Account account = [SELECT Id, Email__c FROM Account WHERE Email__c = 'account1@random.se'];
        
        EmailMessage email = new EmailMessage();
        email.Subject = 'E1';
        insert email;
        
        EmailMessageRelation emr = new EmailMessageRelation();
        emr.EmailMessageId = email.Id;
        emr.RelationAddress = 'account1@random.se';
        emr.RelationId = lead.Id;
        emr.RelationType = 'ToAddress';
        insert emr;
        
        Test.startTest();
        JobEmail je = new JobEmail();
        je.processJobEmail();
        Test.stopTest();
        
        //Check the Contact has been created
        List<Contact> createdContact = [SELECT LastName, Email FROM Contact WHERE LastName = 'Info' AND Email =: account.Email__c LIMIT 1];
        
        email = [SELECT ManualProcessing__c FROM EmailMessage WHERE Id =: email.Id];
        emr = [SELECT RelationId FROM EmailMessageRelation WHERE Id =: emr.Id];
        
        System.assert(!createdContact.isEmpty());
        System.assertEquals(false, email.ManualProcessing__c);
        System.assertEquals(createdContact[0].Id, emr.RelationId);
    }
    
    /*For a single email with no contact but account, a new contact will be inserted with LastName "Info" and Email accountEmail
	*/
    @isTest
    static void singleEmailWithDuplicateAccount(){
        
        //Generate Email
        Lead lead = [SELECT Id FROM Lead WHERE LastName = 'Lead 1'];
        
        EmailMessage email = new EmailMessage();
        email.Subject = 'E1';
        insert email;
        
        EmailMessageRelation emr = new EmailMessageRelation();
        emr.EmailMessageId = email.Id;
        emr.RelationAddress = 'accountduplicated@random.se';
        emr.RelationId = lead.Id;
        emr.RelationType = 'ToAddress';
        insert emr;
        
        Test.startTest();
        JobEmail je = new JobEmail();
        je.processJobEmail();
        Test.stopTest();
        
        email = [SELECT ManualProcessing__c FROM EmailMessage WHERE Id =: email.Id];

        System.assertEquals(true, email.ManualProcessing__c);
    }
    
    /*For a single email with contact and account, but the contact does not exist in the system.A new contact will be inserted with LastName "Info" and Email accountEmail
	* This will happen when two Emails are processed, first email having existent Contacts, second email having a fake one
	*/
    @isTest
    static void singleEmailWithFakeContactAndAccount(){
        
        //Generate Email
        Lead lead = [SELECT Id FROM Lead WHERE LastName = 'Lead 1'];        
        Lead lead2 = [SELECT Id FROM Lead WHERE LastName = 'Lead 2'];
        Contact contact = [SELECT Id FROM Contact WHERE Email = 'contact3@random.se'];
        Account account = [SELECT Id, Email__c FROM Account WHERE Email__c = 'account1@random.se'];
        
        //Generate first email with existent Contact
        EmailMessage email = new EmailMessage();
        email.Subject = 'E1';
        insert email;
        
        EmailMessageRelation emr = new EmailMessageRelation();
        emr.EmailMessageId = email.Id;
        emr.RelationAddress = 'contact3@random.se';
        emr.RelationId = lead.Id;
        emr.RelationType = 'ToAddress';
        insert emr;
        
        //Generate second email with fake Contact and existent Account
        EmailMessage secondEmail = new EmailMessage();
        secondEmail.Subject = 'E2';
        insert secondEmail;
        
        //Fake Contact
        EmailMessageRelation emr1 = new EmailMessageRelation();
        emr1.EmailMessageId = secondEmail.Id;
        emr1.RelationAddress = 'somefakeemail@random.se';
        emr1.RelationId = lead.Id;
        emr1.RelationType = 'ToAddress';
        insert emr1;
        
        //Existent Account
        EmailMessageRelation emr2 = new EmailMessageRelation();
        emr2.EmailMessageId = secondEmail.Id;
        emr2.RelationAddress = 'account1@random.se';
        emr2.RelationId = lead2.Id;
        emr2.RelationType = 'ToAddress';
        insert emr2;
        
        Test.startTest();
        JobEmail je = new JobEmail();
        je.processJobEmail();
        Test.stopTest();
        
        //Verify first email
        email = [SELECT ManualProcessing__c FROM EmailMessage WHERE Id =: email.Id];
        emr = [SELECT RelationId FROM EmailMessageRelation WHERE Id =: emr.Id];
        
        System.assertEquals(false, email.ManualProcessing__c);
        System.assertEquals(contact.Id, emr.RelationId);
        
        //Verify second email
        emr1 = [SELECT RelationId FROM EmailMessageRelation WHERE Id =: emr1.Id];
        emr2 = [SELECT RelationId FROM EmailMessageRelation WHERE Id =: emr2.Id];
        
        System.debug(emr1);
        System.debug(emr2);
        
        //Check the Contact has been created
        List<Contact> createdContact = [SELECT LastName, Email FROM Contact WHERE LastName = 'Info' AND Email =: account.Email__c LIMIT 1];
               
        System.assert(!createdContact.isEmpty());
        System.assertEquals(createdContact[0].Id, emr2.RelationId);
        
    }
    
}