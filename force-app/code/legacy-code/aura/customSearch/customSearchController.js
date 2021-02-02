({
    handleClick : function(component, event, helper) {
        var searchText = component.get('v.searchText');
        var action = component.get('c.getArticles');
        action.setParams({searchText: searchText});
        $A.enqueueAction(action);
    }
})