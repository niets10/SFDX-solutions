public class Babi {
    
    public static Boolean isBabi(String Name){
        
        Boolean babi = false;
        
        if(Name == 'Sara'){
            babi = true;
        }else{
            babi = false;
        }
        
        return babi;
        
    }
    
    public static void result(String Name){
        
        Boolean babi = isBabi(Name);
        
        if(babi){
            System.debug(Name + ' is Babi');
        }else{
            System.debug(Name + ' is not Babi');
        }
        
    }

}