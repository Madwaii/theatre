public with sharing class TicketService {
    public static void generateZoneTickets(List<Zone__c> zoneList) {
        if (zoneList != null && zoneList.size() != 0) {
            List<Ticket__c> newTicketList = new List<Ticket__c>();
            for (Zone__c zone : zoneList) {
                for (Integer i = 1; i <= zone.Nombre_de_places__c; i++) {
                    newTicketList.add(
                        new Ticket__c(
                            Name = System.Label.Ticket_Pour +
                                ' ' +
                                zone.Seance__r.Name,
                            Zone__c = zone.Id,
                            Seance__c = zone.Seance__c,
                            Place__c = zone.Name.substring(0, 1) +
                                String.valueOf(i),
                            Prix__c = 10
                        )
                    );
                }
            }
            insert newTicketList;
        }
    }

    public static Boolean assertTicketsWithoutBuyers(
        List<Seance__c> seanceList
    ) {
        //check if empty arguments
        if (seanceList == null || seanceList.size() == 0) {
            return true; //empty list
        }
        Boolean result = true;
        List<Ticket__c> ticketList = TicketDAO.getTicketsWithBuyer(seanceList);
        System.debug(ticketList.size());
        if (ticketList.size() != 0) {
            seanceList[0]
                .addError(
                    'Des tickets ont déjà été achetés, impossible de modifier.'
                );
            result = false;
        }
        return result;
    }

    public static void regenerateOldTickets(List<Id> seanceIdList) {
        List<Zone__c> zoneList = zoneDAO.getSeanceZoneList(seanceIdList);
        List<Ticket__c> ticketList = ticketDAO.getSeanceTicketList(
            seanceIdList
        );
        for (Zone__c zone : zoneList) {
            //on map les tickets existants de la zone pour vérifier leur place rapidement
            Map<Integer, Ticket__c> ticketMap = new Map<Integer, Ticket__c>();
            for (Ticket__c ticket : ticketList) {
                if (ticket.Zone__c == zone.Id) {
                    Integer placeNumber = Integer.valueOf(
                        ticket.Place__c.substring(1, ticket.Place__c.length())
                    );
                    System.debug(placeNumber);
                    ticketMap.put(placeNumber, ticket);
                }
            }
            //on ajoute a la liste de tickets de nouveaux tickets de la zone avec une place différente
            for (Integer i = 1; i <= zone.Nombre_de_places__c; i++) {
                if (!ticketMap.containsKey(i)) {
                    ticketList.add(
                        new Ticket__c(
                            Name = System.Label.Ticket_Pour +
                                ' ' +
                                zone.Seance__r.Name,
                            Zone__c = zone.Id,
                            Seance__c = zone.Seance__c,
                            Place__c = zone.Name.substring(0, 1) +
                                String.valueOf(i),
                            Prix__c = 10
                        )
                    );
                }
            }
        }
        upsert ticketList;
    }

    public static void sendReceipt(List<Ticket__c> boughtTicketsList) {
        if (boughtTicketsList == null || boughtTicketsList.size() == 0) {
            return; //empty list
        }
        List<Id> boughtTicketsIdList = new List<Id>();
        for (Ticket__c ticket : boughtTicketsList) {
            boughtTicketsIdList.add(ticket.Id);
        }
        boughtTicketsList = TicketDAO.getSeancesInformations(
            boughtTicketsIdList
        );
        List<Contact> buyersList = ContactDAO.getRelatedBuyers(
            boughtTicketsIdList
        );
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        for (Contact buyer : buyersList) {
            //set hasboughtonce to true
            buyer.hasBoughtOnce__c=true;
            if (buyer.Email != null && buyer.Email != '') {
                List<Messaging.EmailFileAttachment> attachList = new List<Messaging.EmailFileAttachment>();
                for (Ticket__c ticket : boughtTicketsList) {
                    if (ticket.Acheteur__c == buyer.Id) {
                        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
                        attach.setContentType('application/pdf');
                        attach.setFileName('Ticket' + ticket.Place__c + '.pdf');
                        String body;

                        body =
                            '<html><body><h1 style=\"text-align:center;\">Ticket pour ' +
                            ticket.Seance__r.Representation__r.Name +
                            '</h1><br/><br/><table align=\"center\"><tr><td><b>Place :</b></td><td>' +
                            ticket.Place__c +
                            '</td></tr><tr><th><b>Zone :</b></th><td>' +
                            ticket.Zone__r.Name +
                            '</td></tr><tr><th><b>Salle :</b></th><td>' +
                            ticket.Seance__r.Salle__r.Name +
                            '</td></tr><tr><th><b>Jour :</b></th><td>' +
                            ticket.Seance__r.Jour__c.format() +
                            '</td></tr><tr><th><b>Heure :</b></th><td>' +
                            ticket.Seance__r.Heure__c +
                            '</td></tr><tr><th><b>Prix :</b></th><th><b>' +
                            ticket.Prix__c +'€'+
                            '</b></th></tr></table></body></html>';
                        attach.Body = Blob.toPDF(body);
                        attachList.add(attach);
                    }
                }
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                Id orgMailId = [
                    SELECT id, Address, DisplayName
                    FROM OrgWideEmailAddress
                    LIMIT 1
                ]
                .Id;
                mail.setOrgWideEmailAddressId(orgMailId);
                mail.setToAddresses(new List<String>{ buyer.Email });
                mail.setSubject('Vos reçus d\'achats');
                mail.setHtmlBody(
                    'Bonjour'+((buyer.FirstName!=null)? (' '+buyer.FirstName) : '')+' '+buyer.LastName+', <br/> Voici vos reçus pour le(s) place(s) que vous avez acheté. <br/> Ces reçus feront office de tickets à l\'entrée de la représentation. <br/> Vous pouvez les imprimer ou les présenter au format numérique au guichet. <br/> Nous vous souhaitons un bon spectacle, <br/><br/>Le Théâtre Viser-Haut.'
                );
                mail.setFileAttachments(attachList);

                mails.add(mail);
            }
        }
        update buyersList;
        if (!mails.isEmpty()) {
            Messaging.SendEmail(mails);
        }
    }
}
