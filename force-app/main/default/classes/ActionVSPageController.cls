global with sharing class ActionVSPageController {

    String message;
    public String objectName {get; set;}
    public Boolean showOne{get; set;}
    public Boolean showTwo{get; set;}
    public Boolean showThree{get; set;}
    public static List<SObject> objects {get; set;}
    public String externalParam {get; set;}
    public String internalParam {get; set;}

    public ActionVSPageController() {
        showOne = true;
        showTwo = true;
        showThree = true;
    }

    public void changeShowOne() {
        showOne = !showOne;
    }

    public void changeShowTwo() {
        showTwo = !showTwo;
    }

    public void changeShowThree() {
        showThree = !showThree;
    }

    public String getMessageBack() {
        return message;
    }

    public PageReference printMessageBack() {
        message = ApexPages.currentPage().getParameters().get('message');
        return null;
    }

    @RemoteAction
    global static List<SObject> getObjectBack(String objectName) {
        objects = Database.query('SELECT Id, Name, CreatedDate FROM ' + objectName + ' LIMIT 5');
        return objects;
    }

    public PageReference redirectToYouTube() {
        return new PageReference('http://youtube.com/results?search_query=' + externalParam);
    }

    public PageReference redirectToGoogle() {
        return new PageReference('http://google.com/search?q=' + externalParam);
    }

    public PageReference redirectToJsDocs() {
        return new PageReference('https://developer.mozilla.org/ru/search?q=' + externalParam);
    }

    public PageReference redirectToContactInfo() {
        return new PageReference('/apex/ContactVisualforcePage?id=' + internalParam);
    }

    public PageReference redirectToContactInfoCustom() {
        return new PageReference('/apex/ContactVFPageCustom?id=' + internalParam);
    }

    public PageReference redirectToContactsTable() {
        return new PageReference('/apex/ContactsTable?id=' + internalParam);
    }


}