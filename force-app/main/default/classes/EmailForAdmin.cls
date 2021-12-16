public with sharing class EmailForAdmin implements Schedulable{

    public static void execute(SchedulableContext ctx) {
        Messaging.reserveSingleEmailCapacity(1);
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        User admin = [
                SELECT Id, Email
                FROM User
                WHERE Profile.Name = 'System Administrator'
        ];
        EmailTemplate temp = [
                SELECT Id
                FROM EmailTemplate
                WHERE DeveloperName = 'Email_For_Admin'
        ];

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTemplateId(temp.Id);
        mail.setTargetObjectId(admin.Id);
        mail.setSaveAsActivity(false);
        mails.add(mail);

        Messaging.sendEmail(mails);
    }

}