({
    doInit : function (component, event, helper) {
        console.log("in actionhandler");
        var action = component.get("c.regenTicketsApex");
        action.setParams({
            seanceId: component.get("v.recordId")
        });
        console.log("after set params");
        action.setCallback(this, function (response) {
            console.log("in callback");
            console.log("response: " + response);
            var state = response.getState();
            if (state === "SUCCESS") {
                $A.get("e.force:closeQuickAction").fire();
                $A.get("e.force:refreshView").fire();
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    helper.handleErrors(errors);
                }
            }
        });
        $A.enqueueAction(action);
    }
});