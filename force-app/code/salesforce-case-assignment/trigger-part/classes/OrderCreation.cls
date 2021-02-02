public class OrderCreation {


    

    private void createOrder(Map<Id, Opportunity> newMap){

        List<Order> ordersToInsert = new List<Order>();

        List<Opportunity> opportunities = [SELECT Id, AccountId, CloseDate, Pricebook2Id,
                                            (SELECT Id, Product2Id, Quantity, UnitPrice, TotalPrice, PricebookEntryId FROM OpportunityLineItems)         
                                            FROM Opportunity WHERE Id IN: newMap.keySet()];

        for(Opportunity opportunity : opportunities){

            Order order = new Order();
            order.Pricebook2Id = opportunity.Pricebook2Id;
            order.OpportunityId = opportunity.Id;
            order.AccountId = opportunity.AccountId;
            order.EffectiveDate = opportunity.CloseDate;
            order.Status = 'Draft';

            ordersToInsert.add(order);
        }

        insert ordersToInsert;

        List<OrderItem> orderItemsToInsert = this.generateOrderItems(opportunities, ordersToInsert);

        insert orderItemsToInsert;        


    }

    private List<OrderItem> generateOrderItems(List<Opportunity> opportunities, List<Order> insertedOrders){
        
        List<OrderItem> orderItemsToInsert = new List<OrderItem>();
        Map<Id, Id> mapOpportunityIdOrderId = new Map<Id, Id>();

        for(Order insertedOrder : insertedOrders){
            mapOpportunityIdOrderId.put(insertedOrder.OpportunityId, insertedOrder.Id);
        }

        for(Opportunity opportunity : opportunities){

            //Get relatedOrderId
            Id orderId = mapOpportunityIdOrderId.get(opportunity.Id);

            for(OpportunityLineItem opportunityLineItem : opportunity.OpportunityLineItems){

                OrderItem orderItem = new OrderItem();
                orderItem.OrderId = orderId;
                orderItem.PricebookEntryId = opportunityLineItem.PricebookEntryId;
                orderItem.Product2Id = opportunityLineItem.Product2Id;
                orderItem.Quantity = opportunityLineItem.Quantity;
                orderItem.UnitPrice = opportunityLineItem.UnitPrice;

                orderItemsToInsert.add(orderItem);

            }

        }

        return orderItemsToInsert;

    }

}
