@isTest
public with sharing class ZoneServiceTest {
    private static String VRAIE_SEANCE_ID = Schema.SObjectType.Seance__c.getRecordTypeInfosByDeveloperName()
        .get('Vraie_seance')
        .getRecordTypeId();
    private static String SEANCE_PATRON_ID = Schema.SObjectType.Seance__c.getRecordTypeInfosByDeveloperName()
        .get('Seance_patron')
        .getRecordTypeId();

    @isTest
    public static void duplicatePatronZonesTestSuccess() {
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
        Seance__c patron1 = new Seance__c(
            Name = 'Patron Test 1',
            RecordTypeId = SEANCE_PATRON_ID,
            Salle__c = salleTest.Id
        );
        insert patron1;
        List<Zone__c> patronZoneList = new List<Zone__c>();
        patronZoneList.add(
            new Zone__c(
                Name = 'Premier Rang',
                Nombre_de_places__c = 20,
                Seance__c = patron1.Id
            )
        );
        patronZoneList.add(
            new Zone__c(
                Name = 'Arriere',
                Nombre_de_places__c = 30,
                Seance__c = patron1.Id
            )
        );
        insert patronZoneList;
        Seance__c patron2 = new Seance__c(
            Name = 'Patron Test 2',
            RecordTypeId = SEANCE_PATRON_ID,
            Salle__c = salleTest.Id
        );
        insert patron2;
        //-------------------------------
        //I DO
        //------------------------------- 
        Test.startTest();
            List<Zone__c> newZoneList =
            ZoneService.duplicatePatronZones(new List<Id>{patron1.Id}, new List<Seance__c>{patron2});
        Test.stopTest();
        //-------------------------------
        //I TEST
        //------------------------------- 
        System.assertEquals(2, newZoneList.size());
        System.assertEquals(2, [select Id from Zone__c where Seance__c=:patron2.Id].size());
    }
    @isTest
    public static void duplicatePatronZonesTestFailure() {
        //-------------------------------
        //I HAVE
        //-------------------------------

        //-------------------------------
        //I DO
        //------------------------------- 
        Test.startTest();
            List<Zone__c> newZoneList =
            ZoneService.duplicatePatronZones(new List<Id>{}, new List<Seance__c>{});
        Test.stopTest();
        //-------------------------------
        //I TEST
        //------------------------------- 
        System.assertEquals(null, newZoneList);
    }
}
