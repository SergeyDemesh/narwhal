public with sharing class AddTitleToContactBatch implements Database.Batchable<SObject>{

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id, Title ' +
                                        'FROM Contact '
                                        );
    }

    public void execute(Database.BatchableContext bc, List<Contact> records){
        System.debug(records.size());
        for (Contact contact: records) {
            contact.Title =  'Async Apex';
        }
        update records;
    }

    public void finish(Database.BatchableContext bc){

    }
}