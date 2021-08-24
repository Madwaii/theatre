@isTest
public with sharing class SeanceTriggerTest {
    private static String VRAIE_SEANCE_ID = Schema.SObjectType.Seance__c.getRecordTypeInfosByDeveloperName()
        .get('Vraie_seance')
        .getRecordTypeId();
    private static String SEANCE_PATRON_ID = Schema.SObjectType.Seance__c.getRecordTypeInfosByDeveloperName()
        .get('Seance_patron')
        .getRecordTypeId();
        
    @isTest
    public static void CreateSeanceTestSuccess() {
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
        system.debug('coucou' + patron);
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
        List<Seance__c> toInsert = new List<Seance__c>();
        Seance__c seance1 = new Seance__c(
            Name = 'STEST1',
            Representation__c = rpz.Id,
            RecordTypeId = VRAIE_SEANCE_ID,
            Salle__c = salleTest.id,
            Patron_de_seance__c = patron.Id
        );
        Seance__c seance2 = new Seance__c(
            Name = 'STEST2',
            Representation__c = rpz.Id,
            RecordTypeId = VRAIE_SEANCE_ID,
            Salle__c = salleTest.id,
            Patron_de_seance__c = patron.Id
        );
        toInsert.add(seance1);
        toInsert.add(seance2);
        //-------------------------------
        //I DO
        //------------------------------- 
        Test.startTest();
        insert toInsert;
        Test.stopTest();
        //-------------------------------
        //I TEST
        //------------------------------- 
        System.assertEquals(100, [SELECT Id FROM Ticket__c].size());
        System.assertEquals(
            50,
            [SELECT Id FROM Ticket__c WHERE Seance__c = :seance1.Id].size()
        );
    }

    @isTest
    public static void CreateSeanceTestFailure() {
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
        List<Seance__c> toInsert = new List<Seance__c>();
        Seance__c seance1 = new Seance__c(
            Name = 'STEST1',
            Representation__c = rpz.Id,
            RecordTypeId = VRAIE_SEANCE_ID,
            Salle__c = salleTest.id,
            Patron_de_seance__c = patron.Id,
            Jour__c = System.today(),
            Heure__c = '10h'
        );
        Seance__c seance2 = new Seance__c(
            Name = 'STEST2',
            Representation__c = rpz.Id,
            RecordTypeId = VRAIE_SEANCE_ID,
            Salle__c = salleTest.id,
            Patron_de_seance__c = patron.Id,
            Jour__c = System.today(),
            Heure__c = '10h'
        );
        
        toInsert.add(seance1);
        toInsert.add(seance2);
        Boolean expectedExceptionThrown1 =false;
        Boolean expectedExceptionThrown2 =false;
        //-------------------------------
        //I DO
        //------------------------------- 
        Test.startTest();
        //testing insertion in list
        try {
            insert toInsert;
        } catch (Exception e) {
            expectedExceptionThrown1 = e.getMessage()
                    .contains(System.Label.Conflit_Date_Dans_Liste)
                ? true
                : false;
        }
        //testing insertion separately
        insert seance1;
        try {
            insert seance2;
        } catch (Exception e) {
            expectedExceptionThrown2 = e.getMessage()
                    .contains(
                        System.Label.Conflit_Seance
                    )
                ? true
                : false;
        }
        Test.stopTest();
        //-------------------------------
        //I TEST
        //------------------------------- 
        System.assertEquals(expectedExceptionThrown1, true);
        System.assertEquals(expectedExceptionThrown2, true);
        System.assertEquals(50, [SELECT Id FROM Ticket__c].size());
        System.assertEquals(
            50,
            [SELECT Id FROM Ticket__c WHERE Seance__c = :seance1.Id].size()
        );
    }

    @isTest
    public static void UpdateSeanceTestSuccess() {
        //-------------------------------
        //I HAVE
        //------------------------------- 
        Representation__c rpz = new Representation__c(Name = 'RPZ TEST');
        insert rpz;
        Salle__c salleTest1 = new Salle__c(
            Name = 'Salle Test',
            Nombre_de_places__c = 50
        );
        insert salleTest1;
        Salle__c salleTest2 = new Salle__c(
            Name = 'Salle Test',
            Nombre_de_places__c = 100
        );
        insert salleTest2;
        Seance__c patron1 = new Seance__c(
            Name = 'Patron Test',
            RecordTypeId = SEANCE_PATRON_ID,
            Salle__c = salleTest1.Id
        );
        insert patron1;
        Seance__c patron2 = new Seance__c(
            Name = 'Patron Test',
            RecordTypeId = SEANCE_PATRON_ID,
            Salle__c = salleTest2.Id
        );
        insert patron2;
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
        patronZoneList.add(
            new Zone__c(
                Name = 'Premier Rang',
                Nombre_de_places__c = 30,
                Seance__c = patron2.Id
            )
        );
        patronZoneList.add(
            new Zone__c(
                Name = 'Arriere',
                Nombre_de_places__c = 70,
                Seance__c = patron2.Id
            )
        );
        insert patronZoneList;
        List<Seance__c> toInsert = new List<Seance__c>();
        Seance__c seance1 = new Seance__c(
            Name = 'STEST1',
            Representation__c = rpz.Id,
            RecordTypeId = VRAIE_SEANCE_ID,
            Salle__c = salleTest1.id,
            Patron_de_seance__c = patron1.Id
        );
        Seance__c seance2 = new Seance__c(
            Name = 'STEST2',
            Representation__c = rpz.Id,
            RecordTypeId = VRAIE_SEANCE_ID,
            Salle__c = salleTest1.id,
            Patron_de_seance__c = patron1.Id
        );
        toInsert.add(seance1);
        toInsert.add(seance2);
        insert toInsert;
        //-------------------------------
        //I DO
        //------------------------------- 
        Test.startTest();
        seance1.Salle__c = salleTest2.Id;
        seance1.Patron_de_seance__c = patron2.Id;
        update seance1;
        Test.stopTest();
        //-------------------------------
        //I TEST
        //------------------------------- 
        System.assertEquals(150, [SELECT Id FROM Ticket__c].size());
    }
    @isTest
    public static void UpdateSeanceTestSuccessFailure() {
        //-------------------------------
        //I HAVE
        //------------------------------- 
        Representation__c rpz = new Representation__c(Name = 'RPZ TEST');
        insert rpz;
        Salle__c salleTest1 = new Salle__c(
            Name = 'Salle Test',
            Nombre_de_places__c = 50
        );
        insert salleTest1;
        Salle__c salleTest2 = new Salle__c(
            Name = 'Salle Test',
            Nombre_de_places__c = 100
        );
        insert salleTest2;
        Seance__c patron1 = new Seance__c(
            Name = 'Patron Test',
            RecordTypeId = SEANCE_PATRON_ID,
            Salle__c = salleTest1.Id
        );
        insert patron1;
        Seance__c patron2 = new Seance__c(
            Name = 'Patron Test',
            RecordTypeId = SEANCE_PATRON_ID,
            Salle__c = salleTest2.Id
        );
        insert patron2;
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
        patronZoneList.add(
            new Zone__c(
                Name = 'Premier Rang',
                Nombre_de_places__c = 30,
                Seance__c = patron2.Id
            )
        );
        patronZoneList.add(
            new Zone__c(
                Name = 'Arriere',
                Nombre_de_places__c = 70,
                Seance__c = patron2.Id
            )
        );
        insert patronZoneList;
        List<Seance__c> toInsert = new List<Seance__c>();
        Seance__c seance1 = new Seance__c(
            Name = 'STEST1',
            Representation__c = rpz.Id,
            RecordTypeId = VRAIE_SEANCE_ID,
            Salle__c = salleTest1.id,
            Patron_de_seance__c = patron1.Id
        );
        Seance__c seance2 = new Seance__c(
            Name = 'STEST2',
            Representation__c = rpz.Id,
            RecordTypeId = VRAIE_SEANCE_ID,
            Salle__c = salleTest1.id,
            Patron_de_seance__c = patron1.Id
        );
        toInsert.add(seance1);
        toInsert.add(seance2);
        insert toInsert;
        //create buyer
        Contact contact = new Contact(LastName='truc', RecordTypeId = 
        Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
          .get('Client').getRecordTypeId());
        insert contact;
        //buy a ticket of s1
        Ticket__c ticket = [
            SELECT Id, Acheteur__c, Vendu__c, Seance__c
            FROM Ticket__c
            WHERE Seance__c = :seance1.Id
            LIMIT 1
        ];
        ticket.Acheteur__c = contact.Id;
        ticket.Vendu__c=true;
        update ticket;
        //-------------------------------
        //I DO
        //------------------------------- 
        Test.startTest();
        seance1.Salle__c = salleTest2.Id;
        seance1.Patron_de_seance__c = patron2.Id;
        try {
            update seance1;
        } catch (Exception e) {
        }
        Test.stopTest();
        //-------------------------------
        //I TEST
        //------------------------------- 
        System.assertEquals(100, [SELECT Id FROM Ticket__c].size());
    }
}