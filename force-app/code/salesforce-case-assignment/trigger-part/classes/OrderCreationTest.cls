@isTest
private class OrderCreationTest {

    static Boolean bulkify = false;
    static Integer recordsToInsert = bulkify ? 20 : 1;
    
    @TestSetup
    static void makeData(){

        List<Product2> products = new List<Product2>();
        List<PricebookEntry> priceBookEntries = new List<PricebookEntry>();
        List<Opportunity> opportunities = new List<Opportunity>();
        List<OpportunityLineItem> opportunityProducts = new List<OpportunityLineItem>();

        //Create Account
        Account account = new Account();
        account.Name = 'Test Account';
        
        insert account;

        Id priceBookId = Test.getStandardPricebookId();

        //Create Products
        for(Integer i = 0; i < 4; i++) {

            Product2 product = new Product2();
            product.Name = 'Product' + i;
            product.ProductCode = 'EX1234' + i;
            product.IsActive = true;

            products.add(product);
        }

        insert products;

        //Create Pricebook Entries
        Integer price = 0;
        for(Product2 product : products){
                
            PricebookEntry priceBookEntry = new PricebookEntry();
            priceBookEntry.Pricebook2Id = priceBookId;
            priceBookEntry.Product2Id = product.Id;
            priceBookEntry.UnitPrice = 100.00 + price;
            priceBookEntry.IsActive = true;
        
            price += 20;

            priceBookEntries.add(priceBookEntry);

        }

        insert priceBookEntries;

        //Create Opportunities
        for(Integer i = 0; i < recordsToInsert; i++){

            Opportunity opportunity = new Opportunity();
            opportunity.Name = 'Opportunity Test' + i;
            opportunity.AccountId = account.Id;
            opportunity.CloseDate = Date.today() + 1;
            opportunity.Pricebook2Id = priceBookId;
            opportunity.StageName = 'Prospecting';

            opportunities.add(opportunity);
        }        

        insert opportunities;

        //Create Opportunity Products
        for(Opportunity opportunity : opportunities){

            Integer counter = 0;

            for(Product2 product : products){            
            
                OpportunityLineItem opportunityLineItem = new OpportunityLineItem();
                opportunityLineItem.OpportunityId = opportunity.Id;
                opportunityLineItem.Product2Id = product.Id;
                opportunityLineItem.Quantity = 1;
                opportunityLineItem.PricebookEntryId = priceBookEntries[counter].Id;
                opportunityLineItem.UnitPrice = priceBookEntries[counter].UnitPrice;

                counter++;
                opportunityProducts.add(opportunityLineItem);
            }
        }

        insert opportunityProducts;
    }

    @isTest
    private static void testInsertedData(){

        Integer account = [SELECT COUNT() FROM Account];
        Integer products = [SELECT COUNT() FROM Product2];
        Integer opportunities = [SELECT COUNT() FROM Opportunity];
        Integer opportunityProducts = [SELECT COUNT() FROM OpportunityLineItem];

        System.assertEquals(1, account, 'The inserted number of accounts is not correct');
        System.assertEquals(4, products, 'The inserted number of products is not correct');

        if(bulkify){
            System.assertEquals(20, opportunities, 'The inserted number of opportunities is not correct');
            System.assertEquals(80, opportunityProducts, 'The inserted number of opportunity products is not correct');
        }else {
            System.assertEquals(1, opportunities, 'The inserted number of opportunities is not correct');
            System.assertEquals(4, opportunityProducts, 'The inserted number of opportunity products is not correct');
        }

    }

    @isTest
    private static void testClosingOpportunity(){

        List<Opportunity> opportunities = [SELECT Id, StageName, AccountId, CloseDate, Pricebook2Id,
        (SELECT Id, Product2Id, Quantity, UnitPrice, TotalPrice, PricebookEntryId FROM OpportunityLineItems)         
        FROM Opportunity];

        List<OpportunityLineItem> opportunityLineItems = [SELECT Id, Product2Id, Quantity, UnitPrice, TotalPrice, PricebookEntryId FROM OpportunityLineItem];
        List<OrderItem> orderItems = [SELECT Id, Product2Id, Quantity, UnitPrice, TotalPrice, PricebookEntryId FROM OrderItem];


        System.debug(opportunities.size());

        List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();

        for(Opportunity opportunity : opportunities){

            opportunity.StageName = 'Closed';
            opportunitiesToUpdate.add(opportunity);

        }

        update opportunitiesToUpdate;

        List<Order> orders = [SELECT Pricebook2Id, OpportunityId, AccountId, EffectiveDate, Status FROM Order];
        
        System.debug(orders.size());

        //Verify Order
        Integer counter = 0;
        for(Order order : orders){

            System.assertEquals(opportunities[counter].Pricebook2Id, order.Pricebook2Id);
            System.assertEquals(opportunities[counter].Id, order.OpportunityId);
            System.assertEquals(opportunities[counter].AccountId, order.AccountId);
            System.assertEquals(opportunities[counter].CloseDate, order.EffectiveDate);            
            System.assertEquals('Draft', order.Status);

            counter++;
        }

        //Verify Order Products
        Integer secondCounter = 0;
        for(OrderItem orderItem : orderItems){

            System.assertEquals(opportunityLineItems[secondCounter].PricebookEntryId, orderItem.PricebookEntryId);
            System.assertEquals(opportunityLineItems[secondCounter].Product2Id, orderItem.Product2Id);
            System.assertEquals(opportunityLineItems[secondCounter].Quantity, orderItem.Quantity);
            System.assertEquals(opportunityLineItems[secondCounter].UnitPrice, orderItem.UnitPrice);  

            secondCounter++;

        }

    }

}
