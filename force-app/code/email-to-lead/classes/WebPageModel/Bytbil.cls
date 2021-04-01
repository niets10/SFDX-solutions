public class Bytbil extends WebPage {
    
    private String emailBody;

    public BytBil(Messaging.InboundEmail email, String emailBody){
        // Messaging.InboundEmail e = new Messaging.InboundEmail();
        super(email);
        this.emailBody = emailBody;
    }

    public override void processWebPage(){
        // super(this.email);
        System.debug('Processing Bytbil...');
        String name = emailBody.substringBetween('Hej Rejmes Personvagnar AB!',' har just skickat ett meddelande till')?.trim();
		String emailAddress = emailBody.substringBetween('Återkoppla via e-post<mailto:','>');
		String phone = emailBody.substringBetween('Återkoppla via telefon: ','<tel:');

		insertEntities(name, emailAddress, phone, 'Blocket / Byt Bil', 'noreply@bytbil.com', 'BytBil');
    } 
}