public with sharing class QueueableCreateContactFirst implements Queueable{

    public void execute(QueueableContext context) {
        List<Contact> contacts = new List<Contact>();
        for(Integer i = 0; i < 200; i++) {
            contacts.add(new Contact(FirstName = 'FirstJob'));
        }
        System.enqueueJob(new QueueableCreateContactSecond(contacts));
    }

}