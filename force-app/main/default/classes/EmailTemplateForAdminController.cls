public with sharing class EmailTemplateForAdminController {
    List<Contact> newContacts = new List<Contact>();
    List<Account> newAccounts = new List<Account>();
    List<Case> newCases = new List<Case>();

    public EmailTemplateForAdminController() {
        newContacts = [
                SELECT Id, Name
                FROM Contact
                WHERE CreatedDate = TODAY
        ];
        newAccounts = [
                SELECT Id, Name
                FROM Account
                WHERE CreatedDate = TODAY
        ];
        newCases = [
                SELECT Id, CaseNumber, ContactId, AccountId
                FROM Case
                WHERE CreatedDate = TODAY
        ];
    }

    public List<Contact> getNewContacts() {
        return newContacts;
    }

    public List<Account> getNewAccounts() {
        return newAccounts;
    }

    public List<Case> getNewCases() {
        return newCases;
    }

}