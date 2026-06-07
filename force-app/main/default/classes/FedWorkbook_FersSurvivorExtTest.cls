@isTest
private class FedWorkbook_FersSurvivorExtTest {

    private static void exerciseAll(FedWorkbook_FersSurvivorExt ext) {
        System.assertNotEquals(null, ext.getS1RetirementAge(), 'S1 retirement age');
        System.assertNotEquals(null, ext.getS1CurrentMonthlyIncome(), 'S1 current monthly income');
        System.assertNotEquals(null, ext.getS1MonthlyRetirementAnnuity(), 'S1 monthly annuity');
        System.assertNotEquals(null, ext.getS1DifferenceInMonthlyAnnuity(), 'S1 difference');
        System.assertNotEquals(null, ext.getS2RetirementAge(), 'S2 retirement age');
        System.assertNotEquals(null, ext.getS2CurrentMonthlyIncome(), 'S2 current monthly income');
        System.assertNotEquals(null, ext.getS2MonthlyRetirementAnnuity(), 'S2 monthly annuity');
        System.assertNotEquals(null, ext.getS2DifferenceInMonthlyAnnuity(), 'S2 difference');
        System.assertNotEquals(null, ext.getMonthlyAnnuity(), 'Monthly annuity');
        System.assertNotEquals(null, ext.getMinus5Pct(), 'Minus 5%');
        System.assertNotEquals(null, ext.getReducedMin(), 'Reduced min');
        System.assertNotEquals(null, ext.getSurvivingSpouseMin(), 'Surviving spouse min');
        System.assertNotEquals(null, ext.getMinus10Pct(), 'Minus 10%');
        System.assertNotEquals(null, ext.getReducedMax(), 'Reduced max');
        System.assertNotEquals(null, ext.getSurvivingSpouseMax(), 'Surviving spouse max');
    }

    @isTest
    static void testScenario1Primary() {
        Lead l = FedWorkbook_TestData.fersBefore62();
        Test.startTest();
        FedWorkbook_FersSurvivorExt ext =
            new FedWorkbook_FersSurvivorExt(FedWorkbook_TestData.sc(l.Id));
        exerciseAll(ext);
        ext.saveLead();
        Test.stopTest();
    }

    @isTest
    static void testScenario2Primary() {
        Lead l = FedWorkbook_TestData.fersAfter62();
        Test.startTest();
        exerciseAll(new FedWorkbook_FersSurvivorExt(FedWorkbook_TestData.sc(l.Id)));
        Test.stopTest();
    }

    @isTest
    static void testDefaultAnnuityPath() {
        // Neither scenario primary => getMonthlyAnnuity uses Expected_Retirement path
        Lead l = FedWorkbook_TestData.neitherScenario();
        Test.startTest();
        exerciseAll(new FedWorkbook_FersSurvivorExt(FedWorkbook_TestData.sc(l.Id)));
        Test.stopTest();
    }

    @isTest
    static void testMinMaxElection() {
        Lead l = FedWorkbook_TestData.fersBefore62();
        Test.startTest();
        FedWorkbook_FersSurvivorExt ext =
            new FedWorkbook_FersSurvivorExt(FedWorkbook_TestData.sc(l.Id));

        // Electing Min clears Max.
        ext.lead.Min__c = true;
        ext.setMin();
        System.assertEquals(true, ext.getMinSelected(), 'Min is selected');
        System.assertEquals(false, ext.getMaxSelected(), 'Max cleared when Min chosen');

        // Electing Max clears Min.
        ext.lead.Max__c = true;
        ext.setMax();
        System.assertEquals(true, ext.getMaxSelected(), 'Max is selected');
        System.assertEquals(false, ext.getMinSelected(), 'Min cleared when Max chosen');
        Test.stopTest();
    }

    @isTest
    static void testNullId() {
        Test.startTest();
        FedWorkbook_FersSurvivorExt ext =
            new FedWorkbook_FersSurvivorExt(new ApexPages.StandardController(new Lead()));
        System.assertEquals(0, ext.getMonthlyAnnuity(), 'No data => 0 annuity');
        Test.stopTest();
    }
}
