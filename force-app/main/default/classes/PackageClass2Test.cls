@IsTest
public with sharing class PackageClass2Test {

    @IsTest
    private static void testFactorials() {
        List<Integer> facts = new List<Integer>{1, 2, 6, 24, 120, 720, 5040, 40320, 362880};
        System.assertEquals(facts, PackageClass2.getFactorials(new List<Integer>{1, 2, 3, 4, 5, 6 ,7, 8, 9}));
    }
}