({
    doInit: function (component, event, helper) {
        helper.isConsoleNavigation(component, event);
        //helper.isSubtab(component, event, helper);
    },

    toggleSectionLeft: function (component, event, helper) {
        component.set("v.openLeftColumn", !component.get("v.openLeftColumn"));
    },

    toggleSectionRight: function (component, event, helper) {
        component.set("v.openRightColumn", !component.get("v.openRightColumn"));
    },
});
