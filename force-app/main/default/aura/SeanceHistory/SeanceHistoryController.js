({
    doInit: function (component, event, helper) {
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        component.set('v.todayDate', today);
        var inOneWeek = new Date();
        inOneWeek.setDate(inOneWeek.getDate()+7);
        inOneWeek = $A.localizationService.formatDate(inOneWeek, "YYYY-MM-DD");
        component.set("v.inOneWeekDate", inOneWeek);
        let action = component.get("c.getSeances");
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state == "SUCCESS") {
                component.set("v.seances", response.getReturnValue());
                console.log(response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
});
