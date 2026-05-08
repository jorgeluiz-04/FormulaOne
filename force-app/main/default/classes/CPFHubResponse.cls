/**
 * @description       : 
 * @aauthor           : Jorge Luiz (jorge.luiz@nfsmw.com)
 * @group             : 
 * @last modified on  : 05-08-2026
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class CPFHubResponse {

    @AuraEnabled
    public Boolean success;

    @AuraEnabled
    public CPFData data;

    @AuraEnabled
    public CPFError error;

    public class CPFData {

        @AuraEnabled
        public String cpf;

        @AuraEnabled
        public String name;

        @AuraEnabled   
        public String nameUpper;

        @AuraEnabled
        public String gender;

        @AuraEnabled
        public String birthDate;

        @AuraEnabled
        public Integer day;

        @AuraEnabled
        public Integer month;

        @AuraEnabled
        public Integer year;
    }

    public class CPFError {

        @AuraEnabled
        public String message;
    }
}