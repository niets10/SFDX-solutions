public class RetrieveArticles {
    
    
    static String sanitizeQueryString(String aQuery) {
        if (aQuery == null) return '%';
        
        String trimmedQuery = aQuery.trim();
        if (trimmedQuery.length() == 0) return '%';
        return '%' + trimmedQuery.replaceAll('\\W+', '%') + '%';
    }
    
    @AuraEnabled
    public static List<Article__c> getArticles(String nameFilterString) {
        String composedFilter = sanitizeQueryString(nameFilterString);
        System.debug('** Name ' + composedFilter);
        List<Article__c> lstArticles = [SELECT Id, Name, Type_of_Article__c FROM Article__c WHERE Name LIKE :composedFilter];
        System.debug('** List ' + lstArticles.size());
        return lstArticles;
    }
    
    @AuraEnabled
    public static List<ContentDocument> getFiles(Id recordId){
        
        List<ContentDocumentLink> CDLs = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =: recordId];
        System.debug('Files are 1 ' + CDLs);
        if (CDLs.size() < 1) return new List<ContentDocument>(); 
        
        // Make a List of ContentDocument IDs
        List <Id> CDIdList = new List <Id> ();
        for (ContentDocumentLink nextCDL : CDLs) {
            CDIdList.add(nextCDL.ContentDocumentId); }        
        
        List<ContentDocument> entries = [SELECT Id, Title, FileType FROM ContentDocument WHERE Id IN :CDIdList];
        System.debug('Files are 2 ' + entries);
        return entries;
    }
}