public with sharing class QueueableCreateContactSecond implements Queueable{

    public QueueableCreateContactSecond(List<Contact> contacts) {
        this.contacts = contacts;
    }

    public List<Contact> contacts;

    public void execute(QueueableContext context) {
        for(Contact contact: contacts) {
            contact.LastName = 'SecondJob';
        }
        insert contacts;
    }

}