({
    init: function (cmp, event, helper) {
        var action = cmp.get("c.findAll");
        action.setCallback(this, function(response) {
            console.log('Respuesta ' + response);
            var state = response.getState();
            
            console.log('Status ' + state);
            if(state === 'SUCCESS') {
                
               	var obj = response.getReturnValue();                
                cmp.set('v.mapMarkersData',obj); 
                                
                cmp.set('v.center' , {	location: { Street: 'Paseo de las Delicias 87', City: 'Madrid',}});                      
                cmp.set('v.zoomLevel', 4);
                cmp.set('v.markersTitle', 'Salesforce locations');
                cmp.set('v.showFooter', true);
            }   
            else if(state === 'INCOMPLETE') {
                console.log('Incompleto');
            }
            
                else if(state === 'ERROR') {
                    console.log('Error');
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
            
            
        });              
        $A.enqueueAction(action); 
    }
})