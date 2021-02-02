({
    getValueEvent : function(component, event, helper) {
        var recordId = event.getParam("passId");
        component.set("v.recordId", recordId);
        
        //Get the associated files
        helper.getFilesObject(component, recordId);
        
    },
    
    openFile : function (component, event, helper) {
        
        var idClicked = event.getSource().get("v.value");
        
        console.log('Id clicked ' + idClicked);
        
        $A.get('e.lightning:openFiles').fire({
		    recordIds: idClicked,
		    selectedRecordId: idClicked
		});
    }
    
})