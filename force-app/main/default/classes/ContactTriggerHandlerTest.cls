/**
 * @description       : 
 * @author            : Jorge Luiz (jorge.luiz@nfsmw.com)
 * @group             : 
 * @last modified on  : 11-16-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public with sharing class ContactTriggerHandlerTest {
    @testSetup
    static void makeData() {
        // Criando conta para associar aos contatos
        Account acc = new Account(Name = 'Conta Teste', CNPJ__c = '57.403.157/0001-85');
        insert acc;

        // Criando contato existente para validar duplicação de e-mail
        Contact existingContact = new Contact(
            FirstName = 'João',
            LastName = 'Silva',
            Email = 'teste@exemplo.com',
            AccountId = acc.Id
        );
        insert existingContact;
    }

    @isTest
    static void testValidateContacts_noDuplicateEmail() {
        // Criar contato com email único
        Contact con = new Contact(
            FirstName = 'Maria',
            LastName = 'Souza',
            Email = 'novo@exemplo.com'
        );

        Test.startTest();
        try {
            ContactTriggerHandler.validateEmailContacts(new List<Contact>{con});
        } catch (Exception e) {
            System.assert(false, 'Não deveria lançar erro para e-mail único');
        }
        Test.stopTest();
    }

    @isTest
    public static void testValidateContacts_duplicateEmail() {
        // Recupera conta criada no testSetup
        Account acc = [SELECT Id FROM Account WHERE Name = 'Conta Teste' LIMIT 1];

        // Tentando inserir um contato com e-mail já existente
        Contact con = new Contact(
            FirstName = 'José',
            LastName = 'Almeida',
            Email = 'teste@exemplo.com', // Já existe no testSetup
            AccountId = acc.Id
        );

        Test.startTest();
        try {
            insert con;
            System.assert(false, 'Deveria ter gerado erro de e-mail duplicado');
        } catch (DmlException e) {
            System.assert(e.getDmlMessage(0).contains('Já existe um contato com este email'), 'Mensagem de erro esperada não encontrada');
        }
        Test.stopTest();
    }


    @isTest
    static void testUpdateAccountsContactCount() {
        // Recupera conta criada no testSetup
        Account acc = [SELECT Id FROM Account WHERE Name = 'Conta Teste' LIMIT 1];

        // Criar mais dois contatos associados à conta
        List<Contact> newContacts = new List<Contact>{
            new Contact(FirstName = 'Contato1', LastName = 'Teste', Email = 'c1@exemplo.com', AccountId = acc.Id),
            new Contact(FirstName = 'Contato2', LastName = 'Teste', Email = 'c2@exemplo.com', AccountId = acc.Id)
        };
        insert newContacts;

        // Simula mudança nos contatos (por exemplo, em update trigger)
        List<Contact> updatedList = [SELECT Id, AccountId FROM Contact WHERE Id IN :newContacts];
        List<Contact> oldList = updatedList.deepClone();

        Test.startTest();
        ContactTriggerHandler.updateAccountsContactCount(updatedList, oldList);
        Test.stopTest();

        Account accUpdated = [SELECT Id, QuantidadeContatos__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(3, accUpdated.QuantidadeContatos__c, 'A quantidade de contatos da conta deve ser 3');
    }
}