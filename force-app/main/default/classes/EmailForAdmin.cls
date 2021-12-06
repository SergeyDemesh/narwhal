public with sharing class EmailForAdmin {

    public static void sendEmailForAdmin() {
        Messaging.reserveSingleEmailCapacity(1);
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        List<Contact> newContacts = [
                SELECT Id, Name
                FROM Contact
                WHERE CreatedDate = TODAY
        ];
        List<Account> newAccount = [
                SELECT Id, Name
                FROM Account
                WHERE CreatedDate = TODAY
        ];
        List<Case> newCases = [
                SELECT Id
                FROM Case
                WHERE CreatedDate = TODAY
        ];
        String body = 'New Contacts : ' + newContacts.toString() + '\n' +
                'New Accounts : ' + newAccount + '\n' +
                'New Cases : ' + newCases;
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setPlainTextBody(body);
        mail.setToAddresses(new List<String>{'sergey,demesh98@gmail.com'});
        mails.add(mail);

        Messaging.sendEmail(mails);
    }

}