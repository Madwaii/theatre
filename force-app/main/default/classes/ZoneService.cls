public with sharing class ZoneService {
    public static List<Zone__c> duplicatePatronZones(List<Id> patronIdList, List<Seance__c> seanceList) {
        //check if empty arguments
        if( seanceList == null || patronIdList == null || seanceList.size()==0 || patronIdList.size()==0){
            return null; //empty list
        }
        //fetch patron zones
        List<Zone__c> patronZoneList = ZoneDAO.getSeanceZoneList(patronIdList);
        //clone zones corresponding to seance and reassign them
        List<Zone__c> newZoneList = new List<Zone__c>();
        for (Integer i = 0; i<patronIdList.size(); i++) {
            for (Zone__c zone : patronZoneList){
                if (zone.Seance__c==patronIdList[i]) {
                    System.debug(zone);
                    Zone__c newZone = zone.clone(false);
                    newZone.Seance__c = seanceList[i].Id;
                    newZone.Seance__r.Name = seanceList[i].Name;
                    System.debug(newZone);
                    newZoneList.add(newZone);
                }
            }
        }
        insert newZoneList;
        return newZoneList;
    }
}