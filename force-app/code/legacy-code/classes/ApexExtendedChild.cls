public class ApexExtendedChild extends ApexExtended{
    
    
    //If I want to override the method...
    public override void write(){

        //Get the method from the parents
        super.write();
        System.debug('Overriding');
    }

    /* public void randomMethod(){
        write();
    } */

}