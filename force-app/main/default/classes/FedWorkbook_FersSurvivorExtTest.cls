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
    static void testOptOut() {
        Lead l = FedWorkbook_TestData.fersBefore62();   // S1 primary, married path
        Test.startTest();
        FedWorkbook_FersSurvivorExt ext =
            new FedWorkbook_FersSurvivorExt(FedWorkbook_TestData.sc(l.Id));

        // Baseline (not opted out): reductions and surviving-spouse income are non-zero.
        Decimal annuity = ext.getMonthlyAnnuity();
        System.assert(annuity > 0, 'Annuity should be positive for this scenario');
        System.assertEquals(annuity * 0.25, ext.getSurvivingSpouseMin(), 'Min benefit before opt-out');
        System.assertEquals(annuity * 0.50, ext.getSurvivingSpouseMax(), 'Max benefit before opt-out');

        // Pre-select Min; opting out must NOT change the Min/Max election.
        ext.lead.Min__c = true;
        ext.setMin();
        System.assertEquals(true, ext.getMinSelected(), 'Min selected before opt-out');

        // Opt out: independent of Min/Max — leaves them untouched, but still
        // zeros reductions and surviving-spouse income (opt-out takes precedence).
        ext.lead.Opt_Out__c = true;
        ext.optOut();
        System.assertEquals(true, ext.getOptedOut(), 'Opted out');
        System.assertEquals(true, ext.getMinSelected(), 'Min election preserved through opt-out');
        System.assertEquals(false, ext.getMaxSelected(), 'Max still unset');
        System.assertEquals(0, ext.getMinus5Pct(), 'No 5% reduction when opted out');
        System.assertEquals(0, ext.getMinus10Pct(), 'No 10% reduction when opted out');
        System.assertEquals(ext.getMonthlyAnnuity(), ext.getReducedMin(), 'Reduced = full annuity when opted out');
        System.assertEquals(ext.getMonthlyAnnuity(), ext.getReducedMax(), 'Reduced = full annuity when opted out');
        System.assertEquals(0, ext.getSurvivingSpouseMin(), 'Surviving spouse min $0 when opted out');
        System.assertEquals(0, ext.getSurvivingSpouseMax(), 'Surviving spouse max $0 when opted out');
        Test.stopTest();
    }

    @isTest
    static void testManualOverrideDrivesAnnuity() {
        // A manual YOS override (entered on the FERS-Calc page and stored in the
        // shared Flow-safe field) must flow through to the survivor-page annuity.
        Lead l = FedWorkbook_TestData.fersBefore62();   // S1 primary, age 60, High-3 100k
        l.Scenario1_YOS_Manual__c = 40;                 // override the Flow's 25
        update l;
        Test.startTest();
        FedWorkbook_FersSurvivorExt ext =
            new FedWorkbook_FersSurvivorExt(FedWorkbook_TestData.sc(l.Id));
        // Age 60 (<62) => 1.0% factor; (100000 * 0.01 * 40) / 12
        Decimal expected = (100000 * 0.01 * 40) / 12;
        System.assertEquals(expected, ext.getS1MonthlyRetirementAnnuity(),
            'Manual YOS override drives the survivor-page monthly retirement annuity');
        System.assertEquals(expected, ext.getMonthlyAnnuity(),
            'Override also drives the primary-scenario survivor benefit annuity');
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
