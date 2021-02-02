public class ProductAssociationLogic {
    
    public static void markFirstDepot(List<Product_Depot_Association__c> triggerNew){
        
        Set<Id> productIds = new Set<Id>();        
        for(Product_Depot_Association__c pda : triggerNew){
            productIds.add(pda.Product__c);            
        }
        
        List<Product2> productsInvolved = [SELECT Id, Name, (SELECT Id, Product__c, Depot__c, First_Depot__c FROM Product_Depot_Associations__r) 
                                           FROM Product2 WHERE Id IN: productIds];
        
        Map<Id, List<Product_Depot_Association__c>> mapProductDepot = new Map<Id, List<Product_Depot_Association__c>>();
        for(Product2 p : productsInvolved){
            mapProductDepot.put(p.Id, p.Product_Depot_Associations__r);
        }
        
        System.debug('Map ' + mapProductDepot);
        
        Boolean alreadyFirstDepot = false;
        for(Product_Depot_Association__c pda : triggerNew){
            
            List<Product_Depot_Association__c> depots = mapProductDepot.get(pda.Product__c);
            
            //If it's the first depot of the Product, we update the First_Depot__c;
            if(depots.isEmpty()){
                pda.First_Depot__c = true;
                
                //Add the Product Depot Association from trigger new which will not be queried
                depots.add(pda);
                mapProductDepot.put(pda.Product__c, depots);
                
            }else{
                for(Product_Depot_Association__c depot : depots){
                    if(depot.First_Depot__c){
                        alreadyFirstDepot = true;
                        break;
                    }
                }
                
                if(!alreadyFirstDepot){
                    pda.First_Depot__c = true;
                }
                
                //Add the Product Depot Association from trigger new which will not be queried
                depots.add(pda);
                mapProductDepot.put(pda.Product__c, depots);
            }            
        }        
    }
    
    public static void avoidDuplicates(List<Product_Depot_Association__c> triggerNew){        
        
        Set<Id> productIds = new Set<Id>();
        Set<Id> depotIds = new Set<Id>();        
        for(Product_Depot_Association__c pda : triggerNew){
            productIds.add(pda.Product__c);
        }
        
        Map<Id, Set<Id>> productIddepotIds = new Map<Id, Set<Id>>();
        for(Product2 p : [SELECT Id, Name, (SELECT Id, Product__c, Depot__c FROM Product_Depot_Associations__r) 
                          FROM Product2 WHERE Id IN: productIds]){            
                              for(Product_Depot_Association__c pda : p.Product_Depot_Associations__r){
                                  if(productIddepotIds.containsKey(p.Id)){
                                      productIddepotIds.get(p.Id).add(pda.Depot__c);  
                                  }else{
                                      productIddepotIds.put(p.Id, new Set<Id>{ pda.Depot__c });
                                  }
                              }
                          }
        
        for(Product_Depot_Association__c pda : triggerNew){
            //Error if for a Product Depot, there's already a record related to the same Product and Depot (logic added in case of bulk insert)
            Set<Id> depots = new Set<Id>();
            if(productIddepotIds.containsKey(pda.Product__c)){                
                depots = productIddepotIds.get(pda.Product__c); 
            }
            
            if(!depots.isEmpty()){
                if(depots.contains(pda.Depot__c)){
                    pda.addError('Duplicates are not allowed');
                }  
            }
            //Add the ones from the trigger new so they're not inserted in a bulk process
            depots.add(pda.Depot__c);
            productIddepotIds.put(pda.Product__c, depots);
        }
        
    }
    
}