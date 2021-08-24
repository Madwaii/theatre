global with sharing class RemindOldClientsCRON implements Schedulable {
    global void execute(SchedulableContext sc) {
        RemindOldClientsBatch rocb = new RemindOldClientsBatch();
        Database.executeBatch(rocb,200);
    }
}
