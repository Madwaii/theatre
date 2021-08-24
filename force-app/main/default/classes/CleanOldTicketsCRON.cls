global with sharing class CleanOldTicketsCRON implements Schedulable {
    global void execute(SchedulableContext sc) {
        CleanOldTicketsBatch cotb = new CleanOldTicketsBatch();
        Database.executeBatch(cotb,200);
    }
}
