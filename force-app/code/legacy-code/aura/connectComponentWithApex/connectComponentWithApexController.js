({
    clickCreate: function(component, event, helper) {
        
        var action = component.get("c.upsertEmpresa");
        
        //Seteo el valor de la variable del método al valor de la variable que almacena la empresa
        action.setParams({
            "empresa": component.get("v.newEmpresa")
        });  
             
        $A.enqueueAction(action);      
        
    }
})