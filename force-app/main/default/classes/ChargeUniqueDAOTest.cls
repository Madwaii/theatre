@isTest
public with sharing class ChargeUniqueDAOTest {
    @isTest
    public static void getChargesUniquesInPeriodTest() {
        //-------------------------------
        //I HAVE
        //-------------------------------
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
                Date__c = System.today().addDays(1)
            )
        );
        insert chargeUniList;
        //-------------------------------
        //I DO
        //-------------------------------
        Test.startTest();
        List<Charge_unique__c> resultList = ChargeUniqueDAO.getChargesUniquesInPeriod('TODAY');
        Test.stopTest();
        //-------------------------------
        //I TEST
        //-------------------------------
        System.assertEquals(1, resultList.size());
    }
    @isTest
    public static void getChargesUniquesBetweenTest() {
        //-------------------------------
        //I HAVE
        //-------------------------------
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
                Date__c = System.today().addDays(1)
            )
        );
        insert chargeUniList;
        //-------------------------------
        //I DO
        //-------------------------------
        Test.startTest();
        List<Charge_unique__c> resultList = ChargeUniqueDAO.getChargesUniquesBetween(System.today(), System.today().addDays(1));
        Test.stopTest();
        //-------------------------------
        //I TEST
        //-------------------------------
        System.assertEquals(2, resultList.size());
    }
}
