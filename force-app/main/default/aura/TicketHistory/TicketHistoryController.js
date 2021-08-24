({
    doInit: function (component, event, helper) {
        var sPageURL = decodeURIComponent(window.location.search.substring(1)); //You get the whole decoded URL of the page.
        var sURLVariables = sPageURL.split("&"); //Split by & so that you get the key value pairs separately in a list
        var sParameterName;
        var i;

        for (i = 0; i < sURLVariables.length; i++) {
            sParameterName = sURLVariables[i].split("="); //to split the key from the value.
            if (sParameterName[0] === "seanceId") {
                sParameterName[1] === undefined
                    ? "Not found"
                    : sParameterName[1];
                component.set("v.seanceId", sParameterName[1]);
            }
            if (sParameterName[0] === "seanceType") {
                sParameterName[1] === undefined
                    ? "Not found"
                    : sParameterName[1];
                component.set("v.seanceType", sParameterName[1]);
            }
        }
        let action = component.get("c.getTicketsFromSeance");
        action.setParams({
            seanceId: component.get("v.seanceId")
        });
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state == "SUCCESS") {
                component.set("v.tickets", response.getReturnValue());
                console.log(response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },

    selectAll: function (component, event, helper) {
        var selectedHeaderCheck = event.getSource().get("v.value");
        var getAllId = component.find("boxPack");
        if (!Array.isArray(getAllId)) {
            if (selectedHeaderCheck == true) {
                component.find("boxPack").set("v.value", true);
                component.set("v.isButtonActive", false);
            } else {
                component.find("boxPack").set("v.value", false);
                component.set("v.isButtonActive", true);
            }
        } else {
            if (selectedHeaderCheck == true) {
                for (var i = 0; i < getAllId.length; i++) {
                    component.find("boxPack")[i].set("v.value", true);
                }
                component.set("v.isButtonActive", false);
            } else {
                for (var i = 0; i < getAllId.length; i++) {
                    component.find("boxPack")[i].set("v.value", false);
                }
                component.set("v.isButtonActive", true);
            }
        }
    },
    cancelTickets: function (component, event, helper) {
        var cancelId = [];
        var getAllId = component.find("boxPack");

        if (!Array.isArray(getAllId)) {
            if (getAllId.get("v.value") == true) {
                cancelId.push(getAllId.get("v.text"));
            }
        } else {
            for (var i = 0; i < getAllId.length; i++) {
                if (getAllId[i].get("v.value") == true) {
                    cancelId.push(getAllId[i].get("v.text"));
                }
            }
        }
        console.log("in cancel 1");
        var action = component.get("c.cancelRecords");
        action.setParams({
            ticketIdList: cancelId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(state);
                $A.get("e.force:refreshView").fire();
            }
        });
        $A.enqueueAction(action);
    },
    onChange: function (component, event, helper) {
        var cancelId = [];
        var getAllId = component.find("boxPack");

        if (!Array.isArray(getAllId)) {
            if (getAllId.get("v.value") == true) {
                cancelId.push(getAllId.get("v.text"));
            }
        } else {
            for (var i = 0; i < getAllId.length; i++) {
                if (getAllId[i].get("v.value") == true) {
                    cancelId.push(getAllId[i].get("v.text"));
                }
            }
        }
        if (cancelId.length != 0) {
            component.set("v.isButtonActive", false);
        } else {
            component.set("v.isButtonActive", true);
        }
    }
});
