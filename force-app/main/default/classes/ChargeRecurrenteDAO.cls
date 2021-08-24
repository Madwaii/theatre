public with sharing class ChargeRecurrenteDAO {
    public static List<Charge_recurrente__c> getChargesRecurrentes() {
        return [SELECT Id, Name, Cout_journalier__c, Gain_ou_depense__c FROM Charge_recurrente__c];
    }
}
