public class Bytbil extends WebPage {
    
    private String emailBody;
    
    public BytBil(Messaging.InboundEmail email, String emailBody){
        super(email);
        this.emailBody = emailBody;
    }

    /**
    * @description: Override the abstract method
    */
    public override void processWebPage(){
        
        //Logic to process emails from Bytbil and extract information from the email  

        //Call parent method to insert relevant entities
		insertEntities();
    } 
}