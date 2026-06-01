@isTest
private class FedWorkbook_FersCalcExtTest {

    private static void exerciseAll(FedWorkbook_FersCalcExt ext) {
        System.assertNotEquals(null, ext.getCurrentAge(), 'Current age');
        System.assertNotEquals(null, ext.getS1RetirementAge(), 'S1 retirement age');
        System.assertNotEquals(null, ext.getS1YearsOfService(), 'S1 YOS');
        System.assertNotEquals(null, ext.getS1HighThree(), 'S1 high-3');
        System.assertNotEquals(null, ext.getS1Factor(), 'S1 factor');
        System.assertNotEquals(null, ext.getS1FactorTimesHighThree(), 'S1 factor x high-3');
        System.assertNotEquals(null, ext.getS1AnnualAnnuity(), 'S1 annual annuity');
        System.assertNotEquals(null, ext.getS1MonthlyAnnuity(), 'S1 monthly annuity');
        System.assertNotEquals(null, ext.getS2RetirementAge(), 'S2 retirement age');
        System.assertNotEquals(null, ext.getS2YearsOfService(), 'S2 YOS');
        System.assertNotEquals(null, ext.getS2HighThree(), 'S2 high-3');
        System.assertNotEquals(null, ext.getS2Factor(), 'S2 factor');
        System.assertNotEquals(null, ext.getS2FactorTimesHighThree(), 'S2 factor x high-3');
        System.assertNotEquals(null, ext.getS2AnnualAnnuity(), 'S2 annual annuity');
        System.assertNotEquals(null, ext.getS2MonthlyAnnuity(), 'S2 monthly annuity');
    }

    @isTest
    static void testBefore62Factor() {
        Lead l = FedWorkbook_TestData.fersBefore62();
        Test.startTest();
        FedWorkbook_FersCalcExt ext = new FedWorkbook_FersCalcExt(FedWorkbook_TestData.sc(l.Id));
        // Retiring before 62 => 1.0% factor
        System.assertEquals(1.0, ext.getS1Factor(), 'Before-62 factor should be 1.0%');
        exerciseAll(ext);
        ext.saveLead();
        Test.stopTest();
    }

    @isTest
    static void testAfter62Factor() {
        Lead l = FedWorkbook_TestData.fersAfter62();
        Test.startTest();
        FedWorkbook_FersCalcExt ext = new FedWorkbook_FersCalcExt(FedWorkbook_TestData.sc(l.Id));
        // Scenario 2 at 65 with 22 YOS => 1.1% factor
        System.assertEquals(1.1, ext.getS2Factor(), '>=62 with >=20 YOS should be 1.1%');
        exerciseAll(ext);
        Test.stopTest();
    }

    @isTest
    static void testNullId() {
        Test.startTest();
        FedWorkbook_FersCalcExt ext =
            new FedWorkbook_FersCalcExt(new ApexPages.StandardController(new Lead()));
        System.assertEquals(0, ext.getCurrentAge(), 'No data => 0 age');
        System.assertEquals(1.0, ext.getS1Factor(), 'No data => 1.0% factor');
        Test.stopTest();
    }
}
