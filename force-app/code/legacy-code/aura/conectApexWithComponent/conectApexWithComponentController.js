({
    doInit : function(component, event, helper) {
        
        var action = component.get("c.queryMethod");
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if(state === 'SUCCESS'){
                
                var obj = response.getReturnValue();
                
                //Seteamos el valor que nos devuelve la query a la variable empresas, que se crea en HTML mediante <aura:attribute>
                component.set("v.empresas", obj);
                
            }else {
                console.log("Failed with state: " + state);
            }       
            
        });       
        $A.enqueueAction(action); 
        
    }
})