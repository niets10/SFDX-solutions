public class AlvaroClass {
    
    //Static and non static    
    public static void calculateNumbers(){        
        
        //HERE GOES THE LOGIC
        //First we need a number, second we need a second number, after we add them, finally we show the result
        
        //First number integer
        Integer myFirstNumber = 7;
        System.debug('My first numbers is: ' + myFirstNumber);
        //Second number integer
        Integer mySecondNumber = 32;        
        System.debug('My second numbers is: ' + mySecondNumber);
        //Addition of first + second
        Integer result = myFirstNumber + mySecondNumber;
        
        //Print the result
        System.debug('My result is ejjejejeeuw >----> ' + result);
        
    }
    
    public static void calculateNumbers(Decimal num1, Decimal num2){
        
        //Get first number, add it the second number and store it in a variable called result
        Decimal result = num1 + num2;
        
        //Print the result
        System.debug('The result is....: ' + result);
        
        
    }
    
    //Write a method which returns an Integer, and will accept three variables, num1 + num2 - num3
    public static Integer doSomeCalculations(Integer num1, Integer num2, Integer num3){
        
        //LOGIC GOES HERE
        Integer returnResult = num1 + num2 - num3;
        //System.debug(returnResult);
        
        return returnResult;
    }
    
    //Conditionals
    public static void showFavoriteFeature(String name){
        
        //We get the name and if it's Álvaro, we are going to show his feature (LC), David (PB), Johan (apex)
        if(name == 'Álvaro'){            
            //LOGIC
            System.debug('LC');
        }else if(name == 'David'){
            
            System.debug('PB');
        }else if(name == 'Johan'){
            
            System.debug('apex');
        }else{            
            System.debug('No name provided or wrong name');
        }               
    }    
    
    //Create a method which will compare the region and will assign an owner to the opty
    public static void assignOwnership(List<Opportunity> optys){
        
        //First we need to get each opportunity
        for(Opportunity opty:optys ){
            
            //If the region is Stockholm, then owner is going to be Álvaro
            // if region == stockholm, owner = Álvaro   
         	        
        }       
        
    }   
    
}