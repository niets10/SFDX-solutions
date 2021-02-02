({
    navigateToFilesHome : function(component){
        
        console.log('Success');

        var pageReference = {
            type: "standard__objectPage",
            attributes: {
                objectApiName: "ContentDocument",
                actionName: "home",
            },
        };

        var navService = component.find("nav");
        navService.navigate(pageReference);
    }
})