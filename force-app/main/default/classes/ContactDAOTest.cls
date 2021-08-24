@isTest
public with sharing class ContactDAOTest {
    private static String VRAIE_SEANCE_ID = Schema.SObjectType.Seance__c.getRecordTypeInfosByDeveloperName()
        .get('Vraie_seance')
        .getRecordTypeId();
    private static String SEANCE_PATRON_ID = Schema.SObjectType.Seance__c.getRecordTypeInfosByDeveloperName()
        .get('Seance_patron')
        .getRecordTypeId();
    @isTest
    static void getPaidArtistsTest() {
        //-------------------------------
        //I HAVE
        //-------------------------------
        Contact artiste = new Contact(
            LastName = 'truc',
            Prime__c = 1,
            Salaire_journalier_fixe__c = 15,
            RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
                .get('Artiste')
                .getRecordTypeId()
        );
        Contact client = new Contact(
            LastName = 'truc',
            RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
                .get('Client')
                .getRecordTypeId()
        );
        insert client;
        insert artiste;
        //-------------------------------
        //I DO
        //-------------------------------
        Test.startTest();
        List<Contact> contactList = ContactDAO.getPaidArtists();
        Test.stopTest();
        //-------------------------------
        //I TEST
        //-------------------------------
        System.assertEquals(1, contactList.size());
    }
    @isTest
    static void getRelatedBuyersTest() {
        //-------------------------------
        //I HAVE
        //-------------------------------
        Representation__c rpz = new Representation__c(Name = 'RPZ TEST');
        insert rpz;
        Salle__c salleTest = new Salle__c(
            Name = 'Salle Test',
            Nombre_de_places__c = 50
        );
        insert salleTest;
        Seance__c patron = new Seance__c(
            Name = 'Patron Test',
            RecordTypeId = SEANCE_PATRON_ID,
            Salle__c = salleTest.Id
        );
        insert patron;
        List<Zone__c> patronZoneList = new List<Zone__c>();
        patronZoneList.add(
            new Zone__c(
                Name = 'Premier Rang',
                Nombre_de_places__c = 20,
                Seance__c = patron.Id
            )
        );
        patronZoneList.add(
            new Zone__c(
                Name = 'Arriere',
                Nombre_de_places__c = 30,
                Seance__c = patron.Id
            )
        );
        insert patronZoneList;
        Seance__c seance1 = new Seance__c(
            Name = 'STEST1',
            Representation__c = rpz.Id,
            RecordTypeId = VRAIE_SEANCE_ID,
            Salle__c = salleTest.id,
            Patron_de_seance__c = patron.Id,
            Jour__c = System.today(),
            Heure__c = '10h'
        );

        insert seance1;
        Contact contact = new Contact(
            LastName = 'truc',
            RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
                .get('Client')
                .getRecordTypeId()
        );
        insert contact;
        Ticket__c ticket = [
            SELECT Id, Acheteur__c, Vendu__c, Seance__c
            FROM Ticket__c
            WHERE Seance__c = :seance1.Id
            LIMIT 1
        ];
        ticket.Acheteur__c = contact.Id;
        ticket.Vendu__c = true;
        update ticket;
        //-------------------------------
        //I DO
        //-------------------------------
        Test.startTest();
        List<Contact> res = ContactDAO.getRelatedBuyers(
            new List<Id>{ ticket.Id }
        );
        Test.stopTest();
        //-------------------------------
        //I TEST
        //-------------------------------
        System.assertEquals(res[0].Id, contact.Id);
    }
}
