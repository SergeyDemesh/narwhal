public with sharing class CurrencyConverterService {

    @AuraEnabled(Cacheable=true)
    public static List<CurrencyWrapper> getRatesListForDate(String dateRate) {
        if ((dateRate == null) || dateRate > String.valueOf(Date.today())) {return null;}
        List<Object> ratesObjects = new List<Object>();
        List<CurrencyWrapper> ratesWrappers = new List<CurrencyWrapper>();
        String endPoint = 'https://www.nbrb.by/api/exrates/rates?periodicity=0&ondate=' + dateRate;

        Http http = new Http();

        HttpRequest request = new HttpRequest();
        request.setEndpoint(endPoint);
        request.setMethod('GET');
        request.setTimeout(120000);

        HttpResponse response = http.send(request);

        System.debug(response.getBody());

        if (response.getStatusCode() == 200) {
            try {
                ratesObjects = (List<Object>)JSON.deserializeUntyped(response.getBody());
            } catch (Exception e) {
                throw new AuraHandledException(e.getMessage());
            }
        }
        for (Object rate: ratesObjects) {
            ratesWrappers.add(new CurrencyWrapper(rate));
        }
        return ratesWrappers;
    }

    public class CurrencyWrapper {
        @AuraEnabled public String label;
        @AuraEnabled public String value;
        @AuraEnabled public String scale;
        public CurrencyWrapper(Object currObject) {
            this.label = currObject.toString().substringAfter('Cur_Abbreviation=').substringBefore(',');
            this.value = currObject.toString().substringAfter('Cur_OfficialRate=').substringBefore(',');
            this.scale = currObject.toString().substringAfter('Cur_Scale=').substringBefore(',');
        }
    }
}