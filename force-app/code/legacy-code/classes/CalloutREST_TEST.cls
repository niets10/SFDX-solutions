@isTest
private class CalloutREST_TEST {
    
    @isTest
    static void testGetCallout(){
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('GetAnimalResource');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        Test.setMock(HttpCalloutMock.class, mock);
        
        HttpResponse result = CalloutREST.getResponse();
        
        System.assertNotEquals(null,result,'The callout returned a null response.');
        System.assertEquals(200, result.getStatusCode());
        System.assertEquals('application/json;charset=UTF-8', result.getHeader('Content-Type'),'The content type value is not expected.'); 
        
        Map<String, Object> mapResults = (Map<String, Object>) JSON.deserializeUntyped(result.getBody());        
        List<Object> results = (List<Object>) mapResults.get('animals');
        System.assertEquals(3, results.size(), 'The array should only contain 3 items.'); 
        
    }
    
    @isTest static void testPostCallout(){
        Test.setMock(HttpCalloutMock.class, new CalloutREST_MockTEST());
        
        HttpResponse result = CalloutREST.postResponse();
        String contentType = result.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = result.getBody();
        System.debug(result.getBody());
        String expectedValue = '{"animals": ["majestic badger", "fluffy bunny", "scary bear", "chicken", "mighty moose"]}';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(201, result.getStatusCode());
    }
}