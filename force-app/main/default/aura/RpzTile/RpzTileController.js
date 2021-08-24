({
    navigate : function(component, event, helper) {
        var sobjectId = component.get("v.representation").Id;
        console.log(sobjectId);
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": '/representation/'+sobjectId,
                "isredirect" :false
            });
            urlEvent.fire();
        
      }
})
