public class asignarErasmus {    
    
    public decimal SalesTax = 0.0875;
    
    //ss s
    // VAmos
    
    public static List<Tutor__c> obtenerTutores() {
        
        List<Tutor__c> lstTutores = [SELECT Id, Campus__c, Facultad__c, Name, Identificador__c FROM Tutor__c];
        for(Tutor__c lst : lstTutores){
            System.debug('*** Lista tutores' + lst.Identificador__c);
        }
        return lstTutores;
        
    }
    
    public static void identificarTutores(List<Tutor__c> lstTutores) {
        
        lstTutores = obtenerTutores();
        System.debug('*** Lista tutores' + lstTutores);
        
        Map<Decimal, Tutor__c> mapTutores = new Map<Decimal, Tutor__c>();
        
        for(Tutor__c lst : lstTutores){
            
            mapTutores.put(lst.Identificador__c, lst);
            //System.debug('*** Lista tutores' + lst);
            System.debug('*** Mapa tutores' + mapTutores);
        }
        
        
        System.debug('*** Mapa tutores' + mapTutores);
        System.debug('*** Mapa tutores' + mapTutores.values());
        System.debug('*** Mapa tutores' + mapTutores.get(2));
    }
    
    
    
}