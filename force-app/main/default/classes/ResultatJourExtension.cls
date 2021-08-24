public with sharing class ResultatJourExtension {
    private List<Seance__c> seanceList;
    private List<Contact> contactList;
    private List<Charge_recurrente__c> chargeRecList;
    private List<Charge_unique__c> chargeUniList;
    private Decimal ticketRevenue;
    private Decimal gainRevenue;
    private Decimal artistCost;
    private Decimal seanceCost;
    private Date today;
    private Decimal resultat;
    private Decimal chargeCost;
    private Decimal totalCharges;
    private Decimal totalProduits;

    public ResultatJourExtension(
        ApexPages.StandardSetController stdSetController
    ) {
        today = System.today();
        seanceList = SeanceDAO.getSeancesInPeriod('TODAY');
        chargeUniList = ChargeUniqueDAO.getChargesUniquesInPeriod('TODAY');
        chargeRecList = ChargeRecurrenteDAO.getChargesRecurrentes();
        contactList = ContactDAO.getPaidArtists();
        setTicketRevenue();
        setGainRevenue();
        setArtistCost();
        setSeanceCost();
        setChargeCost();
        setTotalProduits();
        setTotalCharges();
        setResultat();
        String fileName = 'ResultatSemaine.pdf';
        Apexpages.currentPage()
            .getHeaders()
            .put('content-disposition', 'inline; filename=' + fileName);
    }
    public void setTicketRevenue() {
        ticketRevenue = 0;
        for (Seance__c seance : seanceList) {
            ticketRevenue += seance.Revenu__c;
        }
    }
    public Decimal getTicketRevenue(){
        return ticketRevenue;
    }
    public void setGainRevenue(){
        gainRevenue = 0;
        for (Charge_unique__c chargeUni : chargeUniList) {
            if (chargeUni.Gain_ou_depense__c == 'Gain') {
                gainrevenue += chargeUni.Montant__c;
            }
        }
    }
    public Decimal getGainRevenue() {
        return gainRevenue;
    }

    public void setArtistCost(){
        artistCost = 0;
        for (Contact contact : contactList) {
            artistCost += contact.Salaire_journalier_fixe__c ;
            for (Seance__c seance : seanceList) {
                if (seance.Representation__r.Artiste__c == contact.Id) {
                    artistCost += seance.Revenu__c * (contact.Prime__c / 100);
                }
            }
        }
    }

    public Decimal getArtistCost() {
        return artistCost;
    }

    public List<Charge_recurrente__c> getChargeRecDepenseList() {
        List<Charge_recurrente__c> chargeRecDepenseList = new List<Charge_recurrente__c>();
        for (Charge_recurrente__c chargeRec : chargeRecList) {
            if (chargeRec.Gain_ou_depense__c == 'Dépense') {
                chargeRecDepenseList.add(chargeRec);
            }
        }
        return chargeRecDepenseList;
    }
    public List<Charge_recurrente__c> getChargeRecGainList() {
        List<Charge_recurrente__c> chargeRecGainList = new List<Charge_recurrente__c>();
        for (Charge_recurrente__c chargeRec : chargeRecList) {
            if (chargeRec.Gain_ou_depense__c == 'Gain') {
                chargeRecGainList.add(chargeRec);
            }
        }
        return chargeRecGainList;
    }
    public Date getToday() {
        return today;
    }

    public void setSeanceCost() {
        seanceCost = 0;
        for (Seance__c seance : seanceList) {
            seanceCost += seance.Cout__c;
        }
    }
    public Decimal getSeanceCost() {
        return seanceCost;
    }

    public void setChargeCost() {
        chargeCost = 0;
        for (Charge_unique__c chargeUni : chargeUniList) {
            if (chargeUni.Gain_ou_depense__c == 'Dépense') {
                chargeCost += chargeUni.Montant__c;
            }
        }
    }
    public Decimal getChargeCost() {
        return chargeCost;
    }
    
    public void setTotalProduits() {
        totalProduits = ticketRevenue + gainRevenue;
        for (Charge_recurrente__c chargeRec : chargeRecList) {
            if (chargeRec.Gain_ou_depense__c == 'Gain')
                totalProduits += chargeRec.Cout_journalier__c ;
        }
    }
    public Decimal getTotalProduits() {
        return totalProduits;
    }

    public void setTotalCharges(){
        totalCharges = artistCost + seanceCost + chargeCost;
        for (Charge_recurrente__c chargeRec : chargeRecList) {
            if (chargeRec.Gain_ou_depense__c == 'Dépense')
                totalCharges += chargeRec.Cout_journalier__c ;
        }
    }
    public Decimal getTotalCharges() {
        return totalCharges;
    }
    public void setResultat(){
        resultat = totalProduits - totalCharges;
    }
    public Decimal getResultatTotal() {
        return resultat;
    }
}