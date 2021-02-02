public class trabajoConsObject {
    
    public static void creacionsObjectForma1(){
        
        //Crear un sObject tipo accounnt
        Schema.SObjectType accountType = Schema.getGlobalDescribe().get('Account');
        SObject myGenericSObject = accountType.newSObject();
        
        //Asignar el valor a un objeto Account
        Account acct = (Account)myGenericSObject;
        acct.Name = 'Carlos';
        acct.Phone = '9999';
        
        System.debug('*** '+acct);
        
    }
    
    public static void creacionsObjectForma2(){
        
        //Crear un sObject tipo account, solo puedo incializarla inmediatamente porque sino me da error
		sObject acct = new Account(Name='Carlos');
        
        //Para resolver el problema, hacemos los siguiente
		Account acct2 = (Account) acct;
        
        acct2.Name = 'Pedro';
        acct2.Phone = '98912';
        
        System.debug('*** '+acct2);     


        
    }
    
}