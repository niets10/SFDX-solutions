({
    getFilesObject : function(component, recordId) {
        
        const action = component.get("c.getFiles");
        action.setParams({
            recordId: recordId 
        });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();            
            
            if(state === 'SUCCESS'){ 
                
                var obj = response.getReturnValue(); 
                component.set("v.files", obj);
                
            }else {
                console.log("Failed with state: " + state);
            }  
            
        });   
        
        $A.enqueueAction(action);        
        
    }
})