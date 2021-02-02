@isTest
public class AnimalLocatorTest {
    
    @isTest
    static void testGetCallout(){
        Test.setMock(HttpCalloutMock.class, new AnimalLocatorMock());
        
        String actualValue = AnimalLocator.getAnimalNameById(2);
        String expectedValue = 'perro';
        System.assertEquals(expectedValue, actualValue);
        
    }

}