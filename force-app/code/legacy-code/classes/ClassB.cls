public class ClassB {

    public static void jediMethod(){

        ClassA jedi1 = new ClassA();
        ClassA jedi2 = new ClassA();

        /* jedi1.executeJedi();
        jedi2.executeJedi();

        System.debug(jedi1.jedisDefeated);   // This is 1
        System.debug(jedi2.jedisDefeated);  // This is 1

        // Access static variables only by class name, not object name
        System.debug(ClassA.totalJedisDefeated); // This is 2 */

        jedi1.examCalculation(2, 3);
        jedi2.examCalculation(4, 4);

        System.debug(jedi1.simpleResult);
        System.debug(jedi2.simpleResult);
        System.debug(ClassA.examResult);

    }

    public void doJob(){
        System.debug('Some stuff...');
    }

    public void getNumbersFromClassA(){

        ClassA a = new ClassA();
        a.getNumbers();

    }
    
    public static void method2(){
        System.debug('2');
    }
}