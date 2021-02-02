public class ClaseMaria {
    
    public static void trgObjeto(Id objetoId){
        
        //Buscamos el objeto donde queremos que actúe el trigger
        Objeto__c objetoBuscado = [SELECT Id, Propietario__c, Contact__c FROM Objeto__c WHERE Id =: objetoId];
        
        //Buscamos la lista de Contactos que correspondan con el nombre del objeto
        List<Contact> lstContacto = [SELECT Id, Contact.LastName FROM Contact WHERE Contact.LastName =: objetoBuscado.Propietario__c];
        
        //Si no está vacía, es decir, existe el contacto, nos recorremos los contactos para asignar el Id al campo Contacto del objeto 
        if(!lstContacto.isEmpty()){
            for(Contact lc : lstContacto){                
                objetoBuscado.Contact__c = lc.Id;
                
            }            
            
        }
        //Actualizamos el objeto
        update objetoBuscado;
        
    }
//Esta parte de aquí es para que no haga un bucle infinito    
    public static boolean flag=true;
    public static boolean runonce(){
        if(flag){
            flag=false;
        }
        else {
            return flag;
        }
        return true;
    }
  
}