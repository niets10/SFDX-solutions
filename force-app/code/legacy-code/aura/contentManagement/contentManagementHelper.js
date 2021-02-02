({
    filterRecords : function(component) {
        //Get the values from the method
        const action = component.get("c.getArticles");
        var nameFilterString = component.find("nameFilter").get("v.value");
        var obj = [];
        var objAPEX = component.get("v.articlesApex");
        var objAdmin = component.get("v.articlesAdmin");
        var objOther = component.get("v.articlesOther");
        
        //Get the variable and delete the values
        objAPEX = [];
        objAdmin = [];
        objOther = [];
        
        action.setParams({
            nameFilterString: nameFilterString
        });       
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();            
            
            if(state === 'SUCCESS'){ 
                
                obj = response.getReturnValue(); 
                component.set("v.articlesTotal", obj); 
                
                if(typeof obj !== 'undefined'){
                    for(var i=0; i < obj.length; i++){
                        var records = obj[i];
                        var typeOfArticle = records.Type_of_Article__c; 
                        
                        if(typeOfArticle == 'APEX') {
                            
                            objAPEX.push(records);  
                            if(objAPEX !== 'undefined') {
                                component.set("v.articlesApex", objAPEX);
                            }
                            
                        }else if(typeOfArticle == 'Admin') {
                            
                            objAdmin.push(records);  
                            if(objAdmin !== 'undefined') {
                                component.set("v.articlesAdmin", objAdmin);
                            }  
                            
                        }else if(typeOfArticle == 'Other') {
                            
                            objOther.push(records);  
                            if(objOther !== 'undefined') {
                                component.set("v.articlesOther", objOther);
                            }    
                            
                        }                        
                                         
                        var apexSection = component.find("apexSection");
                        var adminSection = component.find("adminSection");
                        var otherSection = component.find("otherSection");
                        
                        if(objAPEX.length > 0) {
                            
                            this.toggleShow(apexSection);
                            
                        }else if(objAPEX.length == 0){                                
                            
                            this.toggleHide(apexSection);
                            
                        }                                                   
                        
                        if(objAdmin.length > 0) {
                            
                            this.toggleShow(adminSection);
                            
                        }else if(objAdmin.length == 0){                                
                            
                            this.toggleHide(adminSection);
                    
                        }
                        
                        if(objOther.length > 0) {
                            
                            this.toggleShow(otherSection);
                            
                        }else if(objOther.length == 0){                                
                            
                            this.toggleHide(otherSection);
                        }
                        
                    }
                    
                }else {
                    console.log("Failed with state: " + state);
                }  
                
            }
        });   
        
        $A.enqueueAction(action);
    },    
    
    toggleHide : function(section) {
        
        $A.util.removeClass(section, "slds-show");
        $A.util.addClass(section, "slds-hide");
        
    },
    
    toggleShow: function(section) {
        
        $A.util.removeClass(section, "slds-hide");
        $A.util.addClass(section, "slds-show");
    }
    
})