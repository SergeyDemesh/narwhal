public with sharing class WelcomingEmailTriggerHandler {

    public static void sendEmail(List<Contact> contacts) {
        Messaging.reserveSingleEmailCapacity(9);
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        EmailTemplate template = [
                SELECT Id, Body, Subject
                FROM EmailTemplate
                WHERE DeveloperName = 'template1'
        ];
        for(Contact contact : contacts) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTargetObjectId(contact.Id);
            mail.setTemplateId(template.Id);
            mails.add(mail);
        }
        Messaging.sendEmail(mails);
    }
}