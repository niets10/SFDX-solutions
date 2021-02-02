({
    execute : function(component, event, helper) {
        console.log('Pasa?');
        let action = component.get("c.getAccount");
        
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let returnValue = response.getReturnValue();
                console.log('Una frase ' + returnValue.unaFrase);
                console.log('Otra frase ' + returnValue.otraFrase);
                component.set("v.first", returnValue.unaFrase);
                component.set("v.second", returnValue.otraFrase);
            }
        });
        
        $A.enqueueAction(action);
        
    },
    
    doInit: function(cmp, ev, helper){
        let action = cmp.get("c.getProperties");
        
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let returnValue = response.getReturnValue();
                cmp.set("v.globalPropertiesList", returnValue);
                
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    helper.showErrorMessages(cmp,ev,helper,"Error while loading data", errors);
                } else {
                    console.log("Unknown error");
                }
            } else {
                console.log(state);
                console.log(response);
            }
            
        });
       
        $A.enqueueAction(action);
    },
})