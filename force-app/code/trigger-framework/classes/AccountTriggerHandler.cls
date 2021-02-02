/**
 @Name: AccountTriggerHandler.cls
 @TestedBy: AccountTriggerHandler_Test.cls
 @Other classes used: TriggerHandler
 @Description: Description:
    Example of a trigger handler extending TriggerHandler. All trigger contexts are supported as an example,
    but we can delete the non used ones
@Useage
    USE BYPASSES - Placing code between the bypasses ensures the code block will not get refired if another process fires this during the transaction:
    In each method, filter the list of inbound trigger data and decide which class to call
    The filters should avoid having the same record processed by more than one handler.
    Lists are more efficient than MAPs (x3) so use those if itterating where possible.
    Call each domain handler with their respective account records. 
 @History
  VERSION     AUTHOR                      DATE            DETAIL
  1.0         Álvaro González Nieto       06/1/2021       Draft
*/

public class AccountTriggerHandler extends TriggerHandler {
    private static String TRIGGER_NAME;

    //Set trigger context variables
    private List<Account> newRecords;
    private List<Account> oldRecords;
    private Map<Id, Account> newMapRecords;
    private Map<Id, Account> oldMapRecords;

    public AccountTriggerHandler() {
        TRIGGER_NAME = String.valueOf(this).substring(0, String.valueOf(this).indexOf(':'));
        this.newRecords = (List<Account>) Trigger.new;
        this.oldRecords = (List<Account>) Trigger.old;
        this.newMapRecords = (Map<Id, Account>) Trigger.newMap;
        this.oldMapRecords = (Map<Id, Account>) Trigger.oldMap;
    }

    //newRecords and newMapRecords available
    public override void beforeInsert() {
        TriggerHandler.bypass(TRIGGER_NAME);

        TriggerHandler.clearBypass(TRIGGER_NAME);
    }

    //newRecords, newMapRecords, oldRecords, oldMapRecords available
    public override void beforeUpdate() {
        TriggerHandler.bypass(TRIGGER_NAME);

        TriggerHandler.clearBypass(TRIGGER_NAME);
    }

    //oldRecords, oldMapRecords available
    public override void beforeDelete() {
        TriggerHandler.bypass(TRIGGER_NAME);

        TriggerHandler.clearBypass(TRIGGER_NAME);
    }

    //newRecords and newMapRecords available
    public override void afterInsert() {
        TriggerHandler.bypass(TRIGGER_NAME);      

        TriggerHandler.clearBypass(TRIGGER_NAME);
    }

    //newRecords, newMapRecords, oldRecords, oldMapRecords available
    public override void afterUpdate() {
        TriggerHandler.bypass(TRIGGER_NAME);
        
        TriggerHandler.clearBypass(TRIGGER_NAME);
    }

    //oldRecords, oldMapRecords available
    public override void afterDelete() {
        TriggerHandler.bypass(TRIGGER_NAME);

        TriggerHandler.clearBypass(TRIGGER_NAME);
    }

    //newRecords available
    public override void afterUnDelete() {
        TriggerHandler.bypass(TRIGGER_NAME);

        TriggerHandler.clearBypass(TRIGGER_NAME);
    }
}