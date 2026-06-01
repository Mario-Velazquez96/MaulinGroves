@isTest
private class FedWorkbook_FegliACExtTest {

    @isTest
    static void testWithFegliCode() {
        Lead l = FedWorkbook_TestData.fegliWithCode();

        Test.startTest();
        FedWorkbook_FegliACExt ext =
            new FedWorkbook_FegliACExt(FedWorkbook_TestData.sc(l.Id));
        System.assertNotEquals(null, ext.getOptionACost(), 'Option A cost should compute');
        System.assertNotEquals(null, ext.getOptionCMultiples(), 'Option C multiples should compute');
        System.assertNotEquals(null, ext.getOptionCBiWeeklyFactor(), 'Option C factor should compute');
        Test.stopTest();
    }

    @isTest
    static void testManualBands() {
        Lead l = FedWorkbook_TestData.fegliManual();

        Test.startTest();
        FedWorkbook_FegliACExt ext =
            new FedWorkbook_FegliACExt(FedWorkbook_TestData.sc(l.Id));
        // Manual-band lookups (no FEGLI code) — values depend on the org picklist,
        // but every branch path is exercised and must return a non-null Decimal.
        System.assertNotEquals(null, ext.getOptionACost(), 'Manual Option A cost');
        System.assertNotEquals(null, ext.getOptionCMultiples(), 'Manual Option C multiples');
        System.assertNotEquals(null, ext.getOptionCBiWeeklyFactor(), 'Manual Option C factor');
        Test.stopTest();
    }

    @isTest
    static void testNullId() {
        Test.startTest();
        FedWorkbook_FegliACExt ext =
            new FedWorkbook_FegliACExt(new ApexPages.StandardController(new Lead()));
        System.assertEquals(0, ext.getOptionACost(), 'No data => 0');
        System.assertEquals(0, ext.getOptionCMultiples(), 'No data => 0 multiples');
        System.assertEquals(0, ext.getOptionCBiWeeklyFactor(), 'No data => 0 factor');
        Test.stopTest();
    }
}
