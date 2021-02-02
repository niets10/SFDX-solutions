public class BigObjectController {
   
    @AuraEnabled(cacheable = true)
    public static List<LogBigObject__b> getLogRecords(){
        
        List<LogBigObject__b> logs = [SELECT Id, RequestId__c, LogMessage__c, CreatedDate FROM LogBigObject__b];

        System.debug(logs);
        return logs;

    }    

}

