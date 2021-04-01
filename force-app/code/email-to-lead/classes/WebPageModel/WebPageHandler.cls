public class WebPageHandler {

	public static WebPage executeLogic(Messaging.InboundEmail email) {
	
		String emailBody = email.plainTextBody;
        WebPage wp;
	
		if(emailBody.containsIgnoreCase('bytbil.com')){
 
			wp = new Bytbil(email, emailBody);            

		}else if(emailBody.containsIgnoreCase('Wayke.se')){

			// processWayke(emailBody);    

		}else if(emailBody.containsIgnoreCase('blocket.se')){
   
			// processBlocket(emailBody);
		}
	
        return wp;
	}

}