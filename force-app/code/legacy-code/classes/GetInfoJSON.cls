public class GetInfoJSON {
    
    public class Properties{
        public String name;
        public String recordtype;
    }
    
	public static void getProperties(){
		        
        StaticResource sr = [SELECT Body FROM StaticResource WHERE Name =: 'PropertiesNaphthenics'];
        
        List<String> propNapth = new List<String>();
        
        List<Properties> properties = (List<Properties>)JSON.deserializeStrict(sr.Body.ToString(),List<Properties>.class);
        
        for(Properties p : properties){
            propNapth.add(p.name);
        }
        
        System.debug(propNapth);
        
    }
    
}