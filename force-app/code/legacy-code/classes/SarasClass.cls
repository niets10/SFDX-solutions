public class SarasClass {
    
    public static String triangle = 'Triangle';
	public static String square = 'Square';
	public static String circle = 'Circle';
	public static final Decimal PI = 3.14159;
    
    public static void calculateSurface(String type, Decimal base, Decimal height, Decimal radio){
        
        Decimal result;
        
        if(type == triangle) {
            result = (base * height)/2;
        }else if(type == square) {
            result = base * height;
        }else if(type == circle){
            result = radio*radio*PI;
        }
        
        System.debug(result);
        
    }

}