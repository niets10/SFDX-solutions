public class conectApexWithComponent {
    
    @AuraEnabled
    public static List<Empresas__c> queryMethod() {
        
        return [SELECT Id, Name, CIF__c FROM Empresas__c];       
        
    }

}