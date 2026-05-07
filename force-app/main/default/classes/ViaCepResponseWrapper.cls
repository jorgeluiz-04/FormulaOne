/**
 * @description       : 
 * @aauthor           : Jorge Luiz (jorge.luiz@nfsmw.com)
 * @group             : 
 * @last modified on  : 03-31-2026
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class ViaCepResponseWrapper {
    @AuraEnabled public String cep;
    @AuraEnabled public String logradouro;
    @AuraEnabled public String complemento;
    @AuraEnabled public String unidade;
    @AuraEnabled public String bairro;
    @AuraEnabled public String localidade;
    @AuraEnabled public String uf;
    @AuraEnabled public String estado;
    @AuraEnabled public String regiao;
    @AuraEnabled public String ibge;
    @AuraEnabled public String gia;
    @AuraEnabled public String ddd;
    @AuraEnabled public String siafi;
    @AuraEnabled public Boolean erro;

    public ViaCepResponseWrapper() {

    }
}