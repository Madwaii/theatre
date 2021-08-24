({
    doInit : function(component, event, helper) {
        let action = component.get("c.getZones");
        action.setParams({
            seanceId: component.get("v.SeanceId")
        });
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state == "SUCCESS") {
                component.set("v.zones", response.getReturnValue());
                console.log(response.getReturnValue());
                var zoneList = component.get("v.zones");
                for (const zone of zoneList) {
                    if (zone.Name=="Arrière"){
                        component.set("v.ArriereId", zone.Id);
                    }
                    if (zone.Name=="Côtés"){
                        component.set("v.CotesId", zone.Id);
                    }
                    if (zone.Name=="Etage"){
                        component.set("v.EtageId", zone.Id);
                    }
                    if (zone.Name=="Milieu"){
                        component.set("v.MilieuId", zone.Id);
                    }
                    if (zone.Name=="Premier Rang"){
                        component.set("v.PremierRangId", zone.Id);
                    }
                }
                
            }
        });
        $A.enqueueAction(action);
    },
    onSelected : function(component, event, helper) {
        console.log('in onSelected');
        var cmpId = event.currentTarget.id;
        console.log('got source :'+cmpId);
        component.set("v.ZoneId", cmpId);
        console.log('set zoneId to'+component.get("v.ZoneId"));
    }
})
