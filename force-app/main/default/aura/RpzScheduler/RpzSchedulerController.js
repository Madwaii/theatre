({
    doInit: function (component, event, helper) {
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        component.set("v.selectedDate", today);
        let action = component.get("c.getSeances");
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state == "SUCCESS") {
                component.set("v.allSeances", response.getReturnValue());
                console.log(response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },

    load: function (component, event, helper) {
        console.log("in the load");
        var seances = component.get("v.allSeances");
        var today = component.get("v.selectedDate");
        var A10hfound = false;
        var A14hfound = false;
        var A17hfound = false;
        var A20hfound = false;
        var B10hfound = false;
        var B14hfound = false;
        var B17hfound = false;
        var B20hfound = false;
        var C10hfound = false;
        var C14hfound = false;
        var C17hfound = false;
        var C20hfound = false;
        var D10hfound = false;
        var D14hfound = false;
        var D17hfound = false;
        var D20hfound = false;
        var E10hfound = false;
        var E14hfound = false;
        var E17hfound = false;
        var E20hfound = false;
        for (const seance of seances) {
            if (seance.Jour__c == today) {
                console.log("in selected date !");
                console.log(seance.Salle__r.Name);
                if (seance.Salle__r.Name == "Salle A") {
                    if (seance.Heure__c == "10h") {
                        A10hfound = true;
                        component.set(
                            "v.A10hSeance",
                            seance.Representation__r.Name
                        );
                    }

                    if (seance.Heure__c == "14h") {
                        A14hfound = true;
                        component.set(
                            "v.A14hSeance",
                            seance.Representation__r.Name
                        );
                    }

                    if (seance.Heure__c == "17h") {
                        A17hfound = true;
                        component.set(
                            "v.A17hSeance",
                            seance.Representation__r.Name
                        );
                    }

                    if (seance.Heure__c == "20h") {
                        A20hfound = true;
                        component.set(
                            "v.A20hSeance",
                            seance.Representation__r.Name
                        );
                    }
                }
                if (seance.Salle__r.Name == "Salle B") {
                    if (seance.Heure__c == "10h") {
                        B10hfound = true;
                        component.set(
                            "v.B10hSeance",
                            seance.Representation__r.Name
                        );
                    }

                    if (seance.Heure__c == "14h") {
                        B14hfound = true;
                        component.set(
                            "v.B14hSeance",
                            seance.Representation__r.Name
                        );
                    }

                    if (seance.Heure__c == "17h") {
                        B17hfound = true;
                        component.set(
                            "v.B17hSeance",
                            seance.Representation__r.Name
                        );
                    }

                    if (seance.Heure__c == "20h") {
                        B20hfound = true;
                        component.set(
                            "v.B20hSeance",
                            seance.Representation__r.Name
                        );
                    }
                }
                if (seance.Salle__r.Name == "Salle C") {
                    if (seance.Heure__c == "10h") {
                        C10hfound = true;
                        component.set(
                            "v.C10hSeance",
                            seance.Representation__r.Name
                        );
                    }

                    if (seance.Heure__c == "14h") {
                        C14hfound = true;
                        component.set(
                            "v.C14hSeance",
                            seance.Representation__r.Name
                        );
                    }

                    if (seance.Heure__c == "17h") {
                        C17hfound = true;
                        component.set(
                            "v.C17hSeance",
                            seance.Representation__r.Name
                        );
                    }

                    if (seance.Heure__c == "20h") {
                        C20hfound = true;
                        component.set(
                            "v.C20hSeance",
                            seance.Representation__r.Name
                        );
                    }
                }
                if (seance.Salle__r.Name == "Salle D") {
                    if (seance.Heure__c == "10h") {
                        D10hfound = true;
                        component.set(
                            "v.D10hSeance",
                            seance.Representation__r.Name
                        );
                    }

                    if (seance.Heure__c == "14h") {
                        D14hfound = true;
                        component.set(
                            "v.D14hSeance",
                            seance.Representation__r.Name
                        );
                    }

                    if (seance.Heure__c == "17h") {
                        D17hfound = true;
                        component.set(
                            "v.D17hSeance",
                            seance.Representation__r.Name
                        );
                    }

                    if (seance.Heure__c == "20h") {
                        D20hfound = true;
                        component.set(
                            "v.D20hSeance",
                            seance.Representation__r.Name
                        );
                    }
                }
                if (seance.Salle__r.Name == "Salle E") {
                    if (seance.Heure__c == "10h") {
                        E10hfound = true;
                        component.set(
                            "v.E10hSeance",
                            seance.Representation__r.Name
                        );
                    }

                    if (seance.Heure__c == "14h") {
                        E14hfound = true;
                        component.set(
                            "v.E14hSeance",
                            seance.Representation__r.Name
                        );
                    }

                    if (seance.Heure__c == "17h") {
                        E17hfound = true;
                        component.set(
                            "v.E17hSeance",
                            seance.Representation__r.Name
                        );
                    }

                    if (seance.Heure__c == "20h") {
                        E20hfound = true;
                        component.set(
                            "v.E20hSeance",
                            seance.Representation__r.Name
                        );
                    }
                }
            }
        }
        console.log("E10hfound=" + E10hfound);
        if (!A10hfound) {
            component.set("v.A10hSeance", "Vide");
        }
        if (!A14hfound) {
            component.set("v.A14hSeance", "Vide");
        }
        if (!A17hfound) {
            component.set("v.A17hSeance", "Vide");
        }
        if (!A20hfound) {
            component.set("v.A20hSeance", "Vide");
        }
        if (!B10hfound) {
            component.set("v.B10hSeance", "Vide");
        }
        if (!B14hfound) {
            component.set("v.B14hSeance", "Vide");
        }
        if (!B17hfound) {
            component.set("v.B17hSeance", "Vide");
        }
        if (!B20hfound) {
            component.set("v.B20hSeance", "Vide");
        }
        if (!C10hfound) {
            component.set("v.C10hSeance", "Vide");
        }
        if (!C14hfound) {
            component.set("v.C14hSeance", "Vide");
        }
        if (!C17hfound) {
            component.set("v.C17hSeance", "Vide");
        }
        if (!C20hfound) {
            component.set("v.C20hSeance", "Vide");
        }
        if (!D10hfound) {
            component.set("v.D10hSeance", "Vide");
        }
        if (!D14hfound) {
            component.set("v.D14hSeance", "Vide");
        }
        if (!D17hfound) {
            component.set("v.D17hSeance", "Vide");
        }
        if (!D20hfound) {
            component.set("v.D20hSeance", "Vide");
        }
        if (!E10hfound) {
            component.set("v.E10hSeance", "Vide");
        }
        if (!E14hfound) {
            component.set("v.E14hSeance", "Vide");
        }
        if (!E17hfound) {
            component.set("v.E17hSeance", "Vide");
        }
        if (!E20hfound) {
            component.set("v.E20hSeance", "Vide");
        }
    },

    onSelected: function (component, event, helper) {
        var cmpId = event.currentTarget.id;
        var cmpValue = component.get("v." + cmpId);
        if (cmpValue == "Vide") {
            var rpzName = component.get("v.simpleRecord.Name");
            component.set("v." + cmpId, rpzName);
            var selectedSeances = component.get("v.selectedSeances");
            selectedSeances.push((component.get("v.selectedDate")+" "+cmpId).replace('Seance',''));
            component.set("v.selectedSeances", selectedSeances);
        }
    }
});
