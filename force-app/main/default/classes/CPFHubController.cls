/**
 * @description       : 
 * @aauthor           : Jorge Luiz (jorge.luiz@nfsmw.com)
 * @group             : 
 * @last modified on  : 05-12-2026
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class CPFHubController {

    @AuraEnabled(cacheable=false)
    public static CPFHubResponse searchCPF(String cpf) {
        
        return CPFHubService.checkCPF(cpf);
    }
}