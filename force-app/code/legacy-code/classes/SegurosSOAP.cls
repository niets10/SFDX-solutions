global class SegurosSOAP {
    
      
    webservice static Account createAnAccountWithSOAPUI(String name) {
        
        Account ac = new Account();
        ac.Name = name;
        
        insert ac;
        
        return ac;
        
    }

}