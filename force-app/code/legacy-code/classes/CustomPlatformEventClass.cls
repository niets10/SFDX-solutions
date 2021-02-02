public class CustomPlatformEventClass {

    //Example of a method to process the subscription of a trigger to a platform event called CustomPlatformEvent__e
    public static void insertNewCase(List<CustomPlatformEvent__e> newTrigger){
        
        List<Case> cases = new List<Case>();
        
        System.debug('Custom Platform Event ' + newTrigger);
        
        for(CustomPlatformEvent__e ev : newTrigger){
            if(ev.Urgent__c && (ev.AutomationToUse__c == 'Trigger')){
                Case c = new Case();
                c.Origin = 'Platform Event';
                c.Subject = ev.Description__c;
                
                cases.add(c);
            }
        }
        
        insert cases;
        
    }
    
}