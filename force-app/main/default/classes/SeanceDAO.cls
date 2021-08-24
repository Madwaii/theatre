public with sharing class SeanceDAO {
    public static List<Seance__c> getOtherSeanceAtSameTime(List<Seance__c> seanceList) {
        //extract all ids, salles , jours and heures to filter
        List<Id> idList = new List<Id>();
        List<Id> salleList = new List<Id>();
        List<Date> jourList = new List<Date>();
        List<String> heureList = new List<String>();
        for (Seance__c seance : seanceList) {
            idList.add(seance.Id);
            salleList.add(seance.Salle__c);
            jourList.add(seance.Jour__c);
            heureList.add(seance.Heure__c);
        }


        List<Seance__c> otherSeanceList = [
            SELECT Id, Salle__c, Jour__c, Heure__c
            FROM Seance__c
            WHERE
                Id NOT IN :idList
                AND Salle__c IN :salleList
                AND Jour__c IN :jourList
                AND Heure__c IN :heureList
        ];
        return otherSeanceList;
    }
    public static List<Seance__c> getSeancesInPeriod(String Period) {
        return Database.query('SELECT Id, Revenu__c, Representation__r.Artiste__c, Cout__c '+
        'FROM Seance__c WHERE Representation__c != null AND Jour__c='+Period);
    }

    public static List<Seance__c> getSeancesBetween(Date startDate, Date endDate) {
        return [SELECT Id, Revenu__c, Representation__r.Artiste__c, Cout__c 
        FROM Seance__c WHERE Representation__c != null AND Jour__c>=:startDate AND Jour__c<=:endDate];
    }

    public static List<Seance__c> getSeanceList() {
        return [SELECT Id, Salle__c, Salle__r.Name, Heure__c, Jour_et_Heure__c, Jour__c, Representation__r.Name, Ticket_vendus__c, Revenu__c FROM Seance__c WHERE Jour_et_Heure__c != null ORDER BY Jour_et_Heure__c DESC];
    }
}