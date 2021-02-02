({
    isConsoleNavigation: function (component, event) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI
            .isConsoleNavigation()
            .then(function (response) {
                component.set("v.isConsoleApplication", response);
                console.log(response);
            })
            .catch(function (error) {
                console.log(error);
            });
    },
});