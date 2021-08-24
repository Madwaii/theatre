public with sharing class ContactTriggerHandler {
    public static void afterInsert(List<Contact> tNew) {
        List<Contact> contactList = [SELECT Id, Crypted_Id__c FROM Contact WHERE Id IN :tNew];
        for (Contact contact : contactList) {
            Blob blobId = blob.valueOf(Id.valueOf(contact.Id));
            contact.Crypted_Id__c = EncodingUtil.base64Encode(blobId);
        }
        update contactList;
    }
}
