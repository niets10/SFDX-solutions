public with sharing class mapaEmpresas {
    @AuraEnabled
    public static List<Location> findAll(){
        System.debug('Funciona');
        
        List<Empresas__c> emps = [SELECT Id, Name, Location__Latitude__s, Location__Longitude__s
                                  FROM Empresas__c
                                  WHERE Location__Latitude__s != NULL AND Location__Longitude__s != NULL];
        
        System.debug('La cuenta es ' +emps);
        
        
        List<Location> loc = new List<Location>();
        for(Empresas__c em : emps){
            Location locDetail = new Location();
            locDetail.icon = 'action:map'; 
            locDetail.title = em.Name;
            locDetail.description = em.Name;
            locDetail.location = new Geolocation(em.Location__Longitude__s, em.Location__Latitude__s);
            
            loc.add(locDetail);
        }
        
        System.debug('La localización es ' +loc);        
        return loc;
    }
    
    public class Location{
        @AuraEnabled 
        public String icon{get;set;} 
        @AuraEnabled 
        public String title{get;set;} 
        @AuraEnabled
        public String description{get;set;} 
        @AuraEnabled 
        public GeoLocation location{get;set;} 
    }
    
    public class GeoLocation{
        @AuraEnabled 
        public Decimal Longitude{get;set;}
        @AuraEnabled 
        public Decimal Latitude{get;set;}
        
        //Constructor Geolocation
        public GeoLocation (Decimal longitud, Decimal latitud) {
            Longitude = longitud;
            Latitude = latitud;
        }
        
    }
    
    
}