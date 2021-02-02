trigger SegurosTrigger on Seguros__c (after insert, after update, before update, before insert) {
    
    // if(trigger.isBefore && trigger.isUpdate){
    //     MainSeguro.filterInsurances(Trigger.new, Trigger.oldMap);
    //     RandomApex.triggerOnFormula(Trigger.new, Trigger.oldMap);
    // }
    
    // if(trigger.isBefore && trigger.isInsert){
    //     MainSeguro.avoidSeveralMainInsurances(Trigger.new);        
    // }

    // if(trigger.isAfter && trigger.isInsert){
    //     //ApexExceptions.failureOnInsert();
    // }
    

}