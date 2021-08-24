trigger SeanceTrigger on Seance__c(
    before insert,
    before update,
    before delete,
    after insert,
    after update,
    after delete,
    after undelete
) {
    if (Trigger.isBefore && Trigger.isInsert) {
        SeanceTriggerHandler.beforeInsert(Trigger.New);
    }
    if (Trigger.isBefore && Trigger.isUpdate) {
        SeanceTriggerHandler.beforeUpdate(Trigger.New, Trigger.oldMap);
    }
    if (Trigger.isAfter && Trigger.isInsert) {
        SeanceTriggerHandler.afterInsert(Trigger.New);
    }
    if (Trigger.isAfter && Trigger.isUpdate) {
        SeanceTriggerHandler.afterUpdate(Trigger.New, Trigger.oldMap);
    }
}