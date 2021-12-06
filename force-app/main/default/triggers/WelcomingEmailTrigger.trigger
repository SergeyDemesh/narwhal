trigger WelcomingEmailTrigger on Contact (after insert) {
    if(Trigger.isAfter) {
        if(Trigger.isInsert) {
            WelcomingEmailTriggerHandler.sendEmail(Trigger.new);
        }
    }
}