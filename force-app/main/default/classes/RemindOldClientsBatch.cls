public with sharing class RemindOldClientsBatch implements Database.Batchable<sObject> {
    private Date beforeDate;
    private Id orgMailId;

    public RemindOldClientsBatch() {
        beforeDate = System.today().addDays(-365);
        orgMailId = [
                    SELECT id, Address, DisplayName
                    FROM OrgWideEmailAddress
                    LIMIT 1
                ].Id;
    }
    public Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        String query = 'SELECT Id, FirstName, LastName, Email, Reminded__c, (SELECT Seance__r.Representation__r.Name, Seance__r.Jour__c FROM Tickets__r ORDER BY Seance__r.Jour__c DESC LIMIT 1) FROM Contact';
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext bc, List<Contact> scope) {
        // process each batch of records
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        for (Contact contact : scope) {
            if (contact.Tickets__r != null && contact.Tickets__r.size()!=0){
                if(contact.Email != null && contact.Email !='' && contact.Reminded__c != true) {
                    if(contact.Tickets__r[0].Seance__r.Jour__c <= beforeDate){
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setOrgWideEmailAddressId(orgMailId);
                        mail.setToAddresses(new List<String>{ contact.Email });
                        mail.setSubject('La culture n\'attend pas !');
                        mail.setHtmlBody(
                            'Bonjour'+((contact.FirstName!=null)? (' '+contact.FirstName) : '')+' '+contact.LastName+', <br/> Vous êtes venus il y a un an déjà au théâtre Viser-Haut pour assister à "'+contact.Tickets__r[0].Seance__r.Representation__r.Name+'". <br/>Si le spectacle vous a plu, que diriez vous de découvrir nos nouvelles représentations ?<br/>Vous pouvez les consulter ici :<br/><br/><b>INSERER LIEN SITE</b><br/><br/>Nous espérons vous revoir bientôt et vous souhaitons une bonne journée,<br/><br/>Le Théâtre Viser-Haut.'
                        );
                        mails.add(mail);
                        contact.Reminded__c=true;
                    }
                }
            }
        }
        if (!mails.isEmpty()) {
            Messaging.SendEmail(mails);
            update scope;
        }
    }
    public void finish(Database.BatchableContext bc) {
        // execute any post-processing operations
    }
}
