public with sharing class CleanOldTicketsBatch implements Database.Batchable<sObject> {
    private Date beforeDate;

    public CleanOldTicketsBatch(){
        this.beforeDate = System.today().addDays(-90);
    }
    public CleanOldTicketsBatch(Date customBeforeDate){
        this.beforeDate=customBeforeDate;
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        Datetime beforeDatetime = datetime.newInstance(
            beforeDate.year(),
            beforeDate.month(),
            beforeDate.day()
        );
        String beforeString = beforeDatetime.format(
            'yyyy-MM-dd'
        );
        String query =
            'SELECT Id FROM Ticket__c WHERE Vendu__c=FALSE AND Seance__r.Jour__c <' +
            beforeString;
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext bc, List<Ticket__c> scope) {
        // process each batch of records
        delete scope;
    }
    public void finish(Database.BatchableContext bc) {
        // execute any post-processing operations
    }
}
