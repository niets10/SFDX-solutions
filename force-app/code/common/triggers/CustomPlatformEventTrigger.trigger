trigger CustomPlatformEventTrigger on CustomPlatformEvent__e (after insert) {

    if(trigger.isAfter && trigger.isInsert){
        CustomPlatformEventClass.insertNewCase(trigger.new);
    }
}