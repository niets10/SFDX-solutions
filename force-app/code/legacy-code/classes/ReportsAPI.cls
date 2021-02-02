public class ReportsAPI {
    
    public static void getReportsInfo(){
        // Get the report ID
        List <Report> reportList = [SELECT Id,DeveloperName FROM Report where 
                                    DeveloperName = 'Numero_de_seguros_Xok'];
        String reportId = (String)reportList.get(0).get('Id');
        
        // Run a report synchronously
        Reports.reportResults results = Reports.ReportManager.runReport(reportId, true);
        
        // Get the ROW grouping in the report
        Reports.Dimension dim = results.getGroupingsDown();
        Reports.GroupingValue groupingVal = dim.getGroupings()[0];
        System.debug('Key: ' + groupingVal.getKey());
        System.debug('Label: ' + groupingVal.getLabel());
        System.debug('Value: ' + groupingVal.getValue());
        
        //Get the COLUMN grouping in the report
        Reports.ReportExtendedMetadata allMetadata = results.getReportExtendedMetadata();
        System.debug('Key col: ' + allMetadata);
        
        Map<String, Reports.AggregateColumn> detailColumn = allMetadata.getAggregateColumnInfo();
        System.debug('Detail column ' + detailColumn);
        
        // Construct a fact map key, using the grouping key value
        String factMapKey = groupingVal.getKey() + '!T';
        
        // Get the fact map from the report results
        Map<String,Reports.ReportFact> factMap = results.getFactMap();
        
        System.debug('Whole fact map ' + factMap );
        
        Reports.ReportFactWithDetails factDetails =
            (Reports.ReportFactWithDetails)results.getFactMap().get(factMapKey);
        
        Reports.ReportFactWithDetails x =
            (Reports.ReportFactWithDetails)results.getFactMap().get('0_1!T');
        
        System.debug('ReportFact x: ' + x);
        System.debug('ReportFact: ' + factDetails);
        
        // Get the first summary amount from the fact map
        Reports.SummaryValue sumVal = factDetails.getAggregates()[0];
        System.debug('Summary Value: ' + sumVal.getLabel());
        
        // Get the field value from the first data cell of the first row of the report
        Reports.ReportDetailRow detailRow = x.getRows()[0];
        System.debug('DetailRow Label: ' + detailRow.getDataCells()[0].getLabel());
        System.debug('DetailRow Value: ' + detailRow.getDataCells()[0].getValue());
        
    }
    
    public static void getSpecificInformation(){
        // Get the report ID
        List <Report> reportList = [SELECT Id,DeveloperName FROM Report where 
                                    DeveloperName = 'Numero_de_seguros_Xok'];
        String reportId = (String)reportList.get(0).get('Id');
        
        // Run a report synchronously
        Reports.reportResults results = Reports.ReportManager.runReport(reportId, true);        
           
        // Get the fact map from the report results
        Map<String,Reports.ReportFact> factMap = results.getFactMap();  
        
        //Get total result ----> the total row has the key T!T
        
        /*Two ways using different classes, they both work:
			
		ReportFact is the parent class of ReportFactWithDetails and ReportFactWithSummaries. 
		If includeDetails is true when the report is run, the fact map is a ReportFactWithDetails object. 
		If includeDetails is false when the report is run, the fact map is a ReportFactWithSummaries object.

		*/
        Map<String, Reports.ReportFact> x = results.getFactMap();  
            
        Reports.ReportFact reportFact = results.getFactMap().get('T!T');        
        Reports.ReportFactWithDetails totalRowDetails = (Reports.ReportFactWithDetails) results.getFactMap().get('T!T');
        
        Decimal totalCount = (Decimal) totalRowDetails.getAggregates()[0].getValue();
        System.debug('ReportFact: ' + totalCount);
        
        //Get any specific cell in the report
        Reports.ReportFactWithDetails factDetails = (Reports.ReportFactWithDetails) results.getFactMap().get('0_1!T');
        Reports.ReportDetailRow detailRow = factDetails.getRows()[1];
        System.debug('DetailRow Label: ' + detailRow.getDataCells()[1].getLabel());  
    }

    public static void getRecordIds(String reportName){

        List<Report> reportList = [SELECT Id, DeveloperName FROM Report WHERE DeveloperName = 'Numero_de_seguros_Xok'];
        List<ReportsSolution__mdt> customMetadata = [SELECT ColumnTarget__c, ObjectAPIName__c, ReportDeveloperName__c 
                                                        FROM ReportsSolution__mdt
                                                        WHERE ReportDeveloperName__c = 'Numero_de_seguros_Xok'];

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
        String query = 'SELECT Id FROM ' + objectApiName + ' WHERE Id IN: relevantIds';
        List<sObject> listOfContacts = Database.query(query);

        // Call the Flow
        Map<String, Object> params = new Map<String, Object>();
        params.put('Records', listOfContacts);
        Flow.Interview.ReportFlow helloWorldFlow = new Flow.Interview.ReportFlow(params);
        helloWorldFlow.start();
    }
    
        
}