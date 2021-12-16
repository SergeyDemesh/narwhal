public with sharing class CarNumberGeneratorController {
    public String carNumber{get; set;}
    public List<String> carNumbers = new List<String>();
    private List<User> users = new List<User>();
    private List<User> changedUsers = new List<User>();
    private User myUser;
    private List<City__mdt> citiesMetaData = new List<City__mdt>();
    private Set<String> cities = new Set<String>();
    private Map<String,String> cityRegion = new Map<String,String>();
    private Map<String,String> userLetters = new Map<String,String>();
    private Map<String,String> userRegion = new Map<String,String>();

    public CarNumberGeneratorController() {
        getAllUserInfo();
    }

    public String generateNumber() {
        return String.valueOf(Math.round(Math.random()*1000));
    }

    public void generateNumberForMe() {
        do {
            String num = generateNumber();
            carNumber = num.length() < 4 ? '0'.repeat(4 - num.length()) + num + ' ' + userLetters.get(myUser.Id) + '-' + userRegion.get(myUser.Id) : num + ' ' + userLetters.get(myUser.Id) + '-' + userRegion.get(myUser.Id);
        } while (carNumbers.contains(carNumber));
        myUser.triplk__Car_Number__c = carNumber;
    }

    public void generateAllNumber() {
        String newCarNumber;
        for(User userItem: users) {
            if(String.isBlank(userItem.triplk__Car_Number__c)) {
                do {
                    String num = generateNumber();
                    newCarNumber = num.length() < 4 ? '0'.repeat(4 - num.length()) + num + ' ' + userLetters.get(userItem.Id) + '-' + userRegion.get(userItem.Id) : num + ' ' + userLetters.get(userItem.Id) + '-' + userRegion.get(userItem.Id);
                } while (carNumbers.contains(newCarNumber));
                userItem.triplk__Car_Number__c = newCarNumber;
                changedUsers.add(userItem);
            }
        }
    }

    public void saveNumber() {
        update myUser;
        update changedUsers;
    }

    private void getAllUserInfo(){

        users = [
                SELECT Id, Name, ProfileId, City, triplk__Car_Number__c
                FROM User
                WHERE City != NULL
        ];


        for (User userItem : users) {
            cities.add(userItem.City);
            carNumbers.add(userItem.triplk__Car_Number__c);
            if (userItem.Id == UserInfo.getUserId()) {
                myUser = userItem;
            }
        }

        citiesMetaData = [
                SELECT Label, triplk__Number_of_region__r.Label
                FROM City__mdt
                WHERE Label IN :cities
        ];


        for (City__mdt cityItem : citiesMetaData) {
            cityRegion.put(cityItem.Label, cityItem.triplk__Number_of_region__r.Label);
        }


        for (User userItem: users) {
            triplk__User__c customSetting = triplk__User__c.getInstance(userItem.ProfileId);
            userLetters.put(userItem.Id, customSetting.triplk__Letters__c);
            userRegion.put(userItem.Id, cityRegion.get(userItem.City));
        }


    }

    public List<User> getChangedUsers() {
        return changedUsers;
    }

}