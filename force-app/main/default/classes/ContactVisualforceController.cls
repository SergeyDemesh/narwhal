public with sharing class ContactVisualforceController {

    public ContactVisualforceController(ApexPages.StandardController controller) {

    }

    public PageReference viewAll() {
        PageReference allContact = new PageReference('/apex/ContactsTable');
        return allContact;
    }
}