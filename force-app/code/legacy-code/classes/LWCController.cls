public with sharing class LWCController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactList(String searchKey) {
        String key = '%' + searchKey + '%';
        return [SELECT Id, Name, Title, Phone, Email FROM Contact LIMIT 10];
    }
}