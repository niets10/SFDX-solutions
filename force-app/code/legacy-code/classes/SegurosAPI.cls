@RestResource(urlMapping='/Seguros/*')
global class SegurosAPI {
    
    @HttpGet
    global static Seguros__c[] getSeguros(){        
        Seguros__c[] s = [SELECT Id, Name, Empresa__r.Name, Clientes__r.Name FROM Seguros__c LIMIT 10];        
        return s;        
    }
    
    // POST Method passsing parameters to the method
    
    /*
global class Response_out{

global String id;
global List<String> errors;
global boolean success;
global String message;

global Response_out(String segurosId, String error, Boolean result, String message){
this.id = segurosId;
this.errors = new List<String>();
errors.add(error);
this.success = result;
this.message = message;
}

}    


@HttpPost
global static response_out createSeguro(String name, String empresaId, String clienteId, String tipoDeSeguro){

Seguros__c s = new Seguros__c();

s.Name = name;
s.Empresa__c = empresaId;
s.Clientes__c = clienteId;
s.Tipo_de_seguro__c = tipoDeSeguro;

Response_out res;

try{
insert s;
res = new Response_out(s.Id, '', true, 'Worked!');

}catch(Exception e){            
res = new Response_out(null, e.getMessage(), false, 'Failed :(');            
}

return res;     

}*/
    
    //POST Method deserializing the JSON (Martin's approach)
    
    global class SegurosInterface{
        
        //String name, String empresaId, String clienteId, String tipoDeSeguro
        public String name {get;set;}
        public String empresaId {get;set;}
        public String clienteId {get;set;}
        public String tipoDeSeguro {get;set;}
        
    }
    
    global class Response{
        
        public Response(){
            errors = new List<String>();
        }
        
        public Boolean success {get;set;}
        public Id resultId {get;set;}
        public List<String> errors {get;set;}
        
        public void addErrors(String errorMessage){
            errors.add(errorMessage);
        }
    }
    
    
    @HttpPost
    global static Response createSegurosV2(){
        
        Response res = new Response();
        RestRequest request = RestContext.request;
        RestContext.response.statusCode = 200;
        
        try{
            
            SegurosInterface incomingInfo = (SegurosInterface) JSON.deserialize(request.requestBody.toString(), SegurosInterface.class);
            
            Seguros__c s = new Seguros__c();
            s.Name = incomingInfo.name;
            s.Empresa__c = incomingInfo.empresaId;
            s.Clientes__c = incomingInfo.clienteId;
            s.Tipo_de_seguro__c = incomingInfo.tipoDeSeguro;
            
            insert s;
            
            res.success = true;
            res.resultId = s.Id;
            
        }catch(Exception e){
            
            res.resultId = null;
            res.success = false;
            res.addErrors(e.getMessage());
            
        }
        
        return res;
    }
    
}