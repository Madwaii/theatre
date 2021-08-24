({
    navigate : function(component, event, helper) {
        console.log('in navigate');
        var vfURL = 'https://theatre-viserhaut-developer-edition.eu40.force.com/s/ticketsdetails' 
        + '?';
        vfURL = vfURL + 'seanceId=' + component.get("v.seance.Id") + '&';
        vfURL = vfURL + 'seanceType=' + component.get("v.seancetype");
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            url: vfURL
        });
        urlEvent.fire();
        console.log('event fired');
    }
})
