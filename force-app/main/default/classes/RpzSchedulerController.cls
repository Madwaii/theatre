public with sharing class RpzSchedulerController {
    @AuraEnabled
    public static List<Seance__c> getSeances() {
        return SeanceDAO.getSeanceList();
    }
}
