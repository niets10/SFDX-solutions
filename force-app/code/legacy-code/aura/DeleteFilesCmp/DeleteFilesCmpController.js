({
    deleteAction : function(component, event, helper) {

        console.log('Delete file action called...');

        var recordId = component.get("v.recordId");
        var action = component.get("c.deleteFile");
        action.setParams({ fileId: recordId });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                
                //helper.navigateToFilesHome(component);
                window.history.back();

                console.log('History ' + document.referrer);

                
            } else {
                console.log("Failed with state: " + state);
            }
        });

        $A.enqueueAction(action);

    },

})