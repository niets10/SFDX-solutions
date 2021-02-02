({
    doInit : function(component, event, helper) {
        helper.filterRecords(component);        
    },
    
    handleNameFilterChange: function(component, event, helper) {
        helper.filterRecords(component);          
    },
    
    //Droppable section
    toggleSection : function(component, event, helper) {        
        var sectionAuraId = event.target.getAttribute("data-auraId");        
        var sectionDiv = component.find(sectionAuraId).getElement();        
        var sectionState = sectionDiv.getAttribute('class').search('slds-is-open');    
        if(sectionState == -1){
            sectionDiv.setAttribute('class' , 'slds-section slds-is-open');
        }else{
            sectionDiv.setAttribute('class' , 'slds-section slds-is-close');
        }
    },
    
    //Pass the recordId to detail page component via events
    clickRecord : function (component, event, helper) {
        var ctarget = event.currentTarget;
        var id_str = ctarget.dataset.value;
        var event = $A.get("e.c:articleId");
        event.setParams({ "passId": id_str});
        event.fire();
    }
})