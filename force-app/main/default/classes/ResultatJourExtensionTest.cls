@isTest
public with sharing class ResultatJourExtensionTest {
    private static String VRAIE_SEANCE_ID = Schema.SObjectType.Seance__c.getRecordTypeInfosByDeveloperName()
        .get('Vraie_seance')
        .getRecordTypeId();
    private static String SEANCE_PATRON_ID = Schema.SObjectType.Seance__c.getRecordTypeInfosByDeveloperName()
        .get('Seance_patron')
        .getRecordTypeId();
    private static ApexPages.StandardSetController stdSetChargeRec;
    @TestSetup
    static void makeData() {
        Contact artiste = new Contact(
            LastName = 'truc',
            Prime__c = 1,
            Salaire_journalier_fixe__c = 15,
            RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
                .get('Artiste')
                .getRecordTypeId()
        );
        insert artiste;
        Representation__c rpz = new Representation__c(Name = 'RPZ TEST', Artiste__c=artiste.Id);
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
            Heure__c = '10h',
            Cout__c=150
        );

        insert seance1;
        Contact client = new Contact(
            LastName = 'truc',
            RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
                .get('Client')
                .getRecordTypeId()
        );
        insert client;
        Ticket__c ticket = [
            SELECT Id, Acheteur__c, Vendu__c, Seance__c
            FROM Ticket__c
            WHERE Seance__c = :seance1.Id
            LIMIT 1
        ];
        ticket.Acheteur__c = client.Id;
        ticket.Vendu__c = true;
        update ticket;
        List<Charge_unique__c> chargeUniList = new List<Charge_unique__c>();
        chargeUniList.add( new Charge_unique__c(
            Gain_ou_depense__c = 'Gain',
            Montant__c = 100,
            Name = 'Test Gain Unique',
            Date__c=System.today()
        ));
        chargeUniList.add(new Charge_unique__c(
            Gain_ou_depense__c = 'Dépense',
            Montant__c = 100,
            Name = 'Test Dépense Unique',
            Date__c=System.today()
        ));
        insert chargeUniList;
        List<Charge_recurrente__c> chargeRecList = new List<Charge_recurrente__c>();
        chargeRecList.add(new Charge_recurrente__c(
            Gain_ou_depense__c= 'Gain',
            Cout_journalier__c=10,
            Name = 'Test Gain Récurrent'
        ));
        chargeRecList.add(new Charge_recurrente__c(
            Gain_ou_depense__c= 'Dépense',
            Cout_journalier__c=10,
            Name = 'Test Dépense Récurrente'
        ));
        insert chargeRecList;
        stdSetChargeRec = new ApexPages.StandardSetController(chargeRecList);
    }
    @isTest
    static void getTicketRevenueTest(){
        //-------------------------------
        //I HAVE
        //-------------------------------
        
        ResultatJourExtension rje = new ResultatJourExtension(stdSetChargeRec);
        //-------------------------------
        //I DO
        //-------------------------------
        Test.startTest();
        Decimal result = rje.getTicketRevenue();
        Test.stopTest();
        //-------------------------------
        //I TEST
        //-------------------------------
        System.assertEquals(10, result);
    }
    @isTest
    static void getGainRevenueTest(){
        //-------------------------------
        //I HAVE
        //-------------------------------
        
        ResultatJourExtension rje = new ResultatJourExtension(stdSetChargeRec);
        //-------------------------------
        //I DO
        //-------------------------------
        Test.startTest();
        Decimal result = rje.getGainRevenue();
        Test.stopTest();
        //-------------------------------
        //I TEST
        //-------------------------------
        System.assertEquals(100, result);
    }
    @isTest
    static void getArtistCostTest(){
        //-------------------------------
        //I HAVE
        //-------------------------------
        
        ResultatJourExtension rje = new ResultatJourExtension(stdSetChargeRec);
        //-------------------------------
        //I DO
        //-------------------------------
        Test.startTest();
        Decimal result = rje.getArtistCost();
        Test.stopTest();
        //-------------------------------
        //I TEST
        //-------------------------------
        System.assertEquals(15.1, result);
    }
    @isTest
    static void getChargeRecDepenseListTest(){
        //-------------------------------
        //I HAVE
        //-------------------------------
        
        ResultatJourExtension rje = new ResultatJourExtension(stdSetChargeRec);
        //-------------------------------
        //I DO
        //-------------------------------
        Test.startTest();
        List<Charge_recurrente__c> result = rje.getChargeRecDepenseList();
        Test.stopTest();
        //-------------------------------
        //I TEST
        //-------------------------------
        System.assertEquals(10, result[0].Cout_journalier__c);
    }
    @isTest
    static void getChargeRecGainListTest(){
        //-------------------------------
        //I HAVE
        //-------------------------------
        
        ResultatJourExtension rje = new ResultatJourExtension(stdSetChargeRec);
        //-------------------------------
        //I DO
        //-------------------------------
        Test.startTest();
        List<Charge_recurrente__c> result = rje.getChargeRecGainList();
        Test.stopTest();
        //-------------------------------
        //I TEST
        //-------------------------------
        System.assertEquals(10, result[0].Cout_journalier__c);
    }
    @isTest
    static void getTodayTest(){
        //-------------------------------
        //I HAVE
        //-------------------------------
        
        ResultatJourExtension rje = new ResultatJourExtension(stdSetChargeRec);
        //-------------------------------
        //I DO
        //-------------------------------
        Test.startTest();
        Date result = rje.getToday();
        Test.stopTest();
        //-------------------------------
        //I TEST
        //-------------------------------
        System.assertEquals(System.today(), result);
    }
    @isTest
    static void getSeanceCostTest(){
        //-------------------------------
        //I HAVE
        //-------------------------------
        
        ResultatJourExtension rje = new ResultatJourExtension(stdSetChargeRec);
        //-------------------------------
        //I DO
        //-------------------------------
        Test.startTest();
        Decimal result = rje.getSeanceCost();
        Test.stopTest();
        //-------------------------------
        //I TEST
        //-------------------------------
        System.assertEquals(150, result);
    }
    @isTest
    static void getChargeCostTest(){
        //-------------------------------
        //I HAVE
        //-------------------------------
        
        ResultatJourExtension rje = new ResultatJourExtension(stdSetChargeRec);
        //-------------------------------
        //I DO
        //-------------------------------
        Test.startTest();
        Decimal result = rje.getChargeCost();
        Test.stopTest();
        //-------------------------------
        //I TEST
        //-------------------------------
        System.assertEquals(100, result);
    }
    @isTest
    static void getTotalProduitsTest(){
        //-------------------------------
        //I HAVE
        //-------------------------------
        
        ResultatJourExtension rje = new ResultatJourExtension(stdSetChargeRec);

        //-------------------------------
        //I DO
        //-------------------------------
        Test.startTest();
        Decimal result = rje.getTotalProduits();
        Test.stopTest();
        //-------------------------------
        //I TEST
        //-------------------------------
        System.assertEquals(120, result);
    }
    @isTest
    static void getTotalChargesTest(){
        //-------------------------------
        //I HAVE
        //-------------------------------
        
        ResultatJourExtension rje = new ResultatJourExtension(stdSetChargeRec);
 

        //-------------------------------
        //I DO
        //-------------------------------
        Test.startTest();
        Decimal result = rje.getTotalCharges();
        Test.stopTest();
        //-------------------------------
        //I TEST
        //-------------------------------
        System.assertEquals(275.1, result);
    }
    @isTest
    static void getResultatTotalTest(){
        //-------------------------------
        //I HAVE
        //-------------------------------
        
        ResultatJourExtension rje = new ResultatJourExtension(stdSetChargeRec);

        //-------------------------------
        //I DO
        //-------------------------------
        Test.startTest();
        Decimal result = rje.getResultatTotal();
        Test.stopTest();
        //-------------------------------
        //I TEST
        //-------------------------------
        System.assertEquals(-155.1, result);
    }
}
