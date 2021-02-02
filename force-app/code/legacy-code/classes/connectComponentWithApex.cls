public class connectComponentWithApex {
    
    @AuraEnabled
    public static void upsertEmpresa(Empresas__c empresa) {      
        upsert empresa;        
    }    
}