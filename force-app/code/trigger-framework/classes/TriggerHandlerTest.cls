/**********************************************************************
 Name: TriggerHandler_Test.cls
 Other classes used: TriggerHandler.cls
======================================================
Description:
    Trigger pattern using Kevin O'Hara's trigger framework. Copyright and credits to Kevin O'Hara.
    Refactored by Releye to fit business requirements.
======================================================
History
-------
VERSION       AUTHOR                      DATE            DETAIL
  1.0         Álvaro González Nieto       06/1/2021       Draft
***********************************************************************/
@isTest
private class TriggerHandlerTest {
  private static TestHandler testHandler;
  private static String executedMethod;

  static {
    testHandler = new TestHandler();
    //Set isTriggerExecuting to true
    testHandler.isTriggerExecuting = true;
  }

  //Before insert
  @isTest
  static void testBeforeInsert() {
    testHandler.setTriggerContext('before insert', true);
    testHandler.run();
    System.assertEquals('beforeInsert', executedMethod);
  }

  //Before update
  @isTest
  static void testBeforeUpdate() {
    testHandler.setTriggerContext('before update', true);
    testHandler.run();
    System.assertEquals('beforeUpdate', executedMethod);
  }

  //Before delete
  @isTest
  static void testBeforeDelete() {
    testHandler.setTriggerContext('before delete', true);
    testHandler.run();
    System.assertEquals('beforeDelete', executedMethod);
  }

  //After insert
  @isTest
  static void testAfterInsert() {
    testHandler.setTriggerContext('after insert', true);
    testHandler.run();
    System.assertEquals('afterInsert', executedMethod);
  }

  //After update
  @isTest
  static void testAfterUpdate() {
    testHandler.setTriggerContext('after update', true);
    testHandler.run();
    System.assertEquals('afterUpdate', executedMethod);
  }

  //After delete
  @isTest
  static void testAfterDelete() {
    testHandler.setTriggerContext('after delete', true);
    testHandler.run();
    System.assertEquals('afterDelete', executedMethod);
  }

  //After undelete
  @isTest
  static void testAfterUndelete() {
    testHandler.setTriggerContext('after undelete', true);
    testHandler.run();
    System.assertEquals('afterUndelete', executedMethod);
  }

  //Test handler outside trigger context
  @isTest
  static void testHandlerOutsideTrigger(){
    try {
      testHandler.run();      
    }catch(TriggerHandler.HandlerException he){
      System.assertEquals('Handler is being called outside the trigger context', he.getMessage());
    }
  }

  //Test virtual methods
  @isTest
  static void testVirtualMethods(){
      TriggerHandler testVirtualHandler = new TriggerHandler();
      testVirtualHandler.beforeInsert();
      testVirtualHandler.beforeUpdate();
      testVirtualHandler.beforeDelete();
      testVirtualHandler.afterInsert();
      testVirtualHandler.afterUpdate();
      testVirtualHandler.afterDelete();
      testVirtualHandler.afterUnDelete();      
  }

  //Test bypass
  @isTest
  static void testBypass(){
      testHandler.setTriggerContext('before insert', true);
      TriggerHandler.bypass('TestHandler');
      testHandler.run();
      //No method will be executed this time, so executedMethod will be empty
      System.assertEquals(null, executedMethod);
      System.assertEquals(true, TriggerHandler.isBypassed('TestHandler'));
      
      TriggerHandler.clearBypass('TestHandler');
      testHandler.run();
      System.assertEquals('beforeInsert', executedMethod);
      System.assertEquals(false, TriggerHandler.isBypassed('TestHandler'));
  }

  //Test getHandler
  @isTest
  static void testGetHandler(){
      System.assertEquals('TestHandler', testHandler.getHandler());
  }

  //Extend TriggerHandler to mock the methods as if it was an specific test of a functionality
  private class TestHandler extends TriggerHandler {
    public override void beforeInsert() {
      executedMethod = 'beforeInsert';
    }

    public override void beforeUpdate() {
      executedMethod = 'beforeUpdate';
    }

    public override void beforeDelete() {
      executedMethod = 'beforeDelete';
    }

    public override void afterInsert() {
      executedMethod = 'afterInsert';
    }

    public override void afterUpdate() {
      executedMethod = 'afterUpdate';
    }

    public override void afterDelete() {
      executedMethod = 'afterDelete';
    }

    public override void afterUnDelete() {
      executedMethod = 'afterUndelete';
    }
  }
}