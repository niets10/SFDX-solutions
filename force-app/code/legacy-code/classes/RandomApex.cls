public class RandomApex {
    
    // Property declaration
    public Integer prop {        
        get { return prop; }        
        //value is a standard way to get the value
        //RandomApex r = new RandomApex();
        //r.prop = 10;        
        set { 
            Integer y = value;            
            Integer x = 20;
            prop = x * y;           
        }        
    }
    
    static String myName = 'A name';
    
    public class Point {
        Double x;
        Double y;
        
        public Point(Double x, Double y) {
            this.x = x;
            this.y = y;
        }
        public Double getXCoordinate() {
            return x;
        }
        
        public Double getYCoordinate() {
            return y;
        }
    }  
    
    public static String nullPointer(){
        
        Map<Id, Account> mapIdAccount = new Map<Id, Account>([SELECT Id, Name, Type 
                                                              FROM Account WHERE Name = 'Álvaro' LIMIT 1]);
        
        Account a = mapIdAccount.get('0011n00002LqZM0AAN');    
        
        //WINTER 21 ---- API 50
        //String str = a?.Name;
        
        String name = a.Name;
        
        return name;
        
    }
    
    public static void calculator(String figura, Integer x, Integer y){
        
        Integer resultado = 0;
        
        if(figura == 'Triángulo'){
            
            resultado = (x * y)/2;
            
            
        }else if(figura == 'Cuadrado'){
            
            resultado = x * y;
            
        }
        
        System.debug('Resultado ' + resultado);
        
    }
    
    public static void triggerOnFormula(List<Seguros__c> newRecords, Map<Id, Seguros__c> oldRecordsMap){
        System.debug('Entering');
        for(Seguros__c newRecord: newRecords){
            Seguros__c oldValue = oldRecordsMap.get(newRecord.Id);
            
            if(newRecord.CounterDays__c != oldValue.CounterDays__c){
                System.debug('Formula');
            }
        }
        
        
    }
    
    public static void dynamicApex(){
        String name = 'A name';
        
        List<sObject> accts = Database.query('SELECT Id FROM Account WHERE Name =: myName');
        System.debug(accts);
    }
    
    public static void processList(List<sObject> input){
        
    }
    
    public static void hitQueryLimits(){
        
        List<Contact> myContacts = [SELECT Id FROM Contact];
        
        for(Contact c : myContacts){
            //Call an external system
        }
        
    }
    
    public void returnContinueMethods(){
        
        Set<Integer> ints = new Set<Integer>{1, 2, 3, 4};
            
            for(Integer i : ints){
                if(i == 1 || i == 4){
                    System.debug(i);
                    return;
                }else{
                    continue;
                }
                //this.returnMethod(i);
            }            
    }
    
    public void returnMethod(Integer i){
        if(i == 1 || i == 4){
            System.debug(i);
        }else{
            return;
        }
    }

    public static void callTriggerHandler(){
        TriggerHandler c = new TriggerHandler();
        c.run();
    }

    public static void insertWrongLead(){
        Log log = new Log();

        try{
            insert new Lead();
        }catch(Exception e){
            log.addLog(e);
        }

        log.publishEvent();
    }
    
    
}