public class SuperHeroesCallout {

    public class Heroes {
        @AuraEnabled 
        public String name {get;}
        @AuraEnabled 
        public String alias {get;}
        @AuraEnabled 
        public String superpower {get;}
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Heroes> fetchHeroes() {

        System.debug('Callout in apex');

        List<Heroes> heroes = performCallout();
        return heroes;

    }

    private static List<Heroes> performCallout(){

        Http http = new Http();
        HttpRequest request = new HttpRequest();

        request.setEndpoint('https://salesforce-case-releye.herokuapp.com/rest-api/heroes/?format=json');
        request.setMethod('GET');

        HttpResponse response = http.send(request);

        if(response.getStatusCode() == 200){

            List<Heroes> results = (List<Heroes>) JSON.deserialize(response.getBody(), List<Heroes>.class);
            return results;

        }else {
            System.debug('Error ' + response.getStatusCode());
            
            return null;
        }


    }
}
