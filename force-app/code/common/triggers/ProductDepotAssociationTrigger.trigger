trigger ProductDepotAssociationTrigger on Product_Depot_Association__c (before insert) {
    
    ProductAssociationLogic.avoidDuplicates(Trigger.new);
    ProductAssociationLogic.markFirstDepot(Trigger.new);
}