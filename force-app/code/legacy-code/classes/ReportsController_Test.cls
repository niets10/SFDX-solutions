/**
 @Name: ReportsController_Test.cls
 @OtherClasses: ReportsController.cls
 @Tests: ReportsController_Test.cls
 @Description:
  1. Test the functionality of reports controller
 @Usage:Reports
    SeeAllData needs to be done as it is not possible to do DML with Reports
 
 @History
  VERSION     AUTHOR           DATE            DETAIL
  1.0         Álvaro Nieto     29/09/2020      Initial version
*/

@isTest
public class ReportsController_Test {

    static final Set<Id> REPORTS_ID = ReportsController.REPORTS_ID;
    
    //Although SeeAllData is not a best practice in test, test classes to test Reports data must be annotated with SeeAllData = true
    @isTest(SeeAllData = true)
    static void test_getAllReports(){

        Integer totalReports = [SELECT Count() FROM Report WHERE Id IN: REPORTS_ID];

        Test.startTest();
        Integer totalReportsMethod = ReportsController.getReports().size();
        Test.stopTest();

        //Assert we get all the reports in the system from the aura method
        System.assertEquals(totalReports, totalReportsMethod);
    }

    @isTest(SeeAllData = true)
    static void test_getFilteredReports(){

        List<Report> totalReports = [SELECT Id, Name FROM Report WHERE Id IN: REPORTS_ID LIMIT 1];
        String reportName = totalReports[0].Name;

        //Call method
        Test.startTest();
        Report filteredReport = ReportsController.getFilteredReports(reportName)[0];  
        Test.stopTest();      

        //Assert the Name is the same as the one from the Report returned
        System.assertEquals(reportName, filteredReport.Name);      

        
    }

    @isTest(SeeAllData = true)
    static void test_getRecords(){                                  

        Test.startTest();
        ReportsController.Payload payload = (ReportsController.Payload) ReportsController.getRecords('Urval_konto');
        Test.stopTest();    
        
    }
}