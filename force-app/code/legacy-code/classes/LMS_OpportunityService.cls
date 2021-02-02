public with sharing class LMS_OpportunityService {
    public static void setPriceBook(Opportunity[] lstOpportunity) {

        //Select Standard Pricebook
        Pricebook2 pb2 = [select Id, Name, IsActive 
                  FROM PriceBook2 WHERE IsStandard=True LIMIT 1];
        
        System.debug('Pb ' + pb2);

        for(Opportunity op:lstOpportunity){
                op.Pricebook2Id = pb2.Id;
        }
    }
}