public with sharing class ContactUtilities{

    //Method to return the list of contatcs based on selected account
    @AuraEnabled(Cacheable = true)
    public static List<Contact> getContacts(Id sourceAccount){
        return [SELECT Id, Name, Account.Name, LastName, FirstName, Email, Phone, MobilePhone
                From Contact where AccountId = :sourceAccount];
    }

    //Method to delete the selected contacts
    @AuraEnabled
    public static void deleteContacts(list<Id> deleteContactIds){
        list<Contact> listContactToDelete = new list<Contact>();
        for (Id idContact : deleteContactIds){
            listContactToDelete.add(new Contact(Id = idContact));
        }
        if (!listContactToDelete.isEmpty()){
            delete listContactToDelete;
        }
    }

    //Method to create contact
    @AuraEnabled
    public static void addContact(string firstName, string lastName, String email,id acntId){
        Contact con = new Contact();
        con.FirstName = firstName;
        con.LastName = lastName;
        con.Email = email;
        con.AccountId = acntId;
        try{
            insert con;
        } catch (Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }
    }
}