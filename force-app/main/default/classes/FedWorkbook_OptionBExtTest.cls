@isTest
private class FedWorkbook_OptionBExtTest {

    private static void exerciseAll(FedWorkbook_OptionBExt ext) {
        ext.getHasBasic();
        ext.getHasOptionA();
        ext.getHasOptionB();
        ext.getHasOptionC();
        ext.getIsUSPS();
        System.assertNotEquals(null, ext.getAnnualRatePay(), 'Annual rate pay');
        System.assertNotEquals(null, ext.getMultiplier(), 'Multiplier');
        System.assertNotEquals(null, ext.getOptionBCoverage(), 'Option B coverage');
        System.assertNotEquals(null, ext.getOptionBBiWeeklyFactor(), 'Option B bi-weekly factor');
        System.assertNotEquals(null, ext.getOptionBMonthlyFactor(), 'Option B monthly factor');
        System.assertNotEquals(null, ext.getOptionBBiWeeklyCost(), 'Option B bi-weekly cost');
        System.assertNotEquals(null, ext.getOptionBMonthlyCost(), 'Option B monthly cost');
        System.assertNotEquals(null, ext.getBasicCoverage(), 'Basic coverage');
        System.assertNotEquals(null, ext.getBasicBiWeeklyCost(), 'Basic bi-weekly cost');
        System.assertNotEquals(null, ext.getOptionACoverage(), 'Option A coverage');
        System.assertNotEquals(null, ext.getOptionABiWeeklyCost(), 'Option A bi-weekly cost');
        System.assertNotEquals(null, ext.getOptionCMultiples(), 'Option C multiples');
        System.assertNotEquals(null, ext.getOptionCBiWeeklyFactor(), 'Option C factor');
        System.assertNotEquals(null, ext.getOptionCBiWeeklyCost(), 'Option C cost');
        System.assertNotEquals(null, ext.getTotalCoverage(), 'Total coverage');
        System.assertNotEquals(null, ext.getTotalBiWeeklyCost(), 'Total bi-weekly cost');
        System.assertNotEquals(null, ext.getTotalMonthlyCost(), 'Total monthly cost');
    }

    @isTest
    static void testWithFegliCode() {
        Lead l = FedWorkbook_TestData.fegliWithCode();
        Test.startTest();
        exerciseAll(new FedWorkbook_OptionBExt(FedWorkbook_TestData.sc(l.Id)));
        Test.stopTest();
    }

    @isTest
    static void testManualBands() {
        Lead l = FedWorkbook_TestData.fegliManual();
        Test.startTest();
        exerciseAll(new FedWorkbook_OptionBExt(FedWorkbook_TestData.sc(l.Id)));
        Test.stopTest();
    }

    @isTest
    static void testNullId() {
        Test.startTest();
        FedWorkbook_OptionBExt ext =
            new FedWorkbook_OptionBExt(new ApexPages.StandardController(new Lead()));
        System.assertEquals(0, ext.getTotalCoverage(), 'No data => 0 coverage');
        System.assertEquals(0, ext.getTotalBiWeeklyCost(), 'No data => 0 cost');
        Test.stopTest();
    }
}
