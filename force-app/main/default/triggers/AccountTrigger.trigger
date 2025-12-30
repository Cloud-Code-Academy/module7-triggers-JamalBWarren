trigger AccountTrigger on Account (before insert, after insert) {

    if(Trigger.isBefore){
        AccountTriggerHandler.beforeInsert(Trigger.New);
    }

    if(Trigger.isAfter){
        AccountTriggerHandler.afterInsert(Trigger.New);
    }

}