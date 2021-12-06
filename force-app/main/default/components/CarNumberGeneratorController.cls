public with sharing class CarNumberGeneratorController {
    public String carNumber{get; set;}

    public void generateNumber() {
        String num = String.valueOf(Math.round(Math.random()*1000));
        String city = [SELECT Id, Address FROM User WHERE Id = :UserInfo.getUserId()].Address.getCity();
        String regionId = [SELECT Number_of_region__c FROM City__mdt WHERE Label = :city].Number_of_region__c;
        String region = [SELECT Label FROM Number_of_region__mdt WHERE Id = :regionId].Label;
        String letters = [SELECT Id, triplk__Letters__c FROM triplk__User__c WHERE SetupOwnerId = :UserInfo.getProfileId()].triplk__Letters__c;
        try {
            carNumber = num.length() < 4 ? '0'.repeat(4 - num.length()) + num + ' ' + letters + '-' + region : num + ' ' + letters + '-' + region;
        } catch (NullPointerException ex) {
            throw new VisualforceException(ex.getMessage());
        }
    }

    public void saveNumber() {
        User user = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        user.triplk__Car_Number__c = carNumber;
        update user;
    }

}