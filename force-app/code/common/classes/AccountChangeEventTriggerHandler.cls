/**
 @Name: AccountChangeEventTriggerHandler.cls
 @Other classes used: TriggerHandler
 @Description: Description:
    Example of a trigger handler extending TriggerHandler.
*/
public class AccountChangeEventTriggerHandler extends TriggerHandler {

    private static String TRIGGER_NAME;

    //Set trigger context variables
    private List<AccountChangeEvent> newRecords;

    public AccountChangeEventTriggerHandler() {

        TRIGGER_NAME = String.valueOf(this).substring(0, String.valueOf(this).indexOf(':'));
        this.newRecords = (List<AccountChangeEvent>) Trigger.new;

    }

    public override void afterInsert() {
        TriggerHandler.bypass(TRIGGER_NAME);  
        
        TaskCreation t = new TaskCreation(newRecords);
        t.insertTask();

        TriggerHandler.clearBypass(TRIGGER_NAME);
    }
}
