public with sharing class TicketTriggerHandler {

    public static void afterUpdate(
        List<Ticket__c> tNew,
        Map<Id, Ticket__c> tOldMap
    ) {
        //get only tickets that have just been boughts
        List<Ticket__c> ticketsJustBoughtList = new List<Ticket__c>();
        for (Ticket__c ticket : tNew){
            if (ticket.Vendu__c != tOldMap.get(ticket.Id).Vendu__c) {
                ticketsJustBoughtList.add(ticket);
            }
        }
        TicketService.sendReceipt(ticketsJustBoughtList);
    }
}
