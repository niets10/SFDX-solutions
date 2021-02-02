global class AnimalLocatorMock implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest request){
        
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"animal":{"id":2,"name":"perro","eats":"pienso, campers, adam seligman","says":"yum yum"}}');
        response.setStatusCode(200);
        
        return response;
        
    }
    
}