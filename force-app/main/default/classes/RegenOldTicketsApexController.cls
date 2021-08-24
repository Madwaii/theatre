public with sharing class RegenOldTicketsApexController {
    @AuraEnabled
    public static string regenTicketsApex(Id seanceId) {
            TicketService.regenerateOldTickets(new List<Id> {seanceId});
            return 'success';
    }
}
