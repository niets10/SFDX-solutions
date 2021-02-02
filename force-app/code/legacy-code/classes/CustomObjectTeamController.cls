public class CustomObjectTeamController {
   
    public class Payload {

        @AuraEnabled public List<sObject> sharedRecords {get; set;}
        @AuraEnabled public String objectLabel {get; set;}

    }

    private class ObjectName {
        private String objectName { get; set;}
        private String objectLabel { get; set; }
        private String objectShareName { get; set; }
    }

    //Insert Sharing
    @AuraEnabled
    public static void insertSharing(Id parentId, Id userId, String accessLevel){
   
        System.debug('UserId ' + userId);
        System.debug('RecordId ' + parentId);
        System.debug('AccessLevel ' + accessLevel);

        String seg = 'Seguros__Share'; 
        String obj = 'Seguros__c';
        Id parId = parentId;
        Id usId = userId;
        
        String strAccessLevel;

        //Perfect to test errors on insert
        if(accessLevel == 'read'){
            strAccessLevel = 'Read';
        }else if(accessLevel == 'readWrite'){
            strAccessLevel = 'Edit';
        }

        Schema.SObjectType stdShareType = Schema.getGlobalDescribe().get(seg);
        SObject stdShare = stdShareType.newSObject();
        stdShare.put('ParentId', parId); //Set the ID of record being shared
        stdShare.put('UserOrGroupId', usId); //Set the ID of User or Group or Territory being granted access
        stdShare.put('AccessLevel', strAccessLevel); //Set the Account access level
        stdShare.put('RowCause', 'SegurosTeam__c'); //Set the Row Cause reason
        Database.SaveResult sr = Database.Insert(stdShare,false);
        
        // Process the save results.
        if(sr.isSuccess()){
            // Indicates success
            System.debug('Success');
            
        }
        else {
            System.debug('False');
            // Get first save result error.
            Database.Error err = sr.getErrors()[0];
            System.debug(err);
            // Check if the error is related to trival access level.
            // Access level must be more permissive than the object's default.
            // These sharing records are not required and thus an insert exception is acceptable. 
            if(err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION  &&  
               err.getMessage().contains('AccessLevel')){
                   // Indicates success.
                   
               }
        }

    }

    //Delete Sharing Records
    @AuraEnabled
    public static void deleteSharedRecord(Id recordId){        

        try {
            delete [SELECT Id FROM Seguros__Share WHERE Id =: recordId];
        } catch (Exception e) {
            System.debug('Error handling ' + e.getMessage());
            throw new CustomException(e.getMessage());
        }
        
    }

    //Get Shared Records on init
    @AuraEnabled(cacheable = true)
    public static Payload getSharedRecords(Id recordId, String rowCauseName){
        
        ObjectName o = getsObjectShareName(recordId);
        String objectShareName = o.objectShareName;
        String objectLabel = o.objectLabel;

        
        String query = 'SELECT Id, AccessLevel, RowCause, UserOrGroupId, UserOrGroup.Name, Parent.Name FROM ';
        query += objectShareName;
        query += ' WHERE ParentId =: recordId';
        query += ' AND RowCause =: rowCauseName';
        List<sObject> sharedRecords = Database.query(query);

        Payload p = new Payload();
        System.debug('Records ' + sharedRecords);
        p.sharedRecords = sharedRecords;
        p.objectLabel = objectLabel;

        return p;

    }
    
    private static ObjectName getsObjectShareName(Id recordId){
        String sObjectName = recordId.getSObjectType().getDescribe().getName();
        String sObjectLabel = recordId.getSObjectType().getDescribe().getLabel();
        String objectShareName = '';

        ObjectName o = new ObjectName();
        o.objectName = sObjectName;
        o.objectLabel = sObjectLabel;
        

        //Check if it's a custom object
        if(sObjectName.contains('__c')){
            objectShareName = sObjectName.removeEnd('__c') + '__Share';
            o.objectShareName = objectShareName;
            return o;
        }else{
            o.objectShareName = sObjectName;
            return o;
        }
    }

    public class CustomException extends Exception {
 
    }


}