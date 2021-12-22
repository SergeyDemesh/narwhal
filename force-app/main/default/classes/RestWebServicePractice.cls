@RestResource(UrlMapping='/party/*')
global with sharing class RestWebServicePractice {


    @HttpGet
    global static List<triplk__Guest__c> getGuest() {
        String secretKey = RestContext.request.params.get('key');
        if (!CheckSecretKey.checkKey(secretKey)) {
            return null;
        }
        String whereCondition;
        String guestId = RestContext.request.params.get('guestId');
        String notInvited = RestContext.request.params.get('notInvited');
        if (notInvited == 'true') {
            whereCondition = guestId != null ? ' WHERE Id = ' + '\'' + guestId.remove('\n') + '\' AND triplk__Is_invited__c = FALSE' : ' WHERE triplk__Is_invited__c = FALSE';
        } else {
            whereCondition = guestId != null ? ' WHERE Id = ' + '\'' + guestId.remove('\n') + '\'' : '';
        }

        List<triplk__Guest__c> guests = Database.query('SELECT Id, Name, triplk__Contact__r.Name, triplk__Is_invited__c ' +
                                                       'FROM triplk__Guest__c' + whereCondition);
        return guests;
    }

    @HttpPut
    global static String putGuest(List<String> names) {
        String secretKey = RestContext.request.params.get('key');
        if (!CheckSecretKey.checkKey(secretKey)) {
            return 'You must be logged in';
        }
        List<triplk__Guest__c> newGuests = new List<triplk__Guest__c>();
        Map<String, Contact> namesOfContact = new Map<String, Contact>();
        List<Contact> contacts = [
                SELECT Id, Name
                FROM Contact
                WHERE Name IN :names
        ];
        for (Contact contactItem: contacts) {
            if(namesOfContact.get(contactItem.Name) != null) {
                return 'Too many contacts for name: ' + contactItem.Name;
            }
            namesOfContact.put(contactItem.Name, contactItem);
        }

        for (String nameItem: names) {
            if(namesOfContact.get(nameItem) == null) {
                contacts.add(new Contact(
                        FirstName = nameItem.substringAfter(' '),
                        LastName = nameItem.substringBefore(' ')
                ));
            }
        }
        upsert contacts;

        for (Contact contactItem: contacts) {
            newGuests.add(new triplk__Guest__c(triplk__Contact__c = contactItem.Id));
        }
        if (newGuests.size() != 0) {
            insert newGuests;
            return JSON.serialize(new Map<Id, triplk__Guest__c>(newGuests).keySet());
        }
            return 'Failed!';
    }

    @HttpPatch
    global static String inviteGuest(Id guestId) {
        String secretKey = RestContext.request.params.get('key');
        if (!CheckSecretKey.checkKey(secretKey)) {
            return 'You must be logged in';
        }
        try {
            triplk__Guest__c guest = [
                    SELECT Id, triplk__Is_invited__c
                    FROM triplk__Guest__c
                    WHERE Id = :guestId
            ];
            guest.triplk__Is_invited__c = true;
            update guest;
        } catch (Exception ex) {
            return 'Guest not found';
        }
        return 'Success';
    }

    @HttpDelete
    global static String deleteGuest() {
        String secretKey = RestContext.request.params.get('key');
        if (!CheckSecretKey.checkKey(secretKey)) {
            return 'You must be logged in';
        }
        String guestId = RestContext.request.params.get('guestId');

        delete [
                SELECT Id
                FROM triplk__Guest__c
                WHERE Id = :guestId
                ];

        return 'Success';
    }

    @HttpPost
    global static String authUser(String accessWord) {
        try {
            triplk__Secret_Word__c secretWord = [
                    SELECT triplk__Word__c
                    FROM triplk__Secret_Word__c
                    WHERE triplk__Word__c = :accessWord
                    LIMIT 1
            ];
            return CheckSecretKey.getKey();
        } catch (QueryException ex) {
            return 'Nice try';
        }
    }

}