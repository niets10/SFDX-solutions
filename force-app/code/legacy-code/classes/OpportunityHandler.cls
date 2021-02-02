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
}