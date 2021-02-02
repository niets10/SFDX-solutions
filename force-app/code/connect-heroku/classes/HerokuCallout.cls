public class HerokuCallout {
    
    class Heroes {
        String name {get;}
        String alias {get;}
    }

    public static void getHerokuHeroes(){

        Http http = new Http();
        HttpRequest request = new HttpRequest();

        //request.setEndpoint('https://py-rest-api-sf.herokuapp.com/rest-api/heroes/?format=json');
        request.setEndpoint('https://salesforce-case-releye.herokuapp.com/rest-api/heroes/?format=json');
        request.setMethod('GET');

        HttpResponse response = http.send(request);

        if(response.getStatusCode() == 200){

            System.debug('Response ' + response.getBody());

            List<Heroes> results = (List<Heroes>) JSON.deserialize(response.getBody(), List<Heroes>.class);
            System.debug(results);

        }else {
            System.debug('Error ' + response.getStatusCode());
        }

    }

}