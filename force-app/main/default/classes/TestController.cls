/**
 * Created by Admin on 08.12.2021.
 */

public with sharing class TestController {
    List<Account> accounts;

    public List<Account> getAccounts() {
        if(accounts == null) {
            accounts = [SELECT Name, Owner.Name FROM Account LIMIT 10];
        }
        return accounts;
    }


}