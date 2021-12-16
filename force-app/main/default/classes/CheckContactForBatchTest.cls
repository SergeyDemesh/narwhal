@IsTest
public with sharing class CheckContactForBatchTest {

    @TestSetup
    public static void createData() {

        List<triplk__Contact_Assignment_Rule__c> rules = createRules();
        insert rules;
        List<Account> accounts =createAccounts();
        insert accounts;
        List<triplk__JunctionContactARAccount__c> junctions = createJunctions(accounts, rules);
        insert junctions;
        List<Contact> contacts = createContacts(accounts);
        insert contacts;
    }

    @IsTest
    public static void checkBatch() {
        Test.startTest();
        CheckContactForBatch check = new CheckContactForBatch(500);
        checkPrivateMethods(check);
        Id batchId = Database.executeBatch(check, check.batchSize);
        Test.stopTest();
        List<Contact> contacts = [
                SELECT Id
                FROM Contact
                WHERE AccountId != NULL
        ];
        System.assertEquals(contacts.size(), 65);
    }

    private static List<triplk__Contact_Assignment_Rule__c> createRules() {
        List<triplk__Contact_Assignment_Rule__c> rules = new List<triplk__Contact_Assignment_Rule__c>();
        rules.add(new triplk__Contact_Assignment_Rule__c(
                Name = 'rule 1',
                triplk__Field_API_Name__c = 'LastName',
                triplk__Operator__c = '!=',
                triplk__Field_Value__c = '1'
        ));
        rules.add(new triplk__Contact_Assignment_Rule__c(
                Name = 'rule 2',
                triplk__Field_API_Name__c = 'LastName',
                triplk__Operator__c = '=',
                triplk__Field_Value__c = '2'
        ));
        rules.add(new triplk__Contact_Assignment_Rule__c(
                Name = 'rule 3',
                triplk__Field_API_Name__c = 'Birthdate',
                triplk__Operator__c = '<',
                triplk__Field_Value__c = '01/01/1945'
        ));
        rules.add(new triplk__Contact_Assignment_Rule__c(
                Name = 'rule 4',
                triplk__Field_API_Name__c = 'Birthdate',
                triplk__Operator__c = '<=',
                triplk__Field_Value__c = '01/01/1945'
        ));
        rules.add(new triplk__Contact_Assignment_Rule__c(
                Name = 'rule 5',
                triplk__Field_API_Name__c = 'Birthdate',
                triplk__Operator__c = '>',
                triplk__Field_Value__c = '01/01/1960'
        ));
        rules.add(new triplk__Contact_Assignment_Rule__c(
                Name = 'rule 6',
                triplk__Field_API_Name__c = 'Birthdate',
                triplk__Operator__c = '>=',
                triplk__Field_Value__c = '01/02/1960'
        ));
        return rules;
    }
    private static List<Account> createAccounts() {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 500; i++) {
            accounts.add(new Account(
                    Name = 'Account ' + i,
                    triplk__ContactsLimit__c = i > 250 ? 10 : null
            ));
        }
        return accounts;
    }
    private static List<triplk__JunctionContactARAccount__c> createJunctions(List<Account> accounts, List<triplk__Contact_Assignment_Rule__c> rules) {
        List<triplk__JunctionContactARAccount__c> junctions = new List<triplk__JunctionContactARAccount__c>();
        for (Integer i = 0; i < 12; i++) {
            junctions.add(new triplk__JunctionContactARAccount__c(
                    triplk__Contact_Assignment_Rule__c = i < 6 ? rules[i].Id : rules[i - 6].Id,
                    triplk__Account__c = accounts[i + 6].Id
            ));
        }
        return junctions;
    }
    private static List<Contact> createContacts(List<Account> accounts) {
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < 300; i++) {
            contacts.add(new Contact(
                    FirstName = 'Contact',
                    LastName = i < 15 ? '1' : '' + i,
                    AccountId = (i > 5) && (i < 10) ? accounts[0].Id : null
            ));
        }
        contacts.add(new Contact(
                FirstName = 'Contact',
                LastName = '2',
                AccountId = accounts[7].Id
        ));
        contacts.add(new Contact(
                FirstName = 'Contact',
                LastName = '1',
                AccountId = accounts[7].Id
        ));
        contacts.add(new Contact(
                FirstName = 'Contact',
                LastName = '1',
                AccountId = accounts[10].Id
        ));

        for (Integer i = 0; i < 30; i++) {
            if (i < 4) {
                contacts.add(new Contact(
                        FirstName = 'Contact',
                        LastName = '' + i,
                        Birthdate = Date.valueOf('1930-01-01'),
                        AccountId = accounts[8].Id
                ));
                contacts.add(new Contact(
                        FirstName = 'Contact',
                        LastName = '' + i,
                        Birthdate = Date.valueOf('1930-01-01'),
                        AccountId = accounts[9].Id
                ));
            }
            if ((i >= 4) && (i < 8)) {
                contacts.add(new Contact(
                        FirstName = 'Contact',
                        LastName = '' + i,
                        Birthdate = Date.valueOf('1950-01-01'),
                        AccountId = accounts[10].Id
                ));
                contacts.add(new Contact(
                        FirstName = 'Contact',
                        LastName = '' + i,
                        Birthdate = Date.valueOf('1950-01-01'),
                        AccountId = accounts[11].Id
                ));
            }
            contacts.add(new Contact(
                    FirstName = 'Contact',
                    LastName = '' + i,
                    Birthdate = Date.valueOf('1930-01-01')
            ));
        }

        for (Integer i = 30; i < 90; i++) {
            contacts.add(new Contact(
                    FirstName = 'Contact',
                    LastName = '' + i,
                    Birthdate = Date.valueOf('1950-01-01')
            ));
        }

        for (Integer i = 90; i < 120; i++) {
            if (i < 94) {
                contacts.add(new Contact(
                        FirstName = 'Contact',
                        LastName = '' + i,
                        Birthdate = Date.valueOf('1950-01-01'),
                        AccountId = accounts[10].Id
                ));
                contacts.add(new Contact(
                        FirstName = 'Contact',
                        LastName = '' + i,
                        Birthdate = Date.valueOf('1950-01-01'),
                        AccountId = accounts[11].Id
                ));
            }
            if ((i >= 94) && (i < 98)) {
                contacts.add(new Contact(
                        FirstName = 'Contact',
                        LastName = '' + i,
                        Birthdate = Date.valueOf('1950-01-01'),
                        AccountId = accounts[8].Id
                ));
                contacts.add(new Contact(
                        FirstName = 'Contact',
                        LastName = '' + i,
                        Birthdate = Date.valueOf('1950-01-01'),
                        AccountId = accounts[9].Id
                ));
            }
            contacts.add(new Contact(
                    FirstName = 'Contact',
                    LastName = '' + i,
                    Birthdate = Date.valueOf('1970-01-01')
            ));
        }

        contacts.add(new Contact(
                FirstName = 'Contact',
                LastName = '1',
                AccountId = accounts[12].Id
        ));
        return contacts;
    }
    private static void checkPrivateMethods(CheckContactForBatch check) {
        Map<String, SObjectField> fieldsTypeMap = Schema.getGlobalDescribe().get('Contact').getDescribe().fields.getMap();
        SetContactToAccountBatch setContact = new SetContactToAccountBatch('String');
        check.parseDataType('01/01/1950', fieldsTypeMap.get('Birthdate').getDescribe().getSoapType());
        setContact.parseDataType('01/01/1950', fieldsTypeMap.get('Birthdate').getDescribe().getSoapType());
        check.parseDataType('01/01/1950 11:10 PM', fieldsTypeMap.get('LastCURequestDate').getDescribe().getSoapType());
        check.parseDataType('01/01/1950 12:10 AM', fieldsTypeMap.get('LastCURequestDate').getDescribe().getSoapType());
        setContact.parseDataType('01/01/1950 11:10 PM', fieldsTypeMap.get('LastCURequestDate').getDescribe().getSoapType());
        setContact.parseDataType('01/01/1950 12:10 AM', fieldsTypeMap.get('LastCURequestDate').getDescribe().getSoapType());
    }

}