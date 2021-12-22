@isTest
global with sharing class CurrencyConverterServiceMock implements HttpCalloutMock{

    private static final String RESPONSE_BODY = '[' +
            '{' +
            '  "Cur_ID":440,' +
            '  "Date":"2021-12-20T00:00:00",' +
            '  "Cur_Abbreviation":"AUD",' +
            '  "Cur_Scale":1,' +
            '  "Cur_Name":"Австралийский доллар",' +
            '  "Cur_OfficialRate":1.8135' +
            '},' +
            '  {' +
            '    "Cur_ID":510,' +
            '    "Date":"2021-12-20T00:00:00",' +
            '    "Cur_Abbreviation":"AMD",' +
            '    "Cur_Scale":1000,' +
            '    "Cur_Name":"Армянских драмов",' +
            '    "Cur_OfficialRate":5.1403' +
            '  },' +
            '  {' +
            '    "Cur_ID":441,' +
            '    "Date":"2021-12-20T00:00:00",' +
            '    "Cur_Abbreviation":"BGN",' +
            '    "Cur_Scale":1,' +
            '    "Cur_Name":"Болгарский лев",' +
            '    "Cur_OfficialRate":1.4675' +
            '  }' +
            ']';


    global HttpResponse respond(HttpRequest req) {
        System.assertEquals('https://www.nbrb.by/api/exrates/rates?periodicity=0&ondate=2021-12-20', req.getEndpoint());
        System.assertEquals('GET', req.getMethod());

        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(RESPONSE_BODY);
        res.setStatusCode(200);
        return res;
    }

}