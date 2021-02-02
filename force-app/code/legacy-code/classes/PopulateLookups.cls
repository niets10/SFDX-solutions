public class PopulateLookups {
    
    public static void lookupsOpps(List<Opportunity> trgNew) {
        
        OpportunityHandler.beforeHandler(trgNew);
    }
    
    public static void lookupsOpps(List<Opportunity> trgNew, Map<Id, Opportunity> oldMap){
        
        for(Opportunity  t:trgNew){                        
            if(oldMap.get(t.Id).OwnerId != t.OwnerId || oldMap.get(t.Id).Type != t.Type){
                System.debug('Changes');
            }else{
                System.debug('No changes');                
            }
        }
    }
    
}