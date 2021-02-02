@isTest
public class testClaseMaria {

    @testSetup static void setup(){
        
        //Insertamos un Objeto
        Objeto__c obj = new Objeto__c();
        obj.Name = 'Test 01';
        obj.Propietario__c = 'Carlos';
        insert obj;
        
        //Insertamos un Contact
        Contact cct = new Contact();
		cct.LastName = 'Carlos';
        insert cct;
                       
    }
    //Probamos el método cuando el nombre del propietario es igual al contacto
    //Debe comprobarse que el campo Contact__c del Objeto__c es igual al Contact Carlos
    @isTest static void propIgualaContacto(){
        Objeto__c obj = [SELECT Id, Propietario__c FROM Objeto__c];
        Contact cct = [SELECT Id, Contact.LastName FROM Contact];
        
        test.startTest();
        ClaseMaria.trgObjeto(obj.Id);
        test.stopTest();
        
        Objeto__c objActualizado = [SELECT Id, Propietario__c, Contact__c FROM Objeto__c];
        
        System.assertEquals(cct.Id, objActualizado.Contact__c);
        
    }
    
    //Probamos el método cuando el nombre del propietario no es igual al contacto
    //Debe comprobarse que el campo Contact__c del Objeto__c es nulo ya que no se ha producido actualización
    
    @isTest static void propNoIgualaContacto(){
        Objeto__c obj = [SELECT Id, Propietario__c, Contact__c FROM Objeto__c];
        Contact cct = [SELECT Id, Contact.LastName FROM Contact];
        
        obj.Propietario__c = 'Juan';
        update obj;
        
        test.startTest();
        ClaseMaria.trgObjeto(obj.Id);
        test.stopTest();
        
        System.assert(obj.Contact__c == null);
        
    }    
    
}