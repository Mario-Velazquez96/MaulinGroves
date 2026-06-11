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
        // Code on file => locked "Current Age", not the editable "Starting Age".
        System.assertEquals(true, ext.getShowCurrentAgeA(), 'Coded lead => Current Age (A)');
        System.assertEquals(false, ext.getShowStartingAgeA(), 'Coded lead => no Starting Age (A)');
        System.assertEquals(true, ext.getShowCurrentAgeC(), 'Coded lead => Current Age (C)');
        System.assertEquals(false, ext.getShowStartingAgeC(), 'Coded lead => no Starting Age (C)');
        System.assertEquals(false, ext.getShowMultiplesManualC(), 'Coded lead => derived multiples');
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
        // No code => editable "Starting Age" and manual multiples.
        System.assertEquals(true, ext.getShowStartingAgeA(), 'Manual lead => Starting Age (A)');
        System.assertEquals(false, ext.getShowCurrentAgeA(), 'Manual lead => no Current Age (A)');
        System.assertEquals(true, ext.getShowStartingAgeC(), 'Manual lead => Starting Age (C)');
        System.assertEquals(true, ext.getShowMultiplesManualC(), 'Manual lead => editable multiples');

        // saveLead persists an edited Starting Age and re-queries.
        ext.lead.Age_Option_A_Manual__c = FedWorkbook_TestData.pickVal(
            Lead.Age_Option_A_Manual__c, new Set<String>{ '45-49' }, '45-49');
        System.assertEquals(null, ext.saveLead(), 'saveLead returns null (stays on page)');
        System.assertNotEquals(null, ext.getOptionACost(), 'Cost recomputes after save');
        Test.stopTest();
    }

    @isTest
    static void testSaveNoIdIsNoOp() {
        Test.startTest();
        FedWorkbook_FegliACExt ext =
            new FedWorkbook_FegliACExt(new ApexPages.StandardController(new Lead()));
        // No Id => saveLead must not attempt a DML and simply returns null.
        System.assertEquals(null, ext.saveLead(), 'saveLead is a no-op without an Id');
        System.assertEquals(false, ext.getShowStartingAgeA(), 'Empty lead => Option A not elected');
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
