@isTest
public with sharing class TicketTriggerTest {
    private static String VRAIE_SEANCE_ID = Schema.SObjectType.Seance__c.getRecordTypeInfosByDeveloperName()
        .get('Vraie_seance')
        .getRecordTypeId();
    private static String SEANCE_PATRON_ID = Schema.SObjectType.Seance__c.getRecordTypeInfosByDeveloperName()
        .get('Seance_patron')
        .getRecordTypeId();
    @isTest
    public static void afterUpdateTest() {
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
                Jour__c = System.today().addDays(-100),
                Heure__c = '10h'
            );
    
            insert seance1;
            Contact contact = new Contact(
                LastName = 'truc',
                Email = 'bonjour@truc.com',
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
            //-------------------------------
            //I DO
            //-------------------------------
            Test.startTest();
            update ticket;
            Test.stopTest();
            //-------------------------------
            //I TEST
            //-------------------------------

            //NOTHING TO TEST IF METHOD DIDNT CRASH
    }
}
