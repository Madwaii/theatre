@isTest
public with sharing class ContactTriggerTest {
    @isTest
    public static void afterInsertTest() {
        //-------------------------------
        //I HAVE
        //-------------------------------
        Contact client = new Contact(
            LastName = 'truc',
            RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
                .get('Client')
                .getRecordTypeId()
        );
        //-------------------------------
        //I DO
        //-------------------------------
        insert client;
        //-------------------------------
        //I TEST
        //-------------------------------
        Blob blobId = blob.valueOf(Id.valueOf(client.Id));
        String Crypted_Id = EncodingUtil.base64Encode(blobId);
        System.assertEquals(Crypted_Id, [select Crypted_Id__c from Contact][0].Crypted_Id__c);
    }
}
