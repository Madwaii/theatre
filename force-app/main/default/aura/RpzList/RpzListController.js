({
    doInit: function (component, event, helper) {
        let action = component.get("c.getUpcomingRpz");
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state == "SUCCESS") {
                component.set("v.representations", response.getReturnValue());
                console.log(response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }
})
