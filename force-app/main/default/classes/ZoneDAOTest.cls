@isTest
public with sharing class ZoneDAOTest {
    private static String VRAIE_SEANCE_ID = Schema.SObjectType.Seance__c.getRecordTypeInfosByDeveloperName()
        .get('Vraie_seance')
        .getRecordTypeId();
    private static String SEANCE_PATRON_ID = Schema.SObjectType.Seance__c.getRecordTypeInfosByDeveloperName()
        .get('Seance_patron')
        .getRecordTypeId();
    @isTest
    public static void testDAO() {
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
        //-------------------------------
        //I DO
        //-------------------------------
        Test.startTest();
        List<Zone__c> res = ZoneDAO.getSeanceZoneList(
            new List<Id>{ patron.Id }
        );
        Test.stopTest();
        //-------------------------------
        //I TEST
        //-------------------------------
        System.assertEquals(res.size(), 2);
    }
}
