trigger OpportunityProductTrigger on OpportunityLineItem (after insert, after update, after delete, before delete) {

    if(trigger.isAfter && trigger.isInsert){
        LMS_OpportunitySafepoint.generalMethod(Trigger.new);
    }

    /*if(trigger.isAfter && trigger.isUpdate){
        LMS_OpportunitySafepoint.afterUpdate(Trigger.new, Trigger.oldMap);
    }*/

    if(trigger.isAfter && trigger.isDelete){
        LMS_OpportunitySafepoint.generalMethod(Trigger.old);
    }
}