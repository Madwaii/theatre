trigger TicketTrigger on Ticket__c(
    before insert,
    before update,
    before delete,
    after insert,
    after update,
    after delete,
    after undelete
) {
    if (Trigger.isAfter && Trigger.isUpdate) {
        TicketTriggerHandler.afterUpdate(Trigger.New, Trigger.oldMap);
    }
}
