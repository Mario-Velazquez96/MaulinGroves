@isTest
private class FedWorkbook_SpecialSupplementExtTest {

    @isTest
    static void testSpecialGroupGate() {
        // Special group, expected retirement before 62 => showSpecialSupp true
        Lead l = FedWorkbook_TestData.specialGroup();
        Test.startTest();
        FedWorkbook_SpecialSupplementExt ext =
            new FedWorkbook_SpecialSupplementExt(FedWorkbook_TestData.sc(l.Id));
        System.assertEquals(23.0 / 40 * 100, ext.getSupplementPct(), 'Supplement %');
        System.assertNotEquals(null, ext.getSupplementDollars(), 'Supplement dollars');
        System.assertNotEquals(null, ext.getShowSpecialSupp(), 'Gate evaluates');
        ext.saveLead();
        Test.stopTest();
    }

    @isTest
    static void testFersScenarioGate() {
        // FERS, Scenario 1 primary, retiring before 62 => gate true via FERS branch
        Lead l = FedWorkbook_TestData.fersBefore62();
        Test.startTest();
        FedWorkbook_SpecialSupplementExt ext =
            new FedWorkbook_SpecialSupplementExt(FedWorkbook_TestData.sc(l.Id));
        System.assert(ext.getShowSpecialSupp(), 'FERS before 62 should show the supplement');
        Test.stopTest();
    }

    @isTest
    static void testNullId() {
        Test.startTest();
        FedWorkbook_SpecialSupplementExt ext =
            new FedWorkbook_SpecialSupplementExt(new ApexPages.StandardController(new Lead()));
        System.assertEquals(0, ext.getSupplementPct(), 'No data => 0%');
        System.assertEquals(0, ext.getSupplementDollars(), 'No data => $0');
        // No special group / FERS, expected age defaults to 999 => not shown
        System.assert(!ext.getShowSpecialSupp(), 'No data => gate false');
        Test.stopTest();
    }
}
