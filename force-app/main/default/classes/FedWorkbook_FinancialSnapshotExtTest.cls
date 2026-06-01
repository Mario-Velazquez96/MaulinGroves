@isTest
private class FedWorkbook_FinancialSnapshotExtTest {

    private static void exerciseAll(FedWorkbook_FinancialSnapshotExt ext) {
        System.assertNotEquals(null, ext.getSocialSecurityEligible(), 'SS eligible');
        System.assertNotEquals(null, ext.getPensionBase(), 'Pension base');
        System.assertNotEquals(null, ext.getSurvivingSpouseBenefit(), 'Surviving spouse benefit');
        System.assertNotEquals(null, ext.getIsMarried(), 'Is married');
        System.assertNotEquals(null, ext.getSpouseBenefitOptedOut(), 'Opted out');
        System.assertNotEquals(null, ext.getExpenseTotal(), 'Expense total');
        System.assertNotEquals(null, ext.getYosPercent(), 'YOS percent');
        System.assertNotEquals(null, ext.getYosFormulaVisible(), 'YOS formula visible');
        System.assertNotEquals(null, ext.getFersSupplementDisplay(), 'FERS supplement display');
        System.assertNotEquals(null, ext.getFersSupplementEligible(), 'FERS supplement eligible');
        System.assertNotEquals(null, ext.getTspDisplay(), 'TSP display');
        System.assertNotEquals(null, ext.getIncomeTotal(), 'Income total');
        System.assertNotEquals(null, ext.getDifference(), 'Difference');
        System.assertNotEquals(null, ext.getBottomLine(), 'Bottom line');
    }

    @isTest
    static void testScenario1MarriedMinBefore62() {
        Lead l = FedWorkbook_TestData.fersBefore62();
        Test.startTest();
        FedWorkbook_FinancialSnapshotExt ext =
            new FedWorkbook_FinancialSnapshotExt(FedWorkbook_TestData.sc(l.Id));
        exerciseAll(ext);
        ext.saveLead();
        Test.stopTest();
    }

    @isTest
    static void testScenario2MarriedMaxAfter62() {
        // Roth-only TSP + Max election + >=62 path
        Lead l = FedWorkbook_TestData.fersAfter62();
        Test.startTest();
        exerciseAll(new FedWorkbook_FinancialSnapshotExt(FedWorkbook_TestData.sc(l.Id)));
        Test.stopTest();
    }

    @isTest
    static void testNeitherScenarioOptedOut() {
        // Non-scenario pension path + opted-out spouse benefit + traditional-only TSP
        Lead l = FedWorkbook_TestData.neitherScenario();
        Test.startTest();
        FedWorkbook_FinancialSnapshotExt ext =
            new FedWorkbook_FinancialSnapshotExt(FedWorkbook_TestData.sc(l.Id));
        exerciseAll(ext);
        System.assert(ext.getSpouseBenefitOptedOut(), 'Married + opted out should be true');
        Test.stopTest();
    }

    @isTest
    static void testSpecialGroupPensionPath() {
        Lead l = FedWorkbook_TestData.specialGroup();
        Test.startTest();
        exerciseAll(new FedWorkbook_FinancialSnapshotExt(FedWorkbook_TestData.sc(l.Id)));
        Test.stopTest();
    }

    @isTest
    static void testNullId() {
        Test.startTest();
        FedWorkbook_FinancialSnapshotExt ext =
            new FedWorkbook_FinancialSnapshotExt(new ApexPages.StandardController(new Lead()));
        System.assertEquals(0, ext.getPensionBase(), 'No data => 0 pension');
        System.assertEquals(0, ext.getBottomLine(), 'No data => 0 bottom line');
        System.assert(!ext.getIsMarried(), 'No data => not married');
        Test.stopTest();
    }
}
