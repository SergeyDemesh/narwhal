public with sharing class RelatedAccountInfoController {
    public Id currentContactId {get; set;}

    public Contact getRelatedAccount () {
       return [
                SELECT Account.Name, Account.AccountNumber, Account.Phone, Account.BillingStreet, Account.BillingCity, Account.BillingCountry, Account.Type
                FROM Contact
                WHERE Id = :currentContactId
        ];

    }

}