public class ReportsControllerLWC {
    
    public class Payload {

        @AuraEnabled public List<String> flowNames {get; set;}
        @AuraEnabled public List<sObject> records {get; set;}
        @AuraEnabled public Report report {get;set;}

    }

    @AuraEnabled
    public static Payload getRecords(String reportName){

        List<Report> reportList = [SELECT Id, Name, DeveloperName FROM Report WHERE DeveloperName =: reportName];

        List<ReportsSolution__mdt> customMetadata = [SELECT ColumnTarget__c, ObjectAPIName__c, 
                                                    ReportDeveloperName__c, FlowDeveloperName__c 
                                                    FROM ReportsSolution__mdt
                                                    WHERE ReportDeveloperName__c =: reportName];

        //If no metadata configured, we stop the process
        if(customMetadata.isEmpty()) return null;                                           

        List<String> flowNames = new List<String>();        
        for(ReportsSolution__mdt cm : customMetadata){
            flowNames.add(cm.FlowDeveloperName__c);
        }                                            
                                                    

        String reportId = (String) reportList.get(0).get('Id');

        //Run report
        Reports.reportResults results = Reports.ReportManager.runReport(reportId, true);

        //Get results
        Map<String,Reports.ReportFact> factMap = results.getFactMap();        

        //Filter out keys without detailed rows
        List<String> relevantKeys = new List<String>();
        for(String key : factMap.keySet()){

            Reports.ReportFactWithDetails fd = (Reports.ReportFactWithDetails) results.getFactMap().get(key);
            List<Reports.ReportDetailRow> detailsRows = fd.getRows();
            if(!detailsRows.isEmpty()) relevantKeys.add(key);

        }

        //Iterate through the keys with detailed rows
        Set<Id> relevantIds = new Set<Id>();
        Set<String> names = new Set<String>();
        for(String key : relevantKeys){

            Integer loopCount = 0;
            Reports.ReportFactWithDetails fd = (Reports.ReportFactWithDetails) results.getFactMap().get(key);
            List<Reports.ReportDetailRow> rows = fd.getRows();

            //Get the detail rows for each grouping
            for(Reports.ReportDetailRow r : rows){
                //TO DO: Change the number 1 by custom metadata

                //Iterate through each of the rows, getting the value
                Integer columnTarget = (Integer) customMetadata[0].ColumnTarget__c;
                relevantIds.add( (Id) fd.getRows()[loopCount].getDataCells()[columnTarget].getValue() );
                loopCount++;
            }
           
        }

        String objectApiName = customMetadata[0].ObjectAPIName__c;
        String query = 'SELECT Id, Name FROM ' + objectApiName + ' WHERE Id IN: relevantIds';

        List<sObject> listOfSobjects = Database.query(query);

        System.debug('List of objects ' + listOfSobjects);

        Payload pld = new Payload();
        pld.flowNames = flowNames;
        pld.records = listOfSobjects;
        pld.report = reportList[0];

        return pld;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Report> getReports(){
        
        List<Report> reports = [SELECT Id, DeveloperName, Name FROM Report ORDER BY Name];

        System.debug('Reports ' +  reports);
        
        return reports;

    }

    @AuraEnabled
    public static List<Report> getFilteredReports(String nameFilterString){
        
        String composedFilter = sanitizeQueryString(nameFilterString);

        System.debug('Search term ' + composedFilter);
        
        List<Report> filteredReports = [SELECT Id, Name, DeveloperName FROM Report WHERE Name LIKE :composedFilter ORDER BY Name];
        
        System.debug('Size ' + filteredReports.size());

        return filteredReports;

    }
    
    private static String sanitizeQueryString(String aQuery) {
        if (aQuery == null) return '%';
        
        String trimmedQuery = aQuery.trim();
        if (trimmedQuery.length() == 0) return '%';
        return '%' + trimmedQuery.replaceAll('\\W+', '%') + '%';
    }
}