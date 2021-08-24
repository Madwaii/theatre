public with sharing class TicketHistoryController {
    @AuraEnabled
    public static List<Ticket__c> getTicketsFromSeance(Id seanceId) {
        return TicketDAO.getTicketsWithBuyerFromId(new List<Id>{ seanceId });
    }

    @AuraEnabled
    public static void cancelRecords(List<Id> ticketIdList) {
        List<Ticket__c> ticketList = new List<Ticket__c>();
        for (Ticket__c ticket : [
            SELECT Id, Acheteur__c, Vendu__c
            FROM Ticket__c
            WHERE Id IN :ticketIdList
        ]) {
            ticket.Acheteur__c=null;
            ticket.Vendu__c=false;
            ticketList.add(ticket);
        }

        if (ticketList.size() > 0) {
            update ticketList;
        }
    }
}
