public class UpdateSeguro {
    
    public static void updateChild (List<Empresas__c> newList){
        
        List<Seguros__c> seguros = [SELECT Id, Price__c, Descripcion__c FROM Seguros__c
                                    WHERE Empresa__c =: newList[0].Id];
        
        List<Seguros__c> segurosToUpdate = new List<Seguros__c>();
        for(Seguros__c s : seguros){
            s.Price__c = 190;
            s.Descripcion__c = 'Update with After Trigger';
            
            segurosToUpdate.add(s);
        }
        
        update segurosToUpdate;
        
    }
    
    public static void updateRecord (List<Seguros__c> newList){
      
        for(Seguros__c s : newList){
            if(s.Price__c > 100){
                s.addError('Price cannot be more than 100');
            }
        }
        
    }
}