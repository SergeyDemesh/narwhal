public with sharing class ContactTriggerHandler {
    public static EmailTemplate template;

    public static void afterInsertHandler(List<Contact> contacts) {
        Messaging.reserveSingleEmailCapacity(200);
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        if (template == null) {
            template = [
                    SELECT Id, Body, Subject
                    FROM EmailTemplate
                    WHERE DeveloperName = 'template1'
            ];
        }
        for(Contact contact : contacts) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTargetObjectId(contact.Id);
            mail.setTemplateId(template.Id);
            mails.add(mail);
        }
        Messaging.sendEmail(mails);
    }
}
