/**
 @Name: TriggerHandler.cls
 @TestedBy: TriggerHandler.cls
 @Other classes used: Trigger handlers extend this class
 @Description: Description:
    Trigger pattern using Kevin O'Hara's trigger framework. Copyright and credits to Kevin O'Hara.
    Refactored by Releye to fit business requirements.
 @History
  VERSION     AUTHOR                      DATE            DETAIL
  1.0         Álvaro González Nieto       06/1/2021       Draft
*/
public virtual class TriggerHandler {

  private static Set<String> bypassedHandlers;

  private TriggerContext context;

  @TestVisible
  private Boolean isTriggerExecuting;

  static {
    bypassedHandlers = new Set<String>();
  }

  public TriggerHandler() {
    //Method to initialize
    this.setTriggerContext();
  }

  public void run() {
    //Validate run
    if (!validateRun())
      return;

    switch on this.context {
      when BEFORE_INSERT {
        this.beforeInsert();
      }
      when BEFORE_UPDATE {
        this.beforeUpdate();
      }
      when BEFORE_DELETE {
        this.beforeDelete();
      }
      when AFTER_INSERT {
        this.afterInsert();
      }
      when AFTER_UPDATE {
        this.afterUpdate();
      }
      when AFTER_DELETE {
        this.afterDelete();
      }
      when AFTER_UNDELETE {
        this.afterUnDelete();
      }
    }
  }

  //Set trigger context for execution in the trigger
  @TestVisible
  private void setTriggerContext() {
    //Pass null as parameter since it will be set in the calling method, and false as we are not executing test
    this.setTriggerContext(null, false);
  }

  //Parameters will null and false from trigger execution, but will be populated to the trigger context and true from test execution
  @TestVisible
  private void setTriggerContext(String testingContext, Boolean testMode) {
    //If we are not executing the trigger and we are not in test mode, we kill the process
    if (!Trigger.isExecuting && !testMode) {
      this.isTriggerExecuting = false;
      return;
    } else {
      this.isTriggerExecuting = true;
    }

    if (
      (Trigger.isExecuting && Trigger.isBefore && Trigger.isInsert) ||
      (testingContext != null && testingContext == 'before insert')
    ) {
      this.context = TriggerContext.BEFORE_INSERT;
    } else if (
      (Trigger.isExecuting && Trigger.isBefore && Trigger.isUpdate) ||
      (testingContext != null && testingContext == 'before update')
    ) {
      this.context = TriggerContext.BEFORE_UPDATE;
    } else if (
      (Trigger.isExecuting && Trigger.isBefore && Trigger.isDelete) ||
      (testingContext != null && testingContext == 'before delete')
    ) {
      this.context = TriggerContext.BEFORE_DELETE;
    } else if (
      (Trigger.isExecuting && Trigger.isAfter && Trigger.isInsert) ||
      (testingContext != null && testingContext == 'after insert')
    ) {
      this.context = TriggerContext.AFTER_INSERT;
    } else if (
      (Trigger.isExecuting && Trigger.isAfter && Trigger.isUpdate) ||
      (testingContext != null && testingContext == 'after update')
    ) {
      this.context = TriggerContext.AFTER_UPDATE;
    } else if (
      (Trigger.isExecuting && Trigger.isAfter && Trigger.isDelete) ||
      (testingContext != null && testingContext == 'after delete')
    ) {
      this.context = TriggerContext.AFTER_DELETE;
    } else if (
      (Trigger.isExecuting && Trigger.isAfter && Trigger.isUndelete) ||
      (testingContext != null && testingContext == 'after undelete')
    ) {
      this.context = TriggerContext.AFTER_UNDELETE;
    }
  }

  /************************** 
            Validate run
    ***************************/
  private Boolean validateRun() {
    
    //If we are not executing the trigger or the context is null, then it means we are calling the method from another class,
    //so we throw an exeception
    if(!this.isTriggerExecuting || this.context == null){
      throw new HandlerException('Handler is being called outside the trigger context');
    }
    //If the handler name was added, then run method should not be executed
    if (bypassedHandlers.contains(this.getHandler())) {
      return false;
    }

    return true;
  }

  public static void bypass(String handlerName) {
    bypassedHandlers.add(handlerName);
  }

  //Method to be used in case we want to execute some logic when we bypass logic
  public static Boolean isBypassed(String handlerName){
      return bypassedHandlers.contains(handlerName);
  }

  public static void clearBypass(String handlerName) {
    bypassedHandlers.remove(handlerName);
  }

  @TestVisible
  private String getHandler() {
    return String.valueOf(this).substring(0, String.valueOf(this).indexOf(':'));
  }

  //Override methods
  @TestVisible
  protected virtual void beforeInsert() {
  }
  @TestVisible
  protected virtual void beforeUpdate() {
  }
  @TestVisible
  protected virtual void beforeDelete() {
  }
  @TestVisible
  protected virtual void afterInsert() {
  }
  @TestVisible
  protected virtual void afterUpdate() {
  }
  @TestVisible
  protected virtual void afterDelete() {
  }
  @TestVisible
  protected virtual void afterUnDelete() {
  }

  //Generate TriggerContext
  private enum TriggerContext {
    BEFORE_INSERT,
    BEFORE_UPDATE,
    BEFORE_DELETE,
    AFTER_INSERT,
    AFTER_UPDATE,
    AFTER_DELETE,
    AFTER_UNDELETE
  }

  //Add exception class to throw an error when this class is called outside a trigger
  public class HandlerException extends Exception {}
}