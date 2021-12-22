@IsTest
public with sharing class RestWebServicePracticeTest {

    @TestSetup
    public static void createData() {
        insert createContacts();
        insert createSecretWord();
        mockSecretKey();

    }

    @IsTest
    public static void authUserTest() {
        RestRequest request = new RestRequest();
        request.requestURI = 'empathetic-narwhal-qn5hhf-dev-ed.lightning.force.com/services/apexrest/triplk/party/';
        request.httpMethod = 'POST';
        RestContext.request = request;
        String secretKey = RestWebServicePractice.authUser('test word');
        System.assertNotEquals(secretKey, null);

    }

    @IsTest
    public static void authUserNegativeTest() {
        RestRequest request = new RestRequest();
        request.requestURI = 'empathetic-narwhal-qn5hhf-dev-ed.lightning.force.com/services/apexrest/triplk/party/';
        request.httpMethod = 'POST';
        RestContext.request = request;
        String secretKey = RestWebServicePractice.authUser('wrong word');
        System.assertEquals(secretKey, 'Nice try');

    }

    @IsTest
    public static void putGuestTest() {

        RestRequest request = new RestRequest();
        request.requestURI = 'empathetic-narwhal-qn5hhf-dev-ed.lightning.force.com/services/apexrest/triplk/party/';
        request.params.put('key', '111111');
        request.httpMethod = 'PUT';
        RestContext.request = request;
        List<String> names = new List<String>{'Contact 1', 'Contact 2', 'Contact 3', 'Not Contact'};
        String response = RestWebServicePractice.putGuest(names);
        List<triplk__Guest__c> guests = [
                SELECT Id
                FROM triplk__Guest__c
        ];

        System.assertEquals(guests.size(), 4);
    }

    @IsTest
    public static void putGuestEmptyContactsNegativeTest() {

        RestRequest request = new RestRequest();
        request.requestURI = 'empathetic-narwhal-qn5hhf-dev-ed.lightning.force.com/services/apexrest/triplk/party/';
        request.params.put('key', '111111');
        request.httpMethod = 'PUT';
        RestContext.request = request;
        List<String> names = new List<String>();
        String response = RestWebServicePractice.putGuest(names);
        List<triplk__Guest__c> guests = [
                SELECT Id
                FROM triplk__Guest__c
        ];

        System.assertEquals(response, 'Failed!');
    }

    @IsTest
    public static void putGuestSameContactsNameTest() {

        RestRequest request = new RestRequest();
        request.requestURI = 'empathetic-narwhal-qn5hhf-dev-ed.lightning.force.com/services/apexrest/triplk/party/';
        request.params.put('key', '111111');
        request.httpMethod = 'PUT';
        RestContext.request = request;
        List<String> names = new List<String>{'Contact 1', 'Contact 2', 'Contact 10'};
        String response = RestWebServicePractice.putGuest(names);
        List<triplk__Guest__c> guests = [
                SELECT Id
                FROM triplk__Guest__c
        ];

        System.assertEquals(guests.size(), 0);
        System.assertEquals(response, 'Too many contacts for name: Contact 10');
    }

    @IsTest
    public static void putGuestInvalidKeyTest() {

        RestRequest requestDelete = new RestRequest();
        requestDelete.requestURI = 'empathetic-narwhal-qn5hhf-dev-ed.lightning.force.com/services/apexrest/triplk/party/';
        requestDelete.params.put('key', '222222');
        requestDelete.httpMethod = 'DELETE';
        requestDelete.params.put('guestId', 'a045j000002Z21TAAS');
        RestContext.request = requestDelete;
        String response = RestWebServicePractice.deleteGuest();

        System.assertEquals(response, 'You must be logged in');
    }

    @IsTest
    public static void expireSecretKeyTest() {

        insert new triplk__Secret_Key__c(
                triplk__ExpireAt__c = Datetime.now().addMinutes(-2),
                triplk__Key__c = '555555'
        );

        RestRequest request = new RestRequest();
        request.requestURI = 'empathetic-narwhal-qn5hhf-dev-ed.lightning.force.com/services/apexrest/triplk/party/';
        request.params.put('key', '555555');
        request.httpMethod = 'PUT';
        RestContext.request = request;
        List<String> names = new List<String>{'Contact 1', 'Contact 2', 'Contact 3', 'Not Contact'};
        String response = RestWebServicePractice.putGuest(names);
        List<triplk__Guest__c> guests = [
                SELECT Id
                FROM triplk__Guest__c
        ];

        System.assertEquals(guests.size(), 0);
        System.assertEquals(response, 'You must be logged in');
    }

    @IsTest
    public static void getGuestTest() {

        RestRequest request = new RestRequest();
        request.requestURI = 'empathetic-narwhal-qn5hhf-dev-ed.lightning.force.com/services/apexrest/triplk/party/';
        request.params.put('key', '111111');
        request.httpMethod = 'GET';
        RestContext.request = request;
        List<String> names = new List<String>{'Contact 1', 'Contact 2', 'Contact 3'};
        RestWebServicePractice.putGuest(names);
        List<triplk__Guest__c> guests = RestWebServicePractice.getGuest();
        System.assertEquals(guests.size(), 3);
    }

    @IsTest
    public static void getGuestInvalidKeyTest() {

        RestRequest request = new RestRequest();
        request.requestURI = 'empathetic-narwhal-qn5hhf-dev-ed.lightning.force.com/services/apexrest/triplk/party/';
        request.params.put('key', '222222');
        request.httpMethod = 'GET';
        RestContext.request = request;
        List<String> names = new List<String>{'Contact 1', 'Contact 2', 'Contact 3'};
        RestWebServicePractice.putGuest(names);
        List<triplk__Guest__c> guests = RestWebServicePractice.getGuest();
        System.assertEquals(guests, null);
    }

    @IsTest
    public static void getNotInvitedGuestTest() {

        RestRequest request = new RestRequest();
        request.requestURI = 'empathetic-narwhal-qn5hhf-dev-ed.lightning.force.com/services/apexrest/triplk/party/';
        request.params.put('key', '111111');
        request.params.put('notInvited', 'true');
        request.httpMethod = 'GET';
        RestContext.request = request;
        List<String> names = new List<String>{'Contact 1', 'Contact 2', 'Contact 3'};
        RestWebServicePractice.putGuest(names);
        List<triplk__Guest__c> guests = RestWebServicePractice.getGuest();
        System.assertEquals(guests.size(), 3);
    }

    @IsTest
    public static void inviteGuestTest() {

        RestRequest request = new RestRequest();
        request.requestURI = 'empathetic-narwhal-qn5hhf-dev-ed.lightning.force.com/services/apexrest/triplk/party/';
        request.params.put('key', '111111');
        request.httpMethod = 'PATCH';
        RestContext.request = request;
        List<String> names = new List<String>{'Contact 1', 'Contact 2', 'Contact 3'};
        RestWebServicePractice.putGuest(names);
        triplk__Guest__c guest = [
                SELECT Id
                FROM triplk__Guest__c
                LIMIT 1
        ];
        String response = RestWebServicePractice.inviteGuest(guest.Id);
        List<triplk__Guest__c> guests = [
                SELECT Id
                FROM triplk__Guest__c
                WHERE triplk__Is_invited__c = TRUE
        ];
        System.assertEquals(guests.size(), 1);
    }

    @IsTest
    public static void inviteGuestInvalidKeyTest() {

        RestRequest requestPut = new RestRequest();
        requestPut.requestURI = 'empathetic-narwhal-qn5hhf-dev-ed.lightning.force.com/services/apexrest/triplk/party/';
        requestPut.params.put('key', '111111');
        requestPut.httpMethod = 'PUT';
        RestContext.request = requestPut;
        List<String> names = new List<String>{'Contact 1', 'Contact 2', 'Contact 3'};
        RestWebServicePractice.putGuest(names);

        RestRequest request = new RestRequest();
        request.requestURI = 'empathetic-narwhal-qn5hhf-dev-ed.lightning.force.com/services/apexrest/triplk/party/';
        request.params.put('key', '333');
        request.httpMethod = 'PATCH';
        RestContext.request = request;
        triplk__Guest__c guest = [
                SELECT Id
                FROM triplk__Guest__c
                LIMIT 1
        ];
        String response = RestWebServicePractice.inviteGuest(guest.Id);
        List<triplk__Guest__c> guests = [
                SELECT Id
                FROM triplk__Guest__c
                WHERE triplk__Is_invited__c = TRUE
        ];
        System.assertEquals(response, 'You must be logged in');
    }

    @IsTest
    public static void inviteGuestNegativeTest() {

        RestRequest request = new RestRequest();
        request.requestURI = 'empathetic-narwhal-qn5hhf-dev-ed.lightning.force.com/services/apexrest/triplk/party/';
        request.params.put('key', '111111');
        request.httpMethod = 'PATCH';
        RestContext.request = request;
        List<String> names = new List<String>{'Contact 1', 'Contact 2', 'Contact 3'};
        RestWebServicePractice.putGuest(names);
        String response = RestWebServicePractice.inviteGuest('a045j000002Z21TAAS');
        List<triplk__Guest__c> guests = [
                SELECT Id
                FROM triplk__Guest__c
                WHERE triplk__Is_invited__c = TRUE
        ];
        System.assertEquals(guests.size(), 0);
        System.assertEquals(response, 'Guest not found');
    }

    @IsTest
    public static void deleteGuestTest() {

        RestRequest requestPut = new RestRequest();
        requestPut.requestURI = 'empathetic-narwhal-qn5hhf-dev-ed.lightning.force.com/services/apexrest/triplk/party/';
        requestPut.params.put('key', '111111');
        requestPut.httpMethod = 'PUT';
        RestContext.request = requestPut;
        List<String> names = new List<String>{'Contact 1', 'Contact 2', 'Contact 3'};
        RestWebServicePractice.putGuest(names);
        triplk__Guest__c guest = [
                SELECT Id
                FROM triplk__Guest__c
                LIMIT 1
        ];

        RestRequest requestDelete = new RestRequest();
        requestDelete.requestURI = 'empathetic-narwhal-qn5hhf-dev-ed.lightning.force.com/services/apexrest/triplk/party/';
        requestDelete.params.put('key', '111111');
        requestDelete.httpMethod = 'DELETE';
        requestDelete.params.put('guestId', guest.Id);
        RestContext.request = requestDelete;
        String response = RestWebServicePractice.deleteGuest();
        List<triplk__Guest__c> guests = [
                SELECT Id
                FROM triplk__Guest__c
        ];
        System.assertEquals(guests.size(), 2);
    }

    private static List<Contact> createContacts() {
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < 10; i++) {
            contacts.add(new Contact(
                    FirstName = 'Contact',
                    LastName = '' + i
            ));
            contacts.add(new Contact(
                    FirstName = 'Contact',
                    LastName = '10'
            ));
        }
        return contacts;
    }

    private static triplk__Secret_Word__c createSecretWord() {
        return new triplk__Secret_Word__c(
          triplk__Word__c = 'test word'
        );
    }

    private static void mockSecretKey() {
        insert new triplk__Secret_Key__c(
                triplk__ExpireAt__c = Datetime.now().addMinutes(1),
                triplk__Key__c = '111111'
        );
    }

}