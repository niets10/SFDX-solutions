public with sharing class LMS_OpportunitySafepoint {

    @testVisible
    private static String safepoint = 'Safepoint';

    public static void setSafepoint(OpportunityLineItem[] trgNew) {
        
        Set<Id> setOppIds = new Set<Id>();  
        Opportunity[] lstToUpdate = new Opportunity[]{};  

        //Query to get Product2.Family
        OpportunityLineItem[] oppProducts = [SELECT Id, OpportunityId, Product2.Family FROM OpportunityLineItem WHERE Id IN: trgNew];
        for(OpportunityLineItem oProd:oppProducts){
            setOppIds.add(oProd.OpportunityId);
        }   

        Map<Id, Opportunity> oppsRelated = new Map<Id, Opportunity>([SELECT Id, LMS_SafepointOpportunity__c 
        FROM Opportunity WHERE Id IN: setOppIds]);

        for(OpportunityLineItem oProd:oppProducts){
            Opportunity opp = oppsRelated.get(oProd.OpportunityId);
            if(oProd.Product2.Family == safepoint){
                opp.LMS_SafepointOpportunity__c = true;
            }else{
                opp.LMS_SafepointOpportunity__c = false;
            }
            lstToUpdate.add(opp);
        }
        update lstToUpdate;
    }
   
    public static void generalMethod(OpportunityLineItem[] trgProducts) {
        
        Set<Id> setOppIds = new Set<Id>();  
        Opportunity[] lstToUpdate = new Opportunity[]{};

        for(OpportunityLineItem oProd:trgProducts){
            setOppIds.add(oProd.OpportunityId);
        }     

        //Select the Opportunity
        Map<Id, Opportunity> oppsRelated = new Map<Id, Opportunity>([SELECT Id, LMS_SafepointOpportunity__c 
        FROM Opportunity WHERE Id IN: setOppIds]);        

        //Select the Opportunity Line Items
        OpportunityLineItem[] oppProducts = [SELECT Id, OpportunityId, Product2.Family FROM OpportunityLineItem WHERE OpportunityId 
        IN: oppsRelated.keySet()];

        //If there's not any Opportunity Line Item
        //If we have a batch, we can have 1 Opp with 3 O.LineItem and 1 Opp with 0 O.LineItem.
        Map<Id, List<OpportunityLineItem>> mapIdOppProd = new Map<Id, List<OpportunityLineItem>>();
        for(OpportunityLineItem oProd:oppProducts){
            if(mapIdOppProd.containsKey(oProd.OpportunityId)){
                mapIdOppProd.get(oProd.OpportunityId).add(oProd);
            }else{
                mapIdOppProd.put(oProd.OpportunityId, new List<OpportunityLineItem>{ oProd });
            }   
        }

        for(Opportunity opp : oppsRelated.values()){
            //If there is not OLI for that Opportunity, the map won´t contain the key
            if(!mapIdOppProd.containsKey(opp.Id)){
                opp.LMS_SafepointOpportunity__c = false;
                lstToUpdate.add(opp);
            } 
        }

        //If there is at least one Opportunity Line Item
        for(OpportunityLineItem oProd:oppProducts){
            Opportunity opp = oppsRelated.get(oProd.OpportunityId);
            System.debug('*** Opp products delete ' + oProd);
            //If any of the product belongs to Safepoint, we exit the loop
            if(oProd.Product2.Family == safepoint){
                opp.LMS_SafepointOpportunity__c = true;
                if(!lstToUpdate.contains(opp)) lstToUpdate.add(opp);
                break;
            }else{
                opp.LMS_SafepointOpportunity__c = false;
                if(!lstToUpdate.contains(opp)) lstToUpdate.add(opp);
            }            
        }

        update lstToUpdate;

    }

    public static void afterInsert(OpportunityLineItem[] trgProducts) {
        
        Set<Id> setOppIds = new Set<Id>();  
        Opportunity[] lstToUpdate = new Opportunity[]{};  

        //Query to get Product2.Family
        //OpportunityLineItem[] oppProducts = [SELECT Id, OpportunityId, Product2.Family FROM OpportunityLineItem WHERE Id IN: trgNew];
        for(OpportunityLineItem oProd:trgProducts){
            setOppIds.add(oProd.OpportunityId);
        }     

        //Select the Opportunity
        Map<Id, Opportunity> oppsRelated = new Map<Id, Opportunity>([SELECT Id, LMS_SafepointOpportunity__c 
        FROM Opportunity WHERE Id IN: setOppIds]);        

        //Select the Opportunity Line Items
        OpportunityLineItem[] oppProducts = [SELECT Id, OpportunityId, Product2.Family FROM OpportunityLineItem WHERE OpportunityId 
        IN: oppsRelated.keySet()];

        for(OpportunityLineItem oProd:oppProducts){
            Opportunity opp = oppsRelated.get(oProd.OpportunityId);
            System.debug('*** Opp products delete ' + oProd);
            //If any of the product belongs to Safepoint, we exit the loop
            if(oProd.Product2.Family == safepoint){
                opp.LMS_SafepointOpportunity__c = true;
                if(!lstToUpdate.contains(opp)) lstToUpdate.add(opp);
                break;
            }else{
                opp.LMS_SafepointOpportunity__c = false;
                if(!lstToUpdate.contains(opp)) lstToUpdate.add(opp);
            }            
        }

        System.debug('*** List to update ' + lstToUpdate);
        update lstToUpdate;


    }

    /** 
    public static void afterUpdate(OpportunityLineItem[] trgNew, Map<Id, OpportunityLineItem> oldMap) {
        
        OpportunityLineItem[] oppProducts = new OpportunityLineItem[]{};

        for(OpportunityLineItem oProd:trgNew){
            OpportunityLineItem oldValue = oldMap.get(oProd.Id);
            if(oProd.OpportunityId != oldValue.OpportunityId || oProd.LMS_ProductFamily__c != oldValue.LMS_ProductFamily__c){
                oppProducts.add(oProd);
                System.debug('**** Product to update');
            }else{
                System.debug('**** Product NOT to update');
            }
        }

        //if(!oppProducts.isEmpty()) setSafepoint(trgNew);
        setSafepoint(trgNew);
    }

    */
}