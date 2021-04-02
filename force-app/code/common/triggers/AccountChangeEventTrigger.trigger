trigger AccountChangeEventTrigger on AccountChangeEvent (after insert) {
    System.debug('Account Change Event');
    new AccountChangeEventTriggerHandler().run();
}