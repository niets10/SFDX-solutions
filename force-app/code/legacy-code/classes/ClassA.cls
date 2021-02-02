public class ClassA {

    public Integer jedisDefeated = 0;
    public static Integer totalJedisDefeated = 0;

    public static Integer examResult = 0;
    public Integer simpleResult = 0;

    private final ClassB worker;
    public static Integer complexCalculation = 0;

    public Integer numberX;
    public static Integer numbery;
    
    public ClassA(ClassB worker){

        this.worker = worker;

    } 

    public ClassA(){

        numberX = 10;
        numberY = 20;

    }

     static {

        Integer x = 3;
        Integer y = 5;

        complexCalculation = x * y;

    }

    public void executeJedi() {
        // Wooosh vvvzzztt! AAHHHHH!
        jedisDefeated      = jedisDefeated + 1;
        totalJedisDefeated = totalJedisDefeated + 1;
    }

    public void examCalculation(Integer firstNote,Integer secondNote){

        Integer a = firstNote;
        Integer b = secondNote;

        examResult      += a * b;
        simpleResult    += a * b;
    }


    public void anotherMethod(){

        worker.doJob();

        System.debug('Calculation ' + complexCalculation);
    }

    public void getNumbers(){
        System.debug('Numbers are  ' + numberX + ' ' + numberY);
    }
    
    public static void method1(){
        System.debug('1');
    }

}