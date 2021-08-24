public with sharing class CleanOldTicketsApexController {
    @AuraEnabled
    public static string cleanTicketsApex(String beforeDateJSON) {
        Date beforeDate = Date.valueOf(beforeDateJSON);
        if (beforeDate >= System.today()) {
            String message = System.label.Erreur_Date_Nettoyage;
            AuraHandledException error = new AuraHandledException(message);
            error.setMessage(message);
            throw error;
        }
        CleanOldTicketsBatch cotb = new CleanOldTicketsBatch(beforeDate);
        Id batchId = Database.executeBatch(cotb);
        return 'Clean successfully started';
    }
}
