/**
 * @description       : 
 * @aauthor           : Jorge Luiz (jorge.luiz@nfsmw.com)
 * @group             : 
 * @last modified on  : 05-07-2026
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class CPFHubController {

    @AuraEnabled(cacheable=false)
    public static CPFHubResponse buscarCPF(String cpf) {
        
        return CPFHubService.consultarCPF(cpf);
    }
}