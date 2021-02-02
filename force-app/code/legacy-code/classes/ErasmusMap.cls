public class ErasmusMap {
    
    @AuraEnabled
    public static List<Location> getErasmusLocations(){

        List<Erasmus__c> erasmus = [SELECT Name, City__c, Country__c FROM Erasmus__c];

        List<Location> locations = new List<Location>();

        for(Erasmus__c e : erasmus){
            Geolocation geoInfo = new GeoLocation();
            geoInfo.City = e.City__c;
            geoInfo.Country = e.Country__c;

            Location loc = new Location();
            loc.icon = 'action:map';
            loc.title = e.Name; 
            loc.description = e.City__c;
            loc.location = geoInfo;

            locations.add(loc);

        }

        return locations;

    }

    public class Location{
        @AuraEnabled
        public String icon {get; set; }

        @AuraEnabled
        public String description {get; set; }

        @AuraEnabled
        public String title {get; set; }

        @AuraEnabled
        public Geolocation location {get; set; }
            
    }

    public class Geolocation{

        @AuraEnabled
        public String Country {get; set;}
         
        @AuraEnabled
        public String City {get; set; }

    }
     
}