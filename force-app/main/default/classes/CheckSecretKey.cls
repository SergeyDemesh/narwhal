public with sharing class CheckSecretKey {


    public static String getKey() {
        String key = String.valueOf(Math.round(Math.random() * Math.pow(10,5)));
        insert new triplk__Secret_Key__c(
                triplk__ExpireAt__c = Datetime.now().addMinutes(1),
                triplk__Key__c = key
        );
        return key;
    }

    public static Boolean checkKey(String key) {
        try {
            triplk__Secret_Key__c keyItem = [
                    SELECT triplk__Key__c, triplk__ExpireAt__c
                    FROM triplk__Secret_Key__c
                    WHERE triplk__Key__c = :key
            ];
            if (keyItem.triplk__ExpireAt__c < Datetime.now()) {
                delete keyItem;
                return false;
            }
            return true;
        } catch (QueryException ex) {
            return false;
        }
    }
}