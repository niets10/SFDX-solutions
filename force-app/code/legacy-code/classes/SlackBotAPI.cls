@RestResource(urlMapping='/slackapi/v1/*')
global class SlackBotAPI {
    
    global class SlackRequest{        
        public String type {get;set;}
        public String token {get;set;}
        public String challenge {get;set;}        
    }
    
    global class SlackResponse{
        
        public SlackResponse(){
            errors = new List<String>();
        }
        
        public Integer code {get;set;}
        public List<String> errors {get; set;}
        public String challenge {get;set;}
        
        public void addError(String errorMessage){
            errors.add(errorMessage);
        }        
    }
    
    @HttpPost
    global static SlackResponse handleSlackResponse(){
        SlackResponse response = new SlackResponse();
        RestRequest req =  RestContext.request;
        RestContext.response.statusCode = 200;
        
        try{
            
            SlackRequest request = (SlackRequest) JSON.deserialize(req.requestBody.toString(), SlackRequest.class);  
            System.debug(request.challenge);
            response.code = 200;
            response.challenge = request.challenge;
            
            
        }catch(Exception e){
            response.code = 200;
            System.debug(e.getMessage());
            response.addError(e.getMessage()+' '+e.getStackTraceString());
        }
        
        return response;
    }
    
}