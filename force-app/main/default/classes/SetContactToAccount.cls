public with sharing class SetContactToAccount implements Database.Batchable<SObject>, Database.Stateful{
    public List<Contact> contacts;

    public Database.QueryLocator start(Database.BatchableContext bc) {
        Database.QueryLocator accounts = Database.getQueryLocator('SELECT Id, triplk__ContactsLimit__c, (SELECT Id FROM Contacts), (SELECT triplk__Contact_Assignment_Rule__r.triplk__Field_API_Name__c, triplk__Contact_Assignment_Rule__r.triplk__Operator__c,\n' +
                'triplk__Contact_Assignment_Rule__r.triplk__Field_Value__c FROM triplk__JunctionContactARAccounts__r)\n' +
                'FROM Account'
        );
        List<String> fields = new List<String>();
        Database.QueryLocatorIterator iterator = accounts.iterator();
        while (iterator.hasNext()) {
            Account account = (Account)iterator.next();
            if(account.triplk__JunctionContactARAccounts__r.size() != 0) {
                for (triplk__JunctionContactARAccount__c rulesItem: account.triplk__JunctionContactARAccounts__r) {
                    fields.add(rulesItem.triplk__Contact_Assignment_Rule__r.triplk__Field_API_Name__c);
                }
            }
        }
        String fieldsToQuery = fields.toString().replaceAll('[()]+', '');
        contacts = Database.query('SELECT AccountId, ' + fieldsToQuery + ' FROM Contact');
        return accounts;
    }
    public void execute(Database.BatchableContext bc, List<Account> accounts){
        List<Contact> updatedContacts = new List<Contact>(contacts);
        for (Account accountItem: accounts) {

            if (accountItem.triplk__ContactsLimit__c == null) {
                accountItem.triplk__ContactsLimit__c = 5;
            }
            for (Contact contactItem: updatedContacts) {
                Boolean ok = false;
                Map<String, Object> popFields = contactItem.getPopulatedFieldsAsMap();
                for (triplk__JunctionContactARAccount__c ruleItem : accountItem.triplk__JunctionContactARAccounts__r) {
                    switch on ruleItem.triplk__Contact_Assignment_Rule__r.triplk__Operator__c {
                        when '>' {
                            if ((popFields.get(ruleItem.triplk__Contact_Assignment_Rule__r.triplk__Field_API_Name__c)?.toString() > ruleItem.triplk__Contact_Assignment_Rule__r.triplk__Field_Value__c)
                                    && (accountItem.Contacts.size() < accountItem.triplk__ContactsLimit__c)) {
                                contactItem.AccountId = accountItem.Id;
                            } else {
                                ok = true;
                            }
                            break;
                        }
                        when '>=' {
                            if ((popFields.get(ruleItem.triplk__Contact_Assignment_Rule__r.triplk__Field_API_Name__c)?.toString() >= ruleItem.triplk__Contact_Assignment_Rule__r.triplk__Field_Value__c)
                                    && (accountItem.Contacts.size() < accountItem.triplk__ContactsLimit__c)) {
                                contactItem.AccountId = accountItem.Id;
                            } else {
                                ok = true;
                            }
                            break;
                        }
                        when '<' {
                            if ((popFields.get(ruleItem.triplk__Contact_Assignment_Rule__r.triplk__Field_API_Name__c)?.toString() < ruleItem.triplk__Contact_Assignment_Rule__r.triplk__Field_Value__c)
                                    && (accountItem.Contacts.size() < accountItem.triplk__ContactsLimit__c)) {
                                contactItem.AccountId = accountItem.Id;
                            } else {
                                ok = true;
                            }
                            break;
                        }
                        when '<=' {
                            if ((popFields.get(ruleItem.triplk__Contact_Assignment_Rule__r.triplk__Field_API_Name__c)?.toString() <= ruleItem.triplk__Contact_Assignment_Rule__r.triplk__Field_Value__c)
                                    && (accountItem.Contacts.size() < accountItem.triplk__ContactsLimit__c)) {
                                contactItem.AccountId = accountItem.Id;
                            } else {
                                ok = true;
                            }
                            break;
                        }
                        when '=' {
                            if ((popFields.get(ruleItem.triplk__Contact_Assignment_Rule__r.triplk__Field_API_Name__c)?.toString() == ruleItem.triplk__Contact_Assignment_Rule__r.triplk__Field_Value__c)
                                    && (accountItem.Contacts.size() < accountItem.triplk__ContactsLimit__c)) {
                                contactItem.AccountId = accountItem.Id;
                            } else {
                                ok = true;
                            }
                            break;
                        }
                        when '!=' {
                            if ((popFields.get(ruleItem.triplk__Contact_Assignment_Rule__r.triplk__Field_API_Name__c)?.toString() != ruleItem.triplk__Contact_Assignment_Rule__r.triplk__Field_Value__c)
                                    && (accountItem.Contacts.size() < accountItem.triplk__ContactsLimit__c)) {
                                contactItem.AccountId = accountItem.Id;
                            } else {
                                ok = true;
                            }
                            break;
                        }
                    }
                }
                if (ok) {
                    contactItem.AccountId = null;
                }
            }
        }
        update updatedContacts;
    }
    public void finish(Database.BatchableContext bc){

    }

}