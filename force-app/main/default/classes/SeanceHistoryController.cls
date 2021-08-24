public with sharing class SeanceHistoryController {
    private static String VRAIE_SEANCE_ID = Schema.SObjectType.Seance__c.getRecordTypeInfosByDeveloperName()
    .get('Vraie_seance')
    .getRecordTypeId();
private static String SEANCE_PATRON_ID = Schema.SObjectType.Seance__c.getRecordTypeInfosByDeveloperName()
    .get('Seance_patron')
    .getRecordTypeId();
    @AuraEnabled
    public static List<Seance__c> getSeances() {
        return SeanceDAO.getSeanceList();
    }
}
