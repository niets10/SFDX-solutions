public with sharing class queryAccounts {
    @AuraEnabled
    public static List<Account> findAccount(){
        System.debug('Funciona');
        List<Account> acct = [SELECT Name, Description, BillingCountry, BillingCity, BillingPostalCode, BillingStreet, BillingState
                FROM Account
                WHERE BillingCountry != null
                AND BillingCity != null];
        
        System.debug('La cuenta es ' +acct);
        return acct;
    }
    
}