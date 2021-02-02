public class CalloutREST {
    
    //Example of public API using POSTMAN
    public static HttpResponse getResponseFromPostman(){
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://simplekart.postman.com/items/1657');
        request.setMethod('GET');
        
        HttpResponse response = http.send(request);
        
        if(response.getStatusCode() == 200){
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());           
            System.debug('Results ' + results);
            System.debug('Description ' + results.get('description'));
            System.debug('Price ' + results.get('price'));
            System.debug('ItemId ' + results.get('itemId'));
            
        }else{            
            System.debug('Response code ' + response.getStatusCode());           
        }
        return response;        
    }
    
    @future (callout=true)
    public static void postResponse(Set<Id> recordIds){
        
        Seguros__c s = [SELECT Id, Name, Tipo_de_seguro__c FROM Seguros__c WHERE Id IN: recordIds][0];        
        
        JSONGenerator gen = JSON.createGenerator(true);    
        gen.writeStartObject();      
        gen.writeStringField('SeguroId', s.Id);
        gen.writeStringField('SeguroName',s.Name);
        gen.writeStringField('SeguroTipo',s.Tipo_de_seguro__c);
        gen.writeEndObject();    
        String jsonS = gen.getAsString();
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://endn5j92r2qd.x.pipedream.net');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(jsonS);
        http.send(request);
        
        
        HttpResponse response = http.send(request);   
        
        if (response.getStatusCode() != 201) {
            System.debug('The status code returned was not expected: ' + response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug(response.getBody());
        }   
        
        //return response;
    }
}