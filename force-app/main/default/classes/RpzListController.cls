public with sharing class RpzListController {
    @AuraEnabled
    public static List<Representation__c> getUpcomingRpz() {
        return RepresentationDAO.getUpcomingRepresentations();
    }
}
