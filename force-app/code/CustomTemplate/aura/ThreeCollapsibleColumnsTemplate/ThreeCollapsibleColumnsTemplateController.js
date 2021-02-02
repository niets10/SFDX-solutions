({
    toggleSectionLeft : function(component, event, helper) {
        component.set('v.leftColumn', !component.get('v.leftColumn'));
    },

    toggleSectionRight : function(component, event, helper) {
        component.set('v.rightColumn', !component.get('v.rightColumn'));
    },

})