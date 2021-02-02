trigger Opportunity on Opportunity (before update, before insert, after insert, after update) {
    
    if(trigger.isBefore){
        if(trigger.isInsert){        
            PopulateLookups.lookupsOpps(trigger.new);
            //LMS_OpportunityService.setPriceBook(trigger.new);
        }
        if(trigger.isUpdate){        
            PopulateLookups.lookupsOpps(trigger.new, trigger.oldMap);
        }
    }
       
    
}