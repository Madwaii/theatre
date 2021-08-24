@isTest
public with sharing class ResultatCustomControllerTest {
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
        Representation__c rpz = new Representation__c(
            Name = 'RPZ TEST',
            Artiste__c = artiste.Id
        );
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
            Cout__c = 150
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
        chargeUniList.add(
            new Charge_unique__c(
                Gain_ou_depense__c = 'Gain',
                Montant__c = 100,
                Name = 'Test Gain Unique',
                Date__c = System.today()
            )
        );
        chargeUniList.add(
            new Charge_unique__c(
                Gain_ou_depense__c = 'Dépense',
                Montant__c = 100,
                Name = 'Test Dépense Unique',
                Date__c = System.today()
            )
        );
        insert chargeUniList;
        List<Charge_recurrente__c> chargeRecList = new List<Charge_recurrente__c>();
        chargeRecList.add(
            new Charge_recurrente__c(
                Gain_ou_depense__c = 'Gain',
                Cout_journalier__c = 10,
                Name = 'Test Gain Récurrent'
            )
        );
        chargeRecList.add(
            new Charge_recurrente__c(
                Gain_ou_depense__c = 'Dépense',
                Cout_journalier__c = 10,
                Name = 'Test Dépense Récurrente'
            )
        );
        insert chargeRecList;

    }
    @isTest
    static void getTicketRevenueTest() {
        //-------------------------------
        //I HAVE
        //-------------------------------
        PageReference pageRef = Page.ResultatCustom;
        Test.setCurrentPageReference(pageRef);
        pageRef.getParameters().put('startDate', ((Datetime) System.today()).format('yyyy-MM-dd'));
        pageRef.getParameters().put('endDate',((Datetime) System.today().addDays(6)).format('yyyy-MM-dd'));
        ResultatCustomController rcc = new ResultatCustomController();
        //-------------------------------
        //I DO
        //-------------------------------
        Test.startTest();
        Decimal result = rcc.getTicketRevenue();
        Test.stopTest();
        //-------------------------------
        //I TEST
        //-------------------------------
        System.assertEquals(10, result);
    }
    @isTest
    static void getGainRevenueTest() {
        //-------------------------------
        //I HAVE
        //-------------------------------

        PageReference pageRef = Page.ResultatCustom;
        Test.setCurrentPageReference(pageRef);
        pageRef.getParameters().put('startDate', ((Datetime) System.today()).format('yyyy-MM-dd'));
        pageRef.getParameters().put('endDate',((Datetime) System.today().addDays(6)).format('yyyy-MM-dd'));
        ResultatCustomController rcc = new ResultatCustomController();
        //-------------------------------
        //I DO
        //-------------------------------
        Test.startTest();
        Decimal result = rcc.getGainRevenue();
        Test.stopTest();
        //-------------------------------
        //I TEST
        //-------------------------------
        System.assertEquals(100, result);
    }
    @isTest
    static void getArtistCostTest() {
        //-------------------------------
        //I HAVE
        //-------------------------------
        PageReference pageRef = Page.ResultatCustom;
        Test.setCurrentPageReference(pageRef);
        pageRef.getParameters().put('startDate', ((Datetime) System.today()).format('yyyy-MM-dd'));
        pageRef.getParameters().put('endDate',((Datetime) System.today().addDays(6)).format('yyyy-MM-dd'));
        ResultatCustomController rcc = new ResultatCustomController();
        //-------------------------------
        //I DO
        //-------------------------------
        Test.startTest();
        Decimal result = rcc.getArtistCost();
        Test.stopTest();
        //-------------------------------
        //I TEST
        //-------------------------------
        System.assertEquals(105.1, result);
    }
    @isTest
    static void getChargeRecDepenseListTest() {
        //-------------------------------
        //I HAVE
        //-------------------------------
        PageReference pageRef = Page.ResultatCustom;
        Test.setCurrentPageReference(pageRef);
        pageRef.getParameters().put('startDate', ((Datetime) System.today()).format('yyyy-MM-dd'));
        pageRef.getParameters().put('endDate',((Datetime) System.today().addDays(6)).format('yyyy-MM-dd'));
        ResultatCustomController rcc = new ResultatCustomController();
        //-------------------------------
        //I DO
        //-------------------------------
        Test.startTest();
        List<Charge_recurrente__c> result = rcc.getChargeRecDepenseList();
        Test.stopTest();
        //-------------------------------
        //I TEST
        //-------------------------------
        System.assertEquals(10, result[0].Cout_journalier__c);
    }
    @isTest
    static void getChargeRecGainListTest() {
        //-------------------------------
        //I HAVE
        //-------------------------------
        PageReference pageRef = Page.ResultatCustom;
        Test.setCurrentPageReference(pageRef);
        pageRef.getParameters().put('startDate', ((Datetime) System.today()).format('yyyy-MM-dd'));
        pageRef.getParameters().put('endDate',((Datetime) System.today().addDays(6)).format('yyyy-MM-dd'));
        ResultatCustomController rcc = new ResultatCustomController();
        //-------------------------------
        //I DO
        //-------------------------------
        Test.startTest();
        List<Charge_recurrente__c> result = rcc.getChargeRecGainList();
        Test.stopTest();
        //-------------------------------
        //I TEST
        //-------------------------------
        System.assertEquals(10, result[0].Cout_journalier__c);
    }
    @isTest
    static void getFirstDayTest() {
        //-------------------------------
        //I HAVE
        //-------------------------------
        PageReference pageRef = Page.ResultatCustom;
        Test.setCurrentPageReference(pageRef);
        pageRef.getParameters().put('startDate', ((Datetime) System.today()).format('yyyy-MM-dd'));
        pageRef.getParameters().put('endDate',((Datetime) System.today().addDays(6)).format('yyyy-MM-dd'));
        ResultatCustomController rcc = new ResultatCustomController();
        //-------------------------------
        //I DO
        //-------------------------------
        Test.startTest();
        Date result = rcc.getFirstDay();
        Test.stopTest();
        //-------------------------------
        //I TEST
        //-------------------------------
        System.assertEquals(System.today(), result);
    }
    @isTest
    static void getLastDayTest() {
        //-------------------------------
        //I HAVE
        //-------------------------------
        PageReference pageRef = Page.ResultatCustom;
        Test.setCurrentPageReference(pageRef);
        pageRef.getParameters().put('startDate', ((Datetime) System.today()).format('yyyy-MM-dd'));
        pageRef.getParameters().put('endDate',((Datetime) System.today().addDays(6)).format('yyyy-MM-dd'));
        ResultatCustomController rcc = new ResultatCustomController();
        //-------------------------------
        //I DO
        //-------------------------------
        Test.startTest();
        Date result = rcc.getLastDay();
        Test.stopTest();
        //-------------------------------
        //I TEST
        //-------------------------------
        System.assertEquals(System.today().addDays(6), result);
    }
    @isTest
    static void getNumberOfDaysTest() {
        //-------------------------------
        //I HAVE
        //-------------------------------
        PageReference pageRef = Page.ResultatCustom;
        Test.setCurrentPageReference(pageRef);
        pageRef.getParameters().put('startDate', ((Datetime) System.today()).format('yyyy-MM-dd'));
        pageRef.getParameters().put('endDate',((Datetime) System.today().addDays(6)).format('yyyy-MM-dd'));
        ResultatCustomController rcc = new ResultatCustomController();
        //-------------------------------
        //I DO
        //-------------------------------
        Test.startTest();
        Integer result = rcc.getNumberOfDays();
        Test.stopTest();
        //-------------------------------
        //I TEST
        //-------------------------------
        System.assertEquals(7, result);
    }
    @isTest
    static void getSeanceCostTest() {
        //-------------------------------
        //I HAVE
        //-------------------------------
        PageReference pageRef = Page.ResultatCustom;
        Test.setCurrentPageReference(pageRef);
        pageRef.getParameters().put('startDate', ((Datetime) System.today()).format('yyyy-MM-dd'));
        pageRef.getParameters().put('endDate',((Datetime) System.today().addDays(6)).format('yyyy-MM-dd'));
        ResultatCustomController rcc = new ResultatCustomController();
        //-------------------------------
        //I DO
        //-------------------------------
        Test.startTest();
        Decimal result = rcc.getSeanceCost();
        Test.stopTest();
        //-------------------------------
        //I TEST
        //-------------------------------
        System.assertEquals(150, result);
    }
    @isTest
    static void getChargeCostTest() {
        //-------------------------------
        //I HAVE
        //-------------------------------
        PageReference pageRef = Page.ResultatCustom;
        Test.setCurrentPageReference(pageRef);
        pageRef.getParameters().put('startDate', ((Datetime) System.today()).format('yyyy-MM-dd'));
        pageRef.getParameters().put('endDate',((Datetime) System.today().addDays(6)).format('yyyy-MM-dd'));
        ResultatCustomController rcc = new ResultatCustomController();
        //-------------------------------
        //I DO
        //-------------------------------
        Test.startTest();
        Decimal result = rcc.getChargeCost();
        Test.stopTest();
        //-------------------------------
        //I TEST
        //-------------------------------
        System.assertEquals(100, result);
    }
    @isTest
    static void getTotalProduitsTest() {
        //-------------------------------
        //I HAVE
        //-------------------------------
        PageReference pageRef = Page.ResultatCustom;
        Test.setCurrentPageReference(pageRef);
        pageRef.getParameters().put('startDate', ((Datetime) System.today()).format('yyyy-MM-dd'));
        pageRef.getParameters().put('endDate',((Datetime) System.today().addDays(6)).format('yyyy-MM-dd'));
        ResultatCustomController rcc = new ResultatCustomController();

        //-------------------------------
        //I DO
        //-------------------------------
        Test.startTest();
        Decimal result = rcc.getTotalProduits();
        Test.stopTest();
        //-------------------------------
        //I TEST
        //-------------------------------
        System.assertEquals(180, result);
    }
    @isTest
    static void getTotalChargesTest() {
        //-------------------------------
        //I HAVE
        //-------------------------------
        PageReference pageRef = Page.ResultatCustom;
        Test.setCurrentPageReference(pageRef);
        pageRef.getParameters().put('startDate', ((Datetime) System.today()).format('yyyy-MM-dd'));
        pageRef.getParameters().put('endDate',((Datetime) System.today().addDays(6)).format('yyyy-MM-dd'));
        ResultatCustomController rcc = new ResultatCustomController();


        //-------------------------------
        //I DO
        //-------------------------------
        Test.startTest();
        Decimal result = rcc.getTotalCharges();
        Test.stopTest();
        //-------------------------------
        //I TEST
        //-------------------------------
        System.assertEquals(425.1, result);
    }
    @isTest
    static void getResultatTotalTest() {
        //-------------------------------
        //I HAVE
        //-------------------------------
        PageReference pageRef = Page.ResultatCustom;
        Test.setCurrentPageReference(pageRef);
        pageRef.getParameters().put('startDate', ((Datetime) System.today()).format('yyyy-MM-dd'));
        pageRef.getParameters().put('endDate',((Datetime) System.today().addDays(6)).format('yyyy-MM-dd'));
        ResultatCustomController rcc = new ResultatCustomController();

        //-------------------------------
        //I DO
        //-------------------------------
        Test.startTest();
        Decimal result = rcc.getResultatTotal();
        Test.stopTest();
        //-------------------------------
        //I TEST
        //-------------------------------
        System.assertEquals(-245.1, result);
    }
}
