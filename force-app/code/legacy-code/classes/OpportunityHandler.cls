public with sharing class OpportunityHandler {
    public static void beforeHandler(List<Opportunity> trgNew) {
        Set<Id> userId = new Set<Id>();
        Map<Id, User> mapIdUser = new Map<Id, User>();        
        for(Opportunity op : trgNew){
            userId.add(op.OwnerId);
        }        
        for(User u : [SELECT Id, Name, BranchApprover__c, CountryApprover__c FROM User WHERE Id IN: userId]){
            mapIdUser.put(u.Id, u);
        }        
        for(Opportunity op:trgNew){
            op.BranchApprover__c = mapIdUser.get(op.OwnerId).BranchApprover__c;
            op.CountryApprover__c = mapIdUser.get(op.OwnerId).CountryApprover__c;
        }
    }

    public static void afterUpdateHandler(List<Opportunity> trgNew, Map<Id, Opportunity> oldMap){

        Map<Id, Opportunity> relevantRecords = new Map<Id, Opportunity>();

        for(Opportunity opportunity : trgNew){

            Opportunity oldOpportunity = oldMap.get(opportunity.Id);

            if(opportunity.StageName == 'Closed' && opportunity.StageName != oldOpportunity.StageName){
                relevantRecords.put(opportunity.Id, opportunity);
            }
            
        }

        if(!relevantRecords.values().isEmpty()){
            new OrderCreation().createOrder(relevantRecords);
        }

    }
}