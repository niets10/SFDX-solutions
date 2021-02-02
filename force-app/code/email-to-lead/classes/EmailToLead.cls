global class EmailToLead implements Messaging.InboundEmailHandler {
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
                
        System.debug('Name ' + email.fromName);
        System.debug('Address ' + email.fromAddress);

        Lead l = new Lead();
        l.LastName = email.fromName;
        l.Email = email.fromAddress;
        l.Company = 'Created from Blocket';

        insert l;

        return result;
    }
}