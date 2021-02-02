public class DeleteFilesController {
    
    @AuraEnabled
    public static void deleteFile(Id fileId){

        System.debug('id ' + fileId);

        ContentDocument cd = [SELECT Id FROM ContentDocument WHERE Id =: fileId];

        delete cd;
        
    }
}