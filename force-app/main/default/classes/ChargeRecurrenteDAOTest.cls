@isTest
public with sharing class ChargeRecurrenteDAOTest {
    @isTest
    public static void getChargesRecurrentesTest() {
        //-------------------------------
        //I HAVE
        //-------------------------------
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
        //-------------------------------
        //I DO
        //-------------------------------
        Test.startTest();
        List<Charge_recurrente__c> resultList = ChargeRecurrenteDAO.getChargesRecurrentes();
        Test.stopTest();
        //-------------------------------
        //I TEST
        //-------------------------------
        System.assertEquals(2, resultList.size());
    }
}
