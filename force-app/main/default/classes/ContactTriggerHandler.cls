/**
 * @description       : 
 * @aauthor           : Jorge Luiz (jorge.luiz@nfsmw.com)
 * @group             : 
 * @last modified on  : 04-04-2026
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class ContactTriggerHandler {
    public static void validateEmailContacts(List<Contact> contactsList) {
        Set<String> emailSet = new Set<String>();
        
        for(Contact con : contactsList){
            if(con.Email != null || String.isNotBlank(con.Email)){
                emailSet.add(con.Email.toLowerCase());
            }
        }

        Map<String, Contact> existingContacts = new Map<String, Contact>();
        
        for(Contact con : [SELECT Id, Email FROM Contact WHERE Email IN :emailSet]){
            existingContacts.put(con.Email.toLowerCase(), con);
        }

        for(Contact con : contactsList){
            if(con.Email != null){
                String emailKey = con.Email.toLowerCase();
                if(existingContacts.containsKey(emailKey) && existingContacts.get(emailKey).Id != con.Id){
                    con.addError('Já existe um contato com este email: ' + con.Email);
                }
            }
        }               
    }

    public static void updateAccountsContactCount(List<Contact> contactsList, List<Contact> oldContacts) {
        Set<Id> accountIds = new Set<Id>();
    
        for(Contact con : contactsList){
            if(con.AccountId != null){
                accountIds.add(con.AccountId);    
            }
        }
    
        if(oldContacts != null){
            for(Contact con : oldContacts){
                if(con.AccountId != null){
                    accountIds.add(con.AccountId);    
                }
            }
        }
    
        if (accountIds.isEmpty()) return;
    
        Map<Id, Integer> contactCountByAccount = new Map<Id, Integer>();
        for(AggregateResult ar : [SELECT AccountId, COUNT(Id) contactCount FROM Contact WHERE AccountId IN :accountIds GROUP BY AccountId]){
            contactCountByAccount.put((Id)ar.get('AccountId'), (Integer)ar.get('contactCount'));
        }
    
        List<Account> accountsToUpdate = new List<Account>();
        for(Id accId : accountIds){
            Integer count = contactCountByAccount.containsKey(accId) ? contactCountByAccount.get(accId) : 0;
            accountsToUpdate.add(new Account(
                Id = accId,
                QuantidadeContatos__c = count
            ));
        }
    
        if(!accountsToUpdate.isEmpty()){
            update accountsToUpdate;
        }
    }    
}