public abstract class WebPage {
    
    private static Log logger = Log.get();	  
	private Id queueId;
	private Messaging.InboundEmail email;
    
    public WebPage(Messaging.InboundEmail email) {
        this.email = email;
    }

    //Needed for all the classes that extend this class
    public abstract void processWebPage();

    //Logic
    /**
     * @description: Insert leads if there are not leads with the same Email Address, otherwise it uses the existing Leads
    * After that, it inserts a FordonInterest and an Email related to this Lead
    * @param String name, String emailAddress, String phone, String leadSource, String fromAddress, String fromName    
    */
    protected void insertEntities(String name, String emailAddress, String phone, String leadSource, String fromAddress, String fromName){

        String firstName = name?.subStringBefore(' ');
        String lastName = name?.subStringAfter(' ');

        try {
            
            Id leadId;
            
            List<Lead> leads = [SELECT Id, Name, Email, OwnerId FROM Lead WHERE Email =: emailAddress AND Email != null];
            
            //If no existing Leads, we create one, otherwise we use the first value
            if(leads.isEmpty()){

            System.debug('No Lead ' + emailAddress);
            Lead lead = new Lead();
            lead.FirstName = firstName ;
            lead.Company = 'SF';
            lead.LastName = !String.isBlank(lastName) ? lastName : emailAddress;
            lead.Email = emailAddress;
            lead.MobilePhone = phone;
            lead.LeadSource = leadSource;
            //To be populated after testing
            //lead.OwnerId = getQueueId(email.fromAddress);

            insert lead;

            leadId = lead.Id;
            
            }else{
            
                Lead lead = leads[0];
                System.debug('Lead ' + lead);
                System.debug('Lead Id ' + lead.Id);
                System.debug('Lead Email ' + lead.Email);        
                leadId = lead.Id;

                Id ownerId = lead.OwnerId;
                String leadName = lead.Name;
                //Send a custom notification if the owner is a User
                if(ownerId.getSObjectType() == Schema.User.getSObjectType()){
                    sendCustomNotification(ownerId, leadId, leadName);
                }

                }
            
            //Insert Email attached to the Lead
            EmailMessage newEmail = new EmailMessage();
            newEmail.Subject = email.Subject;
            newEmail.HtmlBody = email.HtmlBody?.length() >= 32000 ? email.HtmlBody.replaceAll('<[/a-zAZ0-9]*>','') : email.HtmlBody;
            newEmail.FromAddress = fromAddress;
            newEmail.FromName = fromName;
            //New status
            newEmail.Status = '0';

            List<String> toIds = new List<String>{leadId};
            newEmail.ToIds = toIds;

            insert newEmail;

            EmailMessageRelation emr = new EmailMessageRelation();  
            emr.EmailMessageId = newEmail.Id;  
            emr.RelationId = leadId; 
            emr.RelationType = 'ToAddress';  

            insert emr;

        } catch (Exception e) {
            System.debug(e.getMessage());
            logger.addLog(email.plainTextBody);
            logger.addLog(e);
            
        }
    }
    
    /**
    * @description: Gets car indentifier/registration number using a Regular Expression
    * @return carIdentifier String
    */
    private String getCarIndentifier(){

        String emailBody = email.plainTextBody;

        String carIdentifier = '';

        //There might be cases of codes like JUK89A
        String regex = '\\b[A-Z]{3}[0-9]{2}([0-9]|[A-Z])\\b';

        Pattern p = Pattern.compile(regex);
        Matcher matcher = p.matcher(emailBody);

        Boolean match = matcher.find();

        if(match){
            carIdentifier = matcher.group();
        }else{
            System.debug('Not match found');
        }

        System.debug('Car identifier ' + carIdentifier);

        return carIdentifier;
    }

    /**
    * @description: Send a custom notification to the owner of the lead if a new car interest is registered in
    * an existing Lead
    * @param Id recipientId, Id leadId, String leadName
    */
    private void sendCustomNotification(Id recipientId, Id leadId, String leadName){

        List<CustomNotificationType> cnt = [SELECT Id, CustomNotifTypeName, DeveloperName 
                                        FROM CustomNotificationType 
                                        WHERE DeveloperName = 'DesktopMobileNotification'];

        if(cnt.isEmpty()) return;                              

        Messaging.CustomNotification obj = new Messaging.CustomNotification();

        // Custom notification type Id
        obj.setNotificationTypeId(cnt[0].Id);

        // when we click on the notification it will redirect to the specified targetId
        obj.setTargetId(leadId);

        // Notification Title
        obj.setTitle('New interest in a car!');

        // Notification Body
        obj.setBody('Hi! ' + leadName + ' is interested in a new car. Click on this notification to access the record');

        // send used to send the notification, pass the set of user ids , Group or Queue member
        obj.send(new set<String>{recipientId});
    }

    /**
    * @description: Get the queueId that will be the owner of the to be inserted Lead based on the emailAddress
    * @param String emailAddress
    */
    private Id getQueueId(String emailAddress){
       return [SELECT Id FROM Group WHERE DeveloperName = 'Lead_Queue' AND Type = 'Queue']?.Id;
    }
}