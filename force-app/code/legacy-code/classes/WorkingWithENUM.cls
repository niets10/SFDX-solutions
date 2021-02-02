public class WorkingWithENUM {
    
    public enum Season {WINTER, FALL, SPRING, SUMMER}  
    
    public Double num = 2;
    
    public static void tryENUM(Season ses){
        
        if(ses == Season.WINTER){
            System.debug('IT IS WINTER');
        }else{
            System.debug('NOT WINTER');
        }
    }
    
}