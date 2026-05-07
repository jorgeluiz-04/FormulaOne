/**
 * @description       : 
 * @aauthor           : Jorge Luiz (jorge.luiz@nfsmw.com)
 * @group             : 
 * @last modified on  : 04-04-2026
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger ContactTrigger on Contact (before insert, before update, after insert, after update) {
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            ContactTriggerHandler.validateEmailContacts(Trigger.new);
        }
        if(Trigger.isUpdate){
            ContactTriggerHandler.validateEmailContacts(Trigger.new);
        }
    }

    if(Trigger.isAfter){
        if(Trigger.isInsert){
            ContactTriggerHandler.updateAccountsContactCount(Trigger.new, null);
        }
        if(Trigger.isUpdate){
            ContactTriggerHandler.updateAccountsContactCount(Trigger.new, Trigger.old);
        }
    }
}