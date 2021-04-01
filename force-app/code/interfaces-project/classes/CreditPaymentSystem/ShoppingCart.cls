/*  The class will have a payment method of three types
 *  1. Credit type
 *  2. Debit type
 *  3. Crypto type   
 *
*/
public with sharing class ShoppingCart {

    //One way to do it would be with a method like this:
    //This will be hard to maintain
    // public void processPayment(String paymentType){
        
    //     if(paymentType == 'Credit'){
    //         processCreditPayment();
    //     }else if(paymentType == 'Debit'){
    //         processDebitPayment();
    //     }else if(paymentType == 'Crypto'){
    //         processCryptoPayment();
    //     }
    // }

    //Instead we will using classes and interfaces to loosely coupled our models

    IPaymentMethod paymentMethod;

    public ShoppingCart(IPaymentMethod paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public void processPayment(){
        this.paymentMethod.processPayment();
    }

    //At some point we can execute this with a command like:
    // IPaymentMethod paymentMethod = new DebitCardPaymentSystem();

    // ShoppingCart sc = new ShoppingCart(paymentMethod);
    // sc.processPayment();
}
