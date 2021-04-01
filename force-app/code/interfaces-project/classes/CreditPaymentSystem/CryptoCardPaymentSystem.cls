public with sharing class CryptoCardPaymentSystem implements IPaymentMethod{

    public Boolean processPayment(){
        System.debug('Process crypto payment...');
        return true;
    }
    
}
