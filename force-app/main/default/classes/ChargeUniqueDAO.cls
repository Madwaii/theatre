public with sharing class ChargeUniqueDAO {

    public static List<Charge_unique__c> getChargesUniquesInPeriod(String Period) {
        return Database.query('SELECT Id, Montant__c, Gain_ou_depense__c '+
        'FROM Charge_unique__c WHERE  Date__c='+Period);
    }

    public static List<Charge_unique__c> getChargesUniquesBetween(Date startDate, Date endDate) {
        return [SELECT Id, Montant__c, Gain_ou_depense__c 
        FROM Charge_unique__c WHERE  Date__c>=:startDate AND Date__c<=:endDate];
    }
}
