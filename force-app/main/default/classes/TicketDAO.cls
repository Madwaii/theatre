public with sharing class TicketDAO {
    public static List<Ticket__c> getTicketsWithBuyer(
        List<Seance__c> seanceList
    ) {
        return [
            SELECT Id
            FROM Ticket__c
            WHERE Seance__c IN :seanceList AND Acheteur__c != ''
        ];
    }
    public static List<Ticket__c> getTicketsWithBuyerFromId(
        List<Id> seanceIdList
    ) {
        return [
            SELECT Id, Place__c, Prix__c, Vendu__c, Acheteur__c, Zone__r.Name
            FROM Ticket__c
            WHERE Seance__c IN :seanceIdList AND Acheteur__c != ''
        ];
    }
    public static List<Ticket__c> getSeanceTicketList(List<Id> seanceIdList) {
        return [
            SELECT Id, Place__c, Zone__c
            FROM Ticket__c
            WHERE Seance__c IN :seanceIdList
        ];
    }
    public static List<Ticket__c> getSeancesInformations(
        List<Id> ticketIdList
    ) {
        return [
            SELECT
                Id,
                Name,
                Acheteur__c,
                Vendu__c,
                Place__c,
                QR_Code__c,
                Prix__c,
                Zone__c,
                Zone__r.Name,
                Seance__c,
                Seance__r.Name,
                Seance__r.Representation__r.Name,
                Seance__r.Jour__c,
                Seance__r.Heure__c,
                Seance__r.Salle__r.Name
            FROM Ticket__c
            WHERE Id IN :ticketIdList
        ];
    }
}
