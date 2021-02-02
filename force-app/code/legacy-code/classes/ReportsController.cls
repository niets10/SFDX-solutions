/**
 @Name: ReportsController.cls
 @TestedBy: ReportsController_Test.cls
 @Other classes used: GetObjectFields.cls
 @Description: Description:
    APEX custom controller to be called from ReportsFlowCmp.

 @History
  VERSION     AUTHOR           DATE            DETAIL
  1.0         Álvaro Nieto     10/9/2020       First version
  1.1         Álvaro Nieto     12/09/2020      Add method to get all the fields of the object dynamically
  1.2         Álvaro Nieto     28/09/2020      Return map with flow name and developername
  1.3         Álvaro Nieto     29/09/2020      Refactoring the code to show only relevant reports
*/

public class ReportsController {

    /**
     * @Description: Varible declaration
      */
    
    static final Map<String, Report> RELEVANT_REPORTS = new Map<String, Report>();
    static final Map<String, List<ReportsSolution__mdt>> RELEVANT_CUSTOMMETADATA = new Map<String, List<ReportsSolution__mdt>>();

    @TestVisible
    static final Set<Id> REPORTS_ID = new Set<Id>();
    
    static {                

        Map<String, Report> reportsWithFlowsConnected = new Map<String, Report>();
        List<Report> reports = [SELECT Id, Name, DeveloperName FROM Report];

        for(Report r : reports){
            reportsWithFlowsConnected.put(r.DeveloperName, r);            
        }

        List<ReportsSolution__mdt> customMetadata = [SELECT ColumnTarget__c, ObjectAPIName__c, 
                                                    ReportDeveloperName__c, FlowDeveloperName__c, FlowName__c 
                                                    FROM ReportsSolution__mdt];
       
        for(ReportsSolution__mdt cm : customMetadata){

            //Populate CustomMetadata Map
            if(RELEVANT_CUSTOMMETADATA.containsKey(cm.ReportDeveloperName__c)){
                RELEVANT_CUSTOMMETADATA.get(cm.ReportDeveloperName__c).add(cm);  
            }else{
                RELEVANT_CUSTOMMETADATA.put(cm.ReportDeveloperName__c, new List<ReportsSolution__mdt>{ cm });
            }

            //Populate Report Map
            if(reportsWithFlowsConnected.containsKey(cm.ReportDeveloperName__c)){
                Report r = reportsWithFlowsConnected.get(cm.ReportDeveloperName__c);
                RELEVANT_REPORTS.put(r.DeveloperName, r);
                REPORTS_ID.add(r.Id);
            }
        }    

    }
    
    
    /**
     * @Description: Return an object with properties
      */
    public class Payload {

        @AuraEnabled public Map<String, String> flowNames {get; set;}
        @AuraEnabled public List<sObject> records {get; set;}
        @AuraEnabled public Report report {get;set;}

    }

    /**
     * @Description: Avoid SOQL injection
      */
    private static String sanitizeQueryString(String aQuery) {
        if (aQuery == null) return '%';
        
        String trimmedQuery = aQuery.trim();
        if (trimmedQuery.length() == 0) return '%';
        return '%' + trimmedQuery.replaceAll('\\W+', '%') + '%';
    }
    
    /**
     * @Description: Method to enable the report search
     * Returns a List of Reports, since we use a LIKE comparisor instead of an =: comparisor
      */
    @AuraEnabled
    public static List<Report> getFilteredReports(String nameFilterString){
        
        String composedFilter = sanitizeQueryString(nameFilterString);
        
        //Can't use a map to get a report by the part of the key as I do in a query with the LIKE comparison operator, it needs to be the full key, 
        //so I will do a new selective query using the Ids from the relevant reports we queried before
        List<Report> filteredReports = [SELECT Id, Name, DeveloperName FROM Report WHERE Name LIKE :composedFilter AND Id IN: REPORTS_ID ORDER BY Name];
        
        return filteredReports;

    }

    /**
     * @Description: Get only report which has been configured as a custom metadata type
      */
    @AuraEnabled
    public static List<Report> getReports(){
               
        return RELEVANT_REPORTS.values();
        
    }
    
    /**
     * @Description: Fetch collection of records from the selected Report
      */
    @AuraEnabled
    public static Payload getRecords(String reportName){

        //Since the reports to be shown are only the ones associated to custom metadata, there's no need to check if the Report/CustomMetadata are null, since they will never be
        Report report = RELEVANT_REPORTS.get(reportName);
        List<ReportsSolution__mdt> customMetadata = RELEVANT_CUSTOMMETADATA.get(reportName);
        
        Payload pld = new Payload();             

        Map<String, String> flowNames = new Map<String, String>();        
        for(ReportsSolution__mdt cm : customMetadata){
            flowNames.put(cm.FlowName__c, cm.FlowDeveloperName__c);
        }                                            
                     
        System.debug('MyMap ' + flowNames);

        //Run report
        String reportId = (String) report.get('Id');        
        Reports.reportResults results = Reports.ReportManager.runReport(reportId, true);

        //Get results
        Map<String,Reports.ReportFact> factMap = results.getFactMap();        

        /* A report could have different groupping by rows, if we have two, 
        * the first groupping won't have any detailed row so we will filter out keys without detailed rows
        */
        List<String> relevantKeys = new List<String>();
        for(String key : factMap.keySet()){

            Reports.ReportFactWithDetails fd = (Reports.ReportFactWithDetails) results.getFactMap().get(key);
            List<Reports.ReportDetailRow> detailsRows = fd.getRows();
            if(!detailsRows.isEmpty()) relevantKeys.add(key);

        }

        //Iterate through the keys with detailed rows
        Set<Id> relevantIds = new Set<Id>();
        Set<String> names = new Set<String>();
        ReportsSolution__mdt cmd = customMetadata[0];
        for(String key : relevantKeys){

            Integer loopCount = 0;
            Reports.ReportFactWithDetails fd = (Reports.ReportFactWithDetails) results.getFactMap().get(key);
            List<Reports.ReportDetailRow> rows = fd.getRows();

            //Get the detail rows for each grouping            
            for(Reports.ReportDetailRow r : rows){
                //Iterate through each of the rows, getting the value
                Integer columnTarget = (Integer) cmd.ColumnTarget__c;
                relevantIds.add( (Id) fd.getRows()[loopCount].getDataCells()[columnTarget].getValue() );
                loopCount++;
            }
           
        }

        //Get ObjectAPIName from metadata and its fields using Schema.getGlobalDescribe();
        String objectApiName = cmd.ObjectAPIName__c;
        List<String> fieldApiNames = GetObjectFields.getFieldsForObject(objectApiName);
        String stringFields = String.join(fieldApiNames, ',');

        String query = 'SELECT ' + stringFields + ' FROM ' + objectApiName + ' WHERE Id IN: relevantIds';

        List<sObject> listOfSobjects = Database.query(query);

        System.debug('List of objects ' + listOfSobjects);

        pld.flowNames = flowNames;
        pld.records = listOfSobjects;
        pld.report = report;

        return pld;
    }
}