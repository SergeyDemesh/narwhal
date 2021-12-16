public with sharing class ScheduleQueueable implements Schedulable{

    public void execute(SchedulableContext ctx) {
        QueueableCreateContactFirst createContactFirst = new QueueableCreateContactFirst();
        System.enqueueJob(createContactFirst);
    }

}