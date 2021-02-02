public class trabajarConMapas {
    
    public static void mapCuentas() {
        
        List<Account> lstAcct = [SELECT Id, Name FROM Account LIMIT 3];
        
        System.debug('*** Las cuentas son ' + lstAcct);
        
        Map<Id, String> mapAcct = new Map<Id, String>();
        
        for(Account lt : lstAcct) {
            
            mapAcct.put(lt.Id, lt.Name);
            
        }
        
        System.debug('*** Mapa poblado ' + mapAcct);

        
    }
    

}