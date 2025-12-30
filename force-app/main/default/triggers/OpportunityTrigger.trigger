trigger OpportunityTrigger on Opportunity (before update, before delete) {
    if(Trigger.isUpdate) OpportunityTriggerHandler.beforeUpdate(Trigger.New);
    if(Trigger.isDelete) OpportunityTriggerHandler.beforeDelete(Trigger.Old);
}