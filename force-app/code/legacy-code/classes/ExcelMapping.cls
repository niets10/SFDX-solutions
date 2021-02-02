public class ExcelMapping {
    
    public class ExcelObject{        
        String english;
        String swedish;
    }
    
    //First Map with values in english
    static Map<String, String> englishMap = new Map<String, String>();
    
    //Second Map with values in swedish
    static Map<String, String> swedishMap = new Map<String, String>();
    
    //Third Map with full translation
    static Map<String, ExcelObject> fullMap = new Map<String, ExcelObject>();    
    
    static{
        englishMap.put('{0001}', 'Cat');
        englishMap.put('{0002}', 'Car');
        englishMap.put('{0003}', 'Football');
        englishMap.put('{0004}', 'Thanks');
        
        swedishMap.put('{0001}', 'Kat');
        swedishMap.put('{0002}', 'Bil');
        swedishMap.put('{0003}', 'Fotball');
        swedishMap.put('{0004}', 'Tack');
        
        /*fullMap.put('{0001}', new ExcelObject());
        fullMap.put('{0002}', new ExcelObject());
        fullMap.put('{0003}', new ExcelObject());
        fullMap.put('{0004}', new ExcelObject());*/
    }
    
    public static void generateTranslation(){
        
        for(String key : englishMap.keySet()){
            
            if(swedishMap.containsKey(key)){
                String englishValue = englishMap.get(key);
                String swedishValue = swedishMap.get(key);
                
                ExcelObject o = new ExcelObject();                
                o.swedish = swedishValue;
                o.english = englishValue;
                
                fullMap.put(key, o);
            }            
        }
        
        System.debug('My Full Map ' + fullMap);
    }
    
}