public with sharing class RepresentationDAO {
    public static List<Representation__c> getUpcomingRepresentations() {
        Date today = System.today();
        return [
            SELECT
                Id,
                Name,
                Image__c,
                Artiste__c,
                Artiste__r.FirstName,
                Artiste__r.LastName
            FROM Representation__c
            WHERE
                Id IN (
                    SELECT Representation__c
                    FROM Seance__c 
                    WHERE Jour__c >= :today 
                )
                ORDER BY Name
        ];
    }
}
