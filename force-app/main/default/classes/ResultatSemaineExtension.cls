public with sharing class ResultatSemaineExtension {
    private List<Seance__c> seanceList;
    private List<Contact> contactList;
    private List<Charge_recurrente__c> chargeRecList;
    private List<Charge_unique__c> chargeUniList;
    private Decimal ticketRevenue;
    private Decimal gainRevenue;
    private Decimal artistCost;
    private Decimal seanceCost;
    private Date firstDay;
    private Date lastDay;
    private Decimal resultat;
    private Decimal chargeCost;
    private Decimal totalCharges;
    private Decimal totalProduits;

    public ResultatSemaineExtension(
        ApexPages.StandardSetController stdSetController
    ) { 
        firstDay=System.today().toStartOfWeek();
        lastDay=firstDay.addDays(6);
        seanceList = SeanceDAO.getSeancesInPeriod('THIS_WEEK');
        chargeUniList = ChargeUniqueDAO.getChargesUniquesInPeriod('THIS_WEEK');
        chargeRecList = ChargeRecurrenteDAO.getChargesRecurrentes();
        contactList = ContactDAO.getPaidArtists();
        String fileName = 'ResultatSemaine.pdf' ;
        Apexpages.currentPage().getHeaders().put( 'content-disposition', 'inline; filename=' + fileName );  
    }
    public Decimal getTicketRevenue(){
        ticketRevenue = 0;
        for (Seance__c seance : seanceList) {
            ticketRevenue+=seance.Revenu__c;
        }
        return ticketRevenue;
    }

    public Decimal getGainRevenue(){
        gainRevenue=0;
        for (Charge_unique__c chargeUni : chargeUniList) {
            if (chargeUni.Gain_ou_depense__c=='Gain'){
                gainrevenue+=chargeUni.Montant__c;
            }
        }
        return gainRevenue;
    }

    public Decimal getArtistCost() {
        artistCost=0;
        for (Contact contact : contactList){
            artistCost+=contact.Salaire_journalier_fixe__c*7;
            for (Seance__c seance : seanceList) {
                if (seance.Representation__r.Artiste__c==contact.Id){
                    artistCost+=seance.Revenu__c*(contact.Prime__c/100);
                }
            }
        }
        return artistCost;
    }

    public List<Charge_recurrente__c> getChargeRecDepenseList(){
        List<Charge_recurrente__c> chargeRecDepenseList = new List<Charge_recurrente__c>();
        for (Charge_recurrente__c chargeRec : chargeRecList) {
            if (chargeRec.Gain_ou_depense__c=='Dépense') {
                chargeRecDepenseList.add(chargeRec);
            }
        }
        return chargeRecDepenseList;
    }
    public List<Charge_recurrente__c> getChargeRecGainList(){
        List<Charge_recurrente__c> chargeRecGainList = new List<Charge_recurrente__c>();
        for (Charge_recurrente__c chargeRec : chargeRecList) {
            if (chargeRec.Gain_ou_depense__c=='Gain') {
                chargeRecGainList.add(chargeRec);
            }
        }
        return chargeRecGainList;
    }
    public Date getFirstDayOfWeek(){
        return firstDay;
    }
    public Date getLastDayOfWeek(){
        return lastDay;
    }
    public Decimal getSeanceCost(){
        seanceCost = 0;
        for (Seance__c seance : seanceList) {
            seanceCost+=seance.Cout__c;
        }
        return seanceCost;
    }
    public Decimal getChargeCost() {
        chargeCost=0;
        for (Charge_unique__c chargeUni : chargeUniList) {
            if (chargeUni.Gain_ou_depense__c=='Dépense'){
                chargeCost+=chargeUni.Montant__c;
            }
        }
        return chargeCost;
    }
    public Decimal getTotalProduits(){
        totalProduits = ticketRevenue+gainRevenue;
        for (Charge_recurrente__c chargeRec : chargeRecList) {
            if (chargeRec.Gain_ou_depense__c == 'Gain')
            totalProduits+=chargeRec.Cout_journalier__c*7;
        }
        return totalProduits;
    }

    public Decimal getTotalCharges(){
        totalCharges=artistCost+seanceCost+chargeCost;
        for (Charge_recurrente__c chargeRec : chargeRecList) {
            if (chargeRec.Gain_ou_depense__c == 'Dépense')
            totalCharges+=chargeRec.Cout_journalier__c*7;
        }
        return totalCharges;
    }
    public Decimal getResultatTotal(){
        resultat=totalProduits-totalCharges;
        return resultat;
    }
}
