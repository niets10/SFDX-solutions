public abstract class WebPage {
    
    private static Log logger = Log.get();
	private Messaging.InboundEmail email;
    
    public WebPage(Messaging.InboundEmail email) {
        this.email = email;
    }

    /**
    * @description: All the classes extending this one will need to implement this method  
    */
    public abstract void processWebPage();
   
    /**
    * @description: This method will perform some logic...    
    */
    protected void insertEntities(){
        //Relevant logic
    }
}