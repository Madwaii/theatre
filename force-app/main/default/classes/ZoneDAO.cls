public with sharing class ZoneDAO {
    public static List<Zone__c> getSeanceZoneList(List<Id> seanceIdList) {
        return [
            SELECT Id, Name, Nombre_de_places__c, Seance__c, Seance__r.Name
            FROM Zone__c
            WHERE Seance__c IN :seanceIdList
        ];
    }
}