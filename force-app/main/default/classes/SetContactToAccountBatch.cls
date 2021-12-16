public with sharing class SetContactToAccountBatch implements Database.Batchable<SObject>, Database.Stateful{
    private List<Contact> contacts = new List<Contact>();
    public String fieldsToQuery;

    public Database.QueryLocator start(Database.BatchableContext bc) {
        Database.QueryLocator accounts = Database.getQueryLocator(
                'SELECT Id, triplk__ContactsLimit__c, ' +
                        '(SELECT triplk__Contact_Assignment_Rule__r.triplk__Field_API_Name__c, triplk__Contact_Assignment_Rule__r.triplk__Operator__c, triplk__Contact_Assignment_Rule__r.triplk__Field_Value__c ' +
                        'FROM triplk__JunctionContactARAccounts__r)' +
                'FROM Account'
        );
        contacts = Database.query('SELECT AccountId, ' + fieldsToQuery + ' FROM Contact');
        return accounts;
    }
    public void execute(Database.BatchableContext bc, List<Account> accounts) {
        Map<String, SObjectField> fieldsTypeMap = Schema.getGlobalDescribe().get('Contact').getDescribe().fields.getMap();

        for (Account accountItem: accounts) {
            Integer numberOfContact = accountItem.Contacts.size();
            if (accountItem.triplk__ContactsLimit__c == null) {
                accountItem.triplk__ContactsLimit__c = 5;
            }
            if (accountItem.triplk__JunctionContactARAccounts__r.size() == 0) {
                continue;
            }
            for (Contact contactItem: contacts) {
                if ((contactItem.AccountId != null) || (numberOfContact >= accountItem.triplk__ContactsLimit__c)) {
                    continue;
                }
                Boolean correct = true;
                for (triplk__JunctionContactARAccount__c ruleItem : accountItem.triplk__JunctionContactARAccounts__r) {
                    if (contactItem.get(ruleItem.triplk__Contact_Assignment_Rule__r.triplk__Field_API_Name__c) == null) {
                        correct = false;
                        continue;
                    }
                    String currentFieldValue = JSON.serialize(contactItem.get(ruleItem.triplk__Contact_Assignment_Rule__r.triplk__Field_API_Name__c));
                    String expectedFieldValue = JSON.serialize(parseDataType((ruleItem.triplk__Contact_Assignment_Rule__r.triplk__Field_Value__c) , fieldsTypeMap.get(ruleItem.triplk__Contact_Assignment_Rule__r.triplk__Field_API_Name__c).getDescribe().getSoapType()));
                    correct = checkContact(currentFieldValue, expectedFieldValue, ruleItem.triplk__Contact_Assignment_Rule__r.triplk__Operator__c, correct);

                }
                if (correct) {
                    contactItem.AccountId = accountItem.Id;
                    numberOfContact += 1;
                }
            }
        }
        update contacts;
    }
    public void finish(Database.BatchableContext bc){

    }

    public SetContactToAccountBatch(String fieldsToQuery) {
        this.fieldsToQuery = fieldsToQuery;
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
        switch on Operator {
            when '>' {
                if (!(currentFieldValue > expectedFieldValue)) {
                    correct = false;
                }
            }
            when '>=' {
                if (!(currentFieldValue >= expectedFieldValue)) {
                    correct = false;
                }
            }
            when '<' {
                if (!(currentFieldValue < expectedFieldValue)) {
                    correct = false;
                }
            }
            when '<=' {
                if (!(currentFieldValue <= expectedFieldValue)) {
                    correct = false;
                }
            }
            when '=' {
                if (!(currentFieldValue == expectedFieldValue)) {
                    correct = false;
                }
            }
            when '!=' {
                if (!(currentFieldValue != expectedFieldValue)) {
                    correct = false;
                }
            }
        }
        return correct;
    }
}