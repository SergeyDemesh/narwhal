public with sharing class CheckContactForBatch implements Database.Batchable<SObject>, Database.Stateful{
    public String fieldsToQuery;
    public Integer batchSize;
    public Set<String> fields = new Set<String>();

    public Database.QueryLocator start(Database.BatchableContext bc) {
        Database.QueryLocator accounts = Database.getQueryLocator(
                'SELECT Name, triplk__ContactsLimit__c, ' +
                        '(SELECT Id ' +
                        'FROM Contacts),' +
                        '(SELECT triplk__Contact_Assignment_Rule__r.triplk__Field_API_Name__c, triplk__Contact_Assignment_Rule__r.triplk__Operator__c, triplk__Contact_Assignment_Rule__r.triplk__Field_Value__c ' +
                        'FROM triplk__JunctionContactARAccounts__r)' +
                'FROM Account'
        );

        return accounts;
    }
    public void execute(Database.BatchableContext bc, List<Account> accounts) {
        Set<Contact> contactsForUpdate = new Set<Contact>();
        Map<String, SObjectField> fieldsTypeMap = Schema.getGlobalDescribe().get('Contact').getDescribe().fields.getMap();
        Set<Id> accountIds = new Map<Id, Account>(accounts).keySet();
        Map<Id, Integer> countOfContactsByAccId = new Map<Id, Integer>();
        Map<Id, List<triplk__JunctionContactARAccount__c>> rulesByAccId = new Map<Id, List<triplk__JunctionContactARAccount__c>>();

        for (Account accountItem: accounts) {
            if (accountItem.triplk__ContactsLimit__c == null) {
                accountItem.triplk__ContactsLimit__c = 5;
            }

            if (accountItem.triplk__JunctionContactARAccounts__r.size() == 0) {
                continue;
            }
            countOfContactsByAccId.put(accountItem.Id, accountItem.Contacts.size());
            rulesByAccId.put(accountItem.Id, accountItem.triplk__JunctionContactARAccounts__r);

            for (triplk__JunctionContactARAccount__c rulesItem : accountItem.triplk__JunctionContactARAccounts__r) {
                fields.add(rulesItem.triplk__Contact_Assignment_Rule__r.triplk__Field_API_Name__c);
            }
        }
        fieldsToQuery = String.join(new List<String>(fields), ', ');
        List<Contact> contacts =  Database.query('SELECT Id, AccountId, ' + fieldsToQuery +
                                                ' FROM Contact' +
                                                ' WHERE AccountId IN :accountIds');

        for (Contact contactItem : contacts) {
            if (rulesByAccId.get(contactItem.AccountId) == null) {
                contactItem.AccountId = null;
                continue;
            }
            Boolean correct = true;
            for (triplk__JunctionContactARAccount__c ruleItem : rulesByAccId.get(contactItem.AccountId)) {
                if (contactItem.get(ruleItem.triplk__Contact_Assignment_Rule__r.triplk__Field_API_Name__c) == null) {
                    contactItem.AccountId = null;
                    continue;
                }
                String currentFieldValue = JSON.serialize(contactItem.get(ruleItem.triplk__Contact_Assignment_Rule__r.triplk__Field_API_Name__c));
                String expectedFieldValue = JSON.serialize(parseDataType((ruleItem.triplk__Contact_Assignment_Rule__r.triplk__Field_Value__c) , fieldsTypeMap.get(ruleItem.triplk__Contact_Assignment_Rule__r.triplk__Field_API_Name__c).getDescribe().getSoapType()));
                correct = checkContact(currentFieldValue, expectedFieldValue, ruleItem.triplk__Contact_Assignment_Rule__r.triplk__Operator__c, correct);
            }
            if (!correct) {
                countOfContactsByAccId.put(contactItem.AccountId, countOfContactsByAccId.get(contactItem.AccountId) - 1);
                contactItem.AccountId = null;
                contactsForUpdate.add(contactItem);
            }
        }

        update new List<Contact>(contactsForUpdate);
    }
    public void finish(Database.BatchableContext bc){
        Database.executeBatch(new SetContactToAccountBatch(fieldsToQuery), batchSize);
    }

    public CheckContactForBatch(Integer batchSize) {
        this.batchSize = batchSize;
    }

    @TestVisible
    private String parseDataType(String value, SoapType dataType) {

        switch on dataType {
            when DATE {
                return String.valueOf(Date.valueOf(value.substringAfterLast('/') + '-' + value.substringBetween('/', '/') + '-' + value.substringBefore('/')));
            }
            when DATETIME {
                String hours;
                if (value.substringAfterLast(' ') == 'PM') {
                    hours = value.substring(11, 13);
                } else {
                    hours = String.valueOf(Integer.valueOf(value.substring(11, 13)) + 12);
                }
                if (hours == '24') {
                    hours = '00';
                }
                return String.valueOf(Datetime.valueOf(value.substring(6, 10) + '-' + value.substring(0, 2) + '-' + value.substring(3, 5) + ' ' + hours + ':' + value.substring(14, 16) + ':00'));
            }
            when else {
                return value;
            }
        }
    }
    private Boolean checkContact(String currentFieldValue, String expectedFieldValue, String Operator, Boolean correct) {
        switch on  Operator {
            when '>' {
                if (currentFieldValue <= expectedFieldValue) {
                    correct = false;
                }
            }
            when '>=' {
                if (currentFieldValue < expectedFieldValue) {
                    correct = false;
                }
            }
            when '<' {
                if (currentFieldValue >= expectedFieldValue) {
                    correct = false;
                }
            }
            when '<=' {
                if (currentFieldValue > expectedFieldValue) {
                    correct = false;
                }
            }
            when '=' {
                if (currentFieldValue != expectedFieldValue) {
                    correct = false;
                }
            }
            when '!=' {
                if (currentFieldValue == expectedFieldValue) {
                    correct = false;
                }
            }
        }
        return correct;
    }
}