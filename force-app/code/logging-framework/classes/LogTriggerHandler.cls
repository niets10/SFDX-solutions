/**
 @Name: LogTriggerHandler.cls
 @TestedBy: LogTriggerHandler_Test.cls
 @Other classes used: TriggerHandler
 @Description: Description:
    Using trigger handler to run Log Event
@Useage
    USE BYPASSES - Placing code between the bypasses ensures the code block will not get refired if another process fires this during the transaction:
    In each method, filter the list of inbound trigger data and decide which class to call
    The filters should avoid having the same record processed by more than one handler.
    Lists are more efficient than MAPs (x3) so use those if itterating where possible.
    Call each domain handler with their respective account records. 
 @History
  VERSION     AUTHOR                      DATE            DETAIL
  1.0         Álvaro González Nieto       12/1/2021       Draft
*/

public class LogTriggerHandler extends TriggerHandler {
    private static String TRIGGER_NAME;

    //Set trigger context variables
    private List<Log__e> newRecords;

    public LogTriggerHandler() {
        TRIGGER_NAME = String.valueOf(this).substring(0, String.valueOf(this).indexOf(':'));
        this.newRecords = (List<Log__e>) Trigger.new;
    }

    /**
     * @description Override aftert Insert
     */
    public override void afterInsert() {
        TriggerHandler.bypass(TRIGGER_NAME);  
        
        List<Log__e> logEvents = (List<Log__e>) trigger.new;
        List<LogObject__c> logsToInsert = new List<LogObject__c>();

        Integer i = 0;
        for(Log__e logEvent : logEvents){
            
            LogObject__c log = new LogObject__c();
            log.LogMessage__c = logEvent.Message__c;
            log.RequestId__c = logEvent.RequestId__c;
            log.Severity__c = logEvent.Severity__c;
            log.Quiddity__c = logEvent.Quiddity__c;

            logsToInsert.add(log);

        }

        insert logsToInsert;

        TriggerHandler.clearBypass(TRIGGER_NAME);
    }
}