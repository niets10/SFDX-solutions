@isTest
public with sharing class LMS_OpportunityService_TEST {

    private static Opportunity opp;
    private static Id pricebookId;

    @TestSetup
    public static void testSetup() {

        Id pricebookId = Test.getStandardPricebookId();
        Pricebook2 customPB = new Pricebook2(Id = pricebookId,
        isActive=true);
        update customPB;

        opp = new Opportunity(Name = 'Test Opp', ForecastCategoryName = 'Pipeline',
        CloseDate = Date.today() + 10, StageName = 'Prospecting');

        insert opp;

    }

    @isTest
    public static void beforeInsert(){
        testSetup();

        pricebookId = Test.getStandardPricebookId();

        opp = [SELECT Id, Name, Pricebook2Id FROM Opportunity WHERE Id =: opp.Id];
        System.assertEquals(pricebookId, opp.Pricebook2Id, 'The Pricebook is not the standard');
    }
}