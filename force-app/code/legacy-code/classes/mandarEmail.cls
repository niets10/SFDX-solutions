public class mandarEmail {
    
    //public Id owner {get; set;}
    public Id Id { get; set; }
    public Seguros__c seg { get; set; }
    
    
    //constructor to get the Case record
    //Si queremos un solo record se deja así. Si queremos todos se pone ApexPages.StandardSetController
    public mandarEmail(ApexPages.StandardController controller) {
        
        seg =  (Seguros__c) controller.getRecord();
        Id = seg.Id;
        System.debug('The case record: ' + seg);
        //owner = seg.OwnerId;
        //System.debug('The owner Id ' + owner);
    }
    
    public PageReference sendAttach() {
        
        Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
        
        //Referenciamos al pdf de la Visualforce
        PageReference pref = page.generadorPdf;
        pref.setRedirect(true);
        
        //Cogemos el pdf para meterlo en el cuerpo del email
        Blob pdfAdjunto = pref.getContent();
        
        attach.setFileName('Informe de Oportunidades.pdf');
        attach.setBody(pdfAdjunto);
        semail.setSubject('Informe de Oportunidades');
        
        //Seteamos los destinatarios
        List<String> sendTo = new List<String>{'agnieto00@gmail.com'};
        semail.setToAddresses(sendTo);
        semail.setPlainTextBody('Please find the attached book details');
        semail.setFileAttachments(new Messaging.EmailFileAttachment[]{attach});
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{semail});
        
        return null;
    }
    
}