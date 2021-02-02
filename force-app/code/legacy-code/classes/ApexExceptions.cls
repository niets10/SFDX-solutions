public class ApexExceptions {
    
    public static void failureOnInsert(){

        /* try {
            
            Empresas__c e = new Empresas__c(Name = '2222');

            insert e;

        } catch (Exception e) {
            
            System.debug('Exception ' + e.getMessage());
            throw new MyException('This is bad');
        } */

        Empresas__c e = new Empresas__c(Name = '2222');

        insert e;
        

    }

    public class MyException extends Exception {}

}