/**
 @Name: EmailToLeadHandler.cls
 @TestedBy: EmailToLeadHandler_Test.cls
 @Other classes used:
 @Description: Description:
    Process information from incoming emails to create or update Leads in the system
*/
global class EmailToLead implements Messaging.InboundEmailHandler {

    private static Log logger = Log.get();
    
    /**
      * @description: Main method and entry point. Calls logic in different methods
      * @param Messaging.InboundEmail inboundEmail, Messaging.InboundEnvelope env   
      */
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail inboundEmail, 
                                                         Messaging.InboundEnvelope env){
                                                                                                            
      Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();   
     
      /*If there's an error processing the email information, an error will be thrown to the email
        so wrapping it in try catch will avoid these emails to be sent
      */
      try {                            
      
        WebPage wp = WebPageHandler.executeLogic(inboundEmail);
        wp.processWebPage();
    
      } catch (Exception e) {
        logger.addLog(e);
      }
  
      logger.publishEvents();
         
      // Return the result for the Apex Email Service
      result.success = true;
      return result;
    }
  
    
  }