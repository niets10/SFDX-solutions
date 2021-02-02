({
	enviarNumero : function(component, event, helper) {
		//Coger el número metido y almancenarlo en una variable
		//En JS es con document.getElementById("id deseado").value;
		var idInput = component.find("inputDedos");
        var numElegido = idInput.get("v.value");
                
        //Genero un número random
        var numRandom = helper.numeroRandom(0, 5);  
        
        //Validaciones para que el número esté en el rango
        if(numElegido > 5 || numElegido < 0 || !numElegido){
            alert("El número elegido debe estar entre 0 y 5");
        } else if(numElegido == numRandom){
            alert("¡ Enhorabuena, los números coinciden !")
        } else if (numElegido != numRandom) {
            alert("Lo siento, prueba de nuevo")
        }
        
        console.log('Los números son ' + numElegido + ' ' + numRandom);
        
	}
})