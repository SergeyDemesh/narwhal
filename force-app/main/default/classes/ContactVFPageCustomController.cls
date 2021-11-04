public with sharing class ContactVFPageCustomController {

    private final Contact contact;
    private final List<Contact> contacts;

    public ContactVFPageCustomController() {
        contact = [
                SELECT Id, Name
                FROM Contact
                WHERE Id = :ApexPages.currentPage().getParameters().get('id')
        ];
        contacts = [
                SELECT Id, Name, Email, Phone
                FROM Contact
                LIMIT 50000
        ];

    }

    public Contact getContact () {
        return contact;
    }

    public List<Contact> getContacts () {
        return contacts;
    }

    public PageReference viewAll() {
        PageReference allContacts = new PageReference('/apex/ContactsTableCustom');
        return allContacts;
    }
}