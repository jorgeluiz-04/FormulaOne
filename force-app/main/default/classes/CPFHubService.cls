/**
 * @description       : 
 * @aauthor           : Jorge Luiz (jorge.luiz@nfsmw.com)
 * @group             : 
 * @last modified on  : 05-12-2026
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class CPFHubService {

    public static CPFHubResponse checkCPF(String cpf) {

        cpf = cpf.replaceAll('[^0-9]', '');
        System.debug('Consultando CPF: ' + maskingCPF(cpf));

        HttpRequest req = new HttpRequest();

        req.setEndpoint('callout:CPFHub/cpf/' + cpf);
        req.setMethod('GET');
        req.setHeader('Accept', 'application/json');
        req.setTimeout(20000);

        Http http = new Http();

        HttpResponse res;

        try {
            res = http.send(req);
        } catch(Exception ex) {
            throw new AuraHandledException('Erro de comunicação com a API CPFHub: ' + ex.getMessage());
        }

        CPFHubResponse response;

        try {
            response = (CPFHubResponse) JSON.deserialize(res.getBody(), CPFHubResponse.class);
        } catch(Exception ex) {
            throw new AuraHandledException('Erro ao interpretar resposta da API.');
        }

        System.debug('Status Code: ' + res.getStatusCode());
        
        // Tratamento de erro funcional OU HTTP
        if(res.getStatusCode() != 200 || response == null || response.success == false) {
            String mensagemErro = 'Erro ao consultar CPF.';

            if(response != null && response.error != null && !String.isBlank(response.error.message)) {
                mensagemErro = response.error.message;
            }

            throw new AuraHandledException(mensagemErro + ' - CPF: ' + maskingCPF(cpf));
        }

        return response;
    }

    private static String maskingCPF(String cpf) {

        if(String.isBlank(cpf)) {
            return '';
        }

        cpf = cpf.replaceAll('[^0-9]', '');

        if(cpf.length() != 11) {
            return 'CPF inválido';
        }

        return cpf.substring(0, 3) + '.***.***-' + cpf.substring(9, 11);
    }
}