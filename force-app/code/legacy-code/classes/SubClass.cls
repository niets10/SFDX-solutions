public class SubClass extends SuperClass{
    
    public override void showName(){
        
        super.showName();
        System.debug('But you can call me ' + super.getFirstName());
        
    }

}