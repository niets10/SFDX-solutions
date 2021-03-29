public with sharing class CreditCardPaymentSystem implements IPaymentMethod{

    public Boolean processPayment(){
        System.debug('Process credit payment...');
        return true;
    }
}
