({
    myAction : function(component, event, helper) {
        
        document.getElementById("parrafo1").innerHTML = "Funciona";
    },
    
    myAction2 : function() {
        
        var colores = ["Azul", "Rojo", "Verde", "Amarillo"];
        var prev = "";
        
        for (var i = 0; i < colores.length; i++) {
            
            prev += "<p>" + colores[i] + "</p>";
            
            console.log(colores[i]);
        }
        
        document.getElementById("parrafo2").innerHTML = prev;
    }
})