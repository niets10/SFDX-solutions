/*
* For the insurances under a company, we need to have one and only one main insurance

*/

public class MainSeguro {
    
    public static void filterInsurances(List<Seguros__c> newList, Map<Id, Seguros__c> oldMap){
        
        
        Set<Seguros__c> setSeguros = new Set<Seguros__c>();
        
        for(Seguros__c s : newList){           
            Seguros__c oldRecord = oldMap.get(s.Id);
            
            if(s.Main_Seguro__c != oldRecord.Main_Seguro__c){
                setSeguros.add(s);
            }            
        }
        
        if(!setSeguros.isEmpty()){
            List<Seguros__c> insurances = new List<Seguros__c>(setSeguros);
            avoidSeveralMainInsurances(insurances);
        }
        
    }
    
    public static void avoidSeveralMainInsurances(List<Seguros__c> insurances){
        
        Set<Id> parentIds = new Set<Id>();
        Set<Id> mainSeguros = new Set<Id>();
        for(Seguros__c s : insurances){
            parentIds.add(s.Empresa__c);
        } 
        
        List<Empresas__c> empresasInvolved = [SELECT Id, (SELECT Id, Name, Main_Seguro__c FROM Seguros__r)
                                              FROM Empresas__c WHERE Id IN: parentIds];
        
        Set<Empresas__c> setEmpresasInvolved = new Set<Empresas__c>(empresasInvolved);
        
        /*Set<Empresas__c> filteredEmpresas = new Set<Empresas__c>();
        for(Empresas__c e : setEmpresasInvolved){
            setEmpresasInvolved.removeAll(insurances);
        }
        
        for(Empresas__c e : empresasInvolved){ 
            System.debug('Num of seguros ' + e.Seguros__r);
            for(Seguros__c s : e.Seguros__r){
                if(s.Main_Seguro__c){
                    mainSeguros.add(s.Id);
                }
            }            
        }*/
        
        System.debug('Num of main seguros ' + mainSeguros.size());
        
        //If in the query is at least one main seguro, we throw an error.
        if(mainSeguros.size() > 0){
            System.debug('Error');
        }else{
            System.debug('No Error');
        }
        
        
    }
    
}