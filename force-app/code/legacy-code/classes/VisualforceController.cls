public class VisualforceController {
    
    public String nombre;
    
    public void setnombre(String name){
        System.debug('name ' + name);
        this.nombre = name;        
    } 
    
    public String getnombre(){
        System.debug('Nombre ' + nombre);
        return nombre;
    }
    
}