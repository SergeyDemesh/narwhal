@IsTest
public with sharing class CurrencyControllerServiceTest {

    @IsTest
    public static void testGetRatesForData() {
        Test.setMock(HttpCalloutMock.class, new CurrencyConverterServiceMock());
        List<CurrencyConverterService.CurrencyWrapper> objects = CurrencyConverterService.getRatesListForDate('2021-12-20');
        System.assert(objects.size() == 3);
    }

}