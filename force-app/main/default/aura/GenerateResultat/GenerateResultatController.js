({
    generate: function (component, event, helper) {
        var vfURL = 'https://viseo68-dev-ed--c.visualforce.com/apex/ResultatCustom' 
        + '?';
        vfURL = vfURL + 'startDate=' + component.get("v.selectedStartDate") + '&';
        vfURL = vfURL + 'endDate=' + component.get("v.selectedEndDate");
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            url: vfURL
        });
        urlEvent.fire();
    }
});
