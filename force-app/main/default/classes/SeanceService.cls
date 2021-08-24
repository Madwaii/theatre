public with sharing class SeanceService {
    public static Boolean assertNoOtherSeanceAtSameTime(List<Seance__c> seanceList) {
        //check if empty arguments
        if (seanceList == null || seanceList.size() == 0) {
            return null; //empty list
        }
        Boolean result = true;
        //check firstly if seances in list have different dates
        for (Seance__c seance1 : seanceList) {
            for (Seance__c seance2 : seanceList) {
                if (seance1 != seance2) {
                    if (haveEqualSalleAndTime(seance1, seance2)) {
                        seance1.addError(
                            System.Label.Conflit_Date_Dans_Liste
                        );
                        result = false;
                    }
                }
            }
        }
        if (result) {
            //get other seances with corresponding salles OR times
            List<Seance__c> otherSeanceList = SeanceDAO.getOtherSeanceAtSameTime(
                seanceList
            );
            //filter those results so it corresponds to same date AND time

            for (Integer i = otherSeanceList.size() - 1; i >= 0; i--) {
                Seance__c otherSeance = otherSeanceList[i];
                Boolean rmvThisSeance = true;
                for (Seance__c seance : seanceList) {
                    if (haveEqualSalleAndTime(seance, otherSeance)) {
                        rmvThisSeance = false;
                    }
                }
                if (rmvThisSeance)
                    otherSeanceList.remove(i);
            }
            if (otherSeanceList.size() != 0) {
                seanceList[0]
                    .addError(
                        System.label.Conflit_Seance
                    );
                result = false;
            }
        }
        return result;
    }

    //assert if two seances have the same salle, jour and heure
    @TestVisible
    private static Boolean haveEqualSalleAndTime(Seance__c seance1, Seance__c seance2) {
        return ((seance1.Salle__c != null &&
        seance1.Heure__c != null &&
        seance1.Jour__c != null) &&
        (seance1.Salle__c == seance2.Salle__c &&
        seance1.Heure__c == seance2.Heure__c &&
        seance1.Jour__c == seance2.Jour__c));
    }
}
