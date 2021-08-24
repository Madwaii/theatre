@isTest
public with sharing class RepresentationDAOTest {
    private static String VRAIE_SEANCE_ID = Schema.SObjectType.Seance__c.getRecordTypeInfosByDeveloperName()
    .get('Vraie_seance')
    .getRecordTypeId();
private static String SEANCE_PATRON_ID = Schema.SObjectType.Seance__c.getRecordTypeInfosByDeveloperName()
    .get('Seance_patron')
    .getRecordTypeId();
    @isTest
    public static void getUpcomingRepresentationsTest() {
        //-------------------------------
        //I HAVE
        //-------------------------------
        Representation__c rpz = new Representation__c(Name = 'RPZ TEST');
        Representation__c rpz2 = new Representation__c(Name = 'RPZ TEST 2');
        insert rpz;
        insert rpz2;
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
            Jour__c = System.today().addDays(+1),
            Heure__c = '10h'
        );
        Seance__c seance2 = new Seance__c(
            Name = 'STEST2',
            Representation__c = rpz2.Id,
            RecordTypeId = VRAIE_SEANCE_ID,
            Salle__c = salleTest.id,
            Patron_de_seance__c = patron.Id,
            Jour__c = System.today().addDays(-1),
            Heure__c = '10h'
        );

        insert seance1;
        insert seance2;
        //-------------------------------
        //I DO
        //-------------------------------
        Test.startTest();
        List<Representation__c> res = RepresentationDAO.getUpcomingRepresentations();
        Test.stopTest();
        //-------------------------------
        //I TEST
        //-------------------------------
        System.assertEquals(1, res.size());
        System.assertEquals(res[0].Name , 'RPZ TEST');
    }
}
