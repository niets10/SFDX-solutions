public class GetterSetterController {
    
    public class Trial{
        @AuraEnabled public String unaFrase;
        @AuraEnabled public String otraFrase {get;set;}
    }
    
    @AuraEnabled
    public static Trial getAccount(){
        Trial t = new Trial();
        
        t.unaFrase = 'Aquí todo va bien';
        t.otraFrase = 'Funciona como la seda';
        
        return t;
    }
    
    public class Properties{
        public String family;
        public String property;
        public String firstmarket;
        public String secondMarket;
        public String thirdMarket;
    }
    
    @AuraEnabled
    public static List<String> getProperties(){
        
        
        
        List<String> propBitumen = new List<String>();
        String productFamily = 'Hard Grade Industrial Bitumen';
        String market = 'Nordics';
        Set<String> countries = new Set<String>();
        
        StaticResource sr = [SELECT Body FROM StaticResource WHERE Name =: 'PropertiesBitumen'];
        List<Properties> properties = (List<Properties>)JSON.deserializeStrict(sr.Body.ToString(),List<Properties>.class);
         
        Map<String, List<Properties>> mapFamilyProperties = new Map<String, List<Properties>>();
        for(Properties p : properties){
            if(!mapFamilyProperties.containsKey(p.family)){
                mapFamilyProperties.put(p.family, new List<Properties> {p});
            }else{
                mapFamilyProperties.get(p.family).add(p);
            }
        }
        
        Map<Properties, List<String>> mapPropertyNameCountries = new Map<Properties, List<String>>();
        
        //USE Properties of the specific family
        List<Properties> familyProperties = mapFamilyProperties.get(ProductFamily);
        
        for(Properties p : familyProperties){
            if(!mapPropertyNameCountries.containsKey(p)){
                mapPropertyNameCountries.put(p, new List<String> {p.firstmarket, p.secondmarket, p.thirdmarket});
            }else{
                mapPropertyNameCountries.get(p).add(p.firstmarket);
                mapPropertyNameCountries.get(p).add(p.secondmarket);
                mapPropertyNameCountries.get(p).add(p.thirdmarket);
            }
        }
        
        for(Properties p : familyProperties){			            
            if(mapPropertyNameCountries.get(p).contains(market)){
                propBitumen.add(p.property);
            }            
        }
        
        System.debug('Properties ' + propBitumen.size());
        
        System.debug(mapPropertyNameCountries);
        
        
        
        
        return propBitumen;
        
        
        
        
        
        
        
        
        /*Map<String, Map<String, List<String>>> outerMap = new Map<String, Map<String, List<String>>>();

String family = 'Plebani';
String country = 'France';

for(Properties p : properties){
if(outerMap.containsKey(p.family)){
Map<String, List<String>> innerMap = outerMap.get(p.family);                
if(innerMap.containskey(p.country)){
innerMap.get(p.country).add(p.name);
}else{
innerMap.put(p.country, new List<String>{p.name});
}
}else{
outerMap.put(p.family, new Map<String, List<String>>{ p.country => new List<String>{p.name}});
}            
}

propNapth = outerMap.get(family).get(country);

System.debug(propNapth);

return propNapth;*/
        
    }
    
    
}