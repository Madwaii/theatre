public with sharing class SeanceTriggerHandler {
    private static String VRAIE_SEANCE_ID = Schema.SObjectType.Seance__c.getRecordTypeInfosByDeveloperName()
        .get('Vraie_seance')
        .getRecordTypeId();
    private static String SEANCE_PATRON_ID = Schema.SObjectType.Seance__c.getRecordTypeInfosByDeveloperName()
        .get('Seance_patron')
        .getRecordTypeId();

    public static void afterInsert(List<Seance__c> seanceList) {
        List<Id> patronIdList = new List<Id>();
        List<Seance__c> realSeanceList = new List<Seance__c>();
        //get only the non patron seances
        for (Seance__c seance : seanceList) {
            if (seance.RecordTypeId == VRAIE_SEANCE_ID) {
                patronIdList.add(seance.Patron_de_seance__c);
                realSeanceList.add(seance);
            }
        }
        List<Zone__c> newZoneList = ZoneService.duplicatePatronZones(
            patronIdList,
            realSeanceList
        );
        TicketService.generateZoneTickets(newZoneList);
    }

    public static void beforeUpdate(
        List<Seance__c> tNew,
        Map<Id, Seance__c> tOldMap
    ) {
        //get the seances where zone has been changed
        List<Seance__c> salleChangedList = new List<Seance__c>();
        List<Id> salleChangedIdList = new List<Id>();
        for (Seance__c seance : tNew) {
            if (seance.Salle__c != tOldMap.get(seance.Id).Salle__c) {
                salleChangedList.add(seance);
                salleChangedIdList.add(seance.Id);
            }
        }
        TicketService.assertTicketsWithoutBuyers(salleChangedList);
    }
    public static void afterUpdate(
        List<Seance__c> tNew,
        Map<Id, Seance__c> tOldMap
    ) {
        //get the seances where zone has been changed
        List<Seance__c> salleChangedList = new List<Seance__c>();
        List<Id> salleChangedIdList = new List<Id>();
        for (Seance__c seance : tNew) {
            if (seance.Salle__c != tOldMap.get(seance.Id).Salle__c) {
                salleChangedList.add(seance);
                salleChangedIdList.add(seance.Id);
            }
        }
        //delete old zones and tickets
        List<Zone__c> oldZoneList = ZoneDAO.getSeanceZoneList(
            salleChangedIdList
        );
        delete oldZoneList;
        //generate new Tickets, like in creation
        List<Id> patronIdList = new List<Id>();
        List<Seance__c> realSeanceList = new List<Seance__c>();
        for (Seance__c seance : salleChangedList) {
            if (seance.RecordTypeId == VRAIE_SEANCE_ID) {
                patronIdList.add(seance.Patron_de_seance__c);
                realSeanceList.add(seance);
            }
        }
        List<Zone__c> newZoneList = ZoneService.duplicatePatronZones(
            patronIdList,
            realSeanceList
        );
        TicketService.generateZoneTickets(newZoneList);
    }

    public static void beforeInsert(List<Seance__c> seanceList) {
        SeanceService.assertNoOtherSeanceAtSameTime(seanceList);
    }
}
