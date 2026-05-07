/**
 * @description       : 
 * @aauthor           : Jorge Luiz (jorge.luiz@nfsmw.com)
 * @group             : 
 * @last modified on  : 05-06-2026
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class CepServiceController {
    @AuraEnabled
    public static ViaCepResponseWrapper consultaCep(String cepDigitado) {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://viacep.com.br/ws/' + cepDigitado + '/json/');
        req.setMethod('GET');
        
        HttpResponse res = http.send(req);
        if(res.getStatusCode() == 200){
            System.debug('Retorno ViaCEP: ' + res.getBody());
            ViaCepResponseWrapper endereco = (ViaCepResponseWrapper) JSON.deserialize(res.getBody(), ViaCepResponseWrapper.class);
            System.debug('Endereço Wrapper: ' + endereco);
            
            if(endereco.erro == true){
                throw new AuraHandledException('CEP não encontrado.');
            }
            
            return endereco;
        }else{
            throw new AuraHandledException('Erro na consulta ao ViaCEP. Código: ' + res.getStatusCode());
        }
    }

    @AuraEnabled
    public static void atualizarEnderecoConta(Id contaId, String enderecoJson) {
        try{
            
        ViaCepResponseWrapper endereco = (ViaCepResponseWrapper) JSON.deserialize(enderecoJson, ViaCepResponseWrapper.class);

        Account acc = [SELECT Id, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry FROM Account WHERE Id = :contaId LIMIT 1];
        acc.BillingStreet = endereco.logradouro;
        acc.BillingCity = endereco.localidade;
        acc.BillingState = endereco.estado;
        acc.BillingPostalCode = endereco.cep;
        acc.BillingCountry = 'Brazil';
        update acc;

        }catch(Exception e){
            System.debug(e.getMessage());
        }
        
    }

}