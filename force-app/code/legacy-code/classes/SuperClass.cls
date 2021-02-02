public virtual class SuperClass {
    
    public String mySalutation;
    public String myFirstName;
    public String myLastName;    
    
    public SuperClass(String a, String b, String c){        
        mySalutation = a;
        myFirstName = b;
        myLastName = c;        
        
    }
    
    public SuperClass(){
        mySalutation = 'Mr';
        myFirstName = 'Álvaro';
        myLastName = 'Nieto';
    }

    public virtual String getFirstName(){        
        return myFirstName;
    }
    
    public virtual void showName(){
        
        String name = mySalutation + ' ' + myFirstName + ' ' + myLastName;       	
        System.debug('My name is ' + name);
        
    }

}