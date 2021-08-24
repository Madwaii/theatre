public with sharing class ZoneChoiceController {
    @AuraEnabled
    public static List<Zone__c> getZones(Id seanceId) {
        System.debug('in the controller, seanceId ='+ seanceId);
        return ZoneDAO.getSeanceZoneList(new List<Id>{ seanceId });
    }
}
