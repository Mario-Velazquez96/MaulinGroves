@isTest
private class FedWorkbook_FersCalcExtTest {

    private static void exerciseAll(FedWorkbook_FersCalcExt ext) {
        System.assertNotEquals(null, ext.getCurrentAge(), 'Current age');
        System.assertNotEquals(null, ext.getExpectedRetirementAge(), 'Expected retirement age');
        System.assertNotEquals(null, ext.getCurrentYOS(), 'Current YOS');
        System.assertNotEquals(null, ext.getCurrentBasePay(), 'Current base pay');
        System.assertNotEquals(null, ext.getS1HasRetAge(), 'S1 has ret age');
        System.assertNotEquals(null, ext.getS2HasRetAge(), 'S2 has ret age');
        System.assertNotEquals(null, ext.getS1ProjectedYOS(), 'S1 projected YOS');
        System.assertNotEquals(null, ext.getS2ProjectedYOS(), 'S2 projected YOS');
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
    static void testPrimaryAndAgeActions() {
        // Scenario 1 retiring before 62, Scenario 2 with a retirement age set,
        // so both primary checkboxes render and the age/primary actions run.
        Lead l = FedWorkbook_TestData.fersBefore62();
        l.Scenario2_Retirement_Age__c = 63;
        update l;

        Test.startTest();
        FedWorkbook_FersCalcExt ext = new FedWorkbook_FersCalcExt(FedWorkbook_TestData.sc(l.Id));
        System.assertEquals(true, ext.getS1HasRetAge(), 'S1 retirement age is set');
        System.assertEquals(true, ext.getS2HasRetAge(), 'S2 retirement age is set');

        // Retirement-age change seeds the projected YOS onto the YOS field.
        ext.saveS1Age();
        ext.saveS2Age();
        System.assertEquals(ext.getS1ProjectedYOS(), ext.getS1YearsOfService(),
            'saveS1Age seeds Scenario1_YOS__c with the projected YOS');

        // Selecting Scenario 2 primary clears Scenario 1 primary.
        ext.lead.Scenario2_Primary__c = true;
        ext.setPrimary2();
        System.assertEquals(false, ext.lead.Scenario1_Primary__c,
            'Primary selection is mutually exclusive');

        ext.lead.Scenario1_Primary__c = true;
        ext.setPrimary1();
        System.assertEquals(false, ext.lead.Scenario2_Primary__c,
            'Selecting Scenario 1 primary clears Scenario 2');
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
