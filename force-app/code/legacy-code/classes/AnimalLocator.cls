public class AnimalLocator {
    
    public static String getAnimalNameById(Integer num){
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals/'+num);
        request.setMethod('GET');
        
        HttpResponse response = http.send(request);
        
        String stringToReturn;
        
        if(response.getStatusCode() == 200){
            Map<String, Object> mapResults = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            Map<String, Object> properties = (Map<String, Object>) mapResults.get('animal');                        
            String name = (String) properties.get('name');            
            stringToReturn = name;
            
        }        
        return stringToReturn;
    }
}