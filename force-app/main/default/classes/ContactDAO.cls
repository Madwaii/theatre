public with sharing class ContactDAO {
    public static List<Contact> getPaidArtists() {
        return [
            SELECT Id, Prime__c, Salaire_journalier_fixe__c
            FROM Contact
            WHERE
                Salaire_journalier_fixe__c != NULL
                AND Salaire_journalier_fixe__c != 0
        ];
    }
    public static List<Contact> getRelatedBuyers(List<Id> ticketIdList) {
        return [SELECT FirstName,LastName, Email FROM Contact WHERE Id IN 
        (SELECT Acheteur__c FROM Ticket__c WHERE Id IN :ticketIdList)];
    }
}
