public class CustomListViews {

    public static void getMetadataFields(){
         
        String objectAPIName = 'Seguros__c';        
        MyRelatedList__mdt[] segurosFields = [SELECT FieldAPIName__c
                                              FROM MyRelatedList__mdt 
                                              WHERE ObjectAPIName__c =: objectAPIName];
        
        List<String> fields = new List<String>();
        for(MyRelatedList__mdt m : segurosFields){
            fields.add(m.FieldAPIName__c);
        }
        
        String field = String.join(fields,',');
       
        String q = 'SELECT ' + field + ' FROM '+objectAPIName;
        List<sObject> sobjList = Database.query(q);
        
        System.debug(sobjList);

        
        
        
    }
    
}