public with sharing class DebitCardPaymentSystem implements IPaymentMethod{
    
    public Boolean processPayment(){
        System.debug('Process debit payment...');
        return true;
    }
}
