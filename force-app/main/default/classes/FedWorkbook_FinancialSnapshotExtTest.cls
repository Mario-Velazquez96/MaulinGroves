@isTest
private class FedWorkbook_FinancialSnapshotExtTest {

    private static void exerciseAll(FedWorkbook_FinancialSnapshotExt ext) {
        System.assertNotEquals(null, ext.getSocialSecurityEligible(), 'SS eligible');
        System.assertNotEquals(null, ext.getSocialSecurityStartAge(), 'SS start age');
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
        System.assertNotEquals(null, ext.getTotalTaxes(), 'Total taxes');
        System.assertNotEquals(null, ext.getTspPreTaxTotal(), 'TSP pre-tax total');
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
    static void testSocialSecurityStartAgeFollowsEligibilityCriteria() {
        // FERS with a primary scenario → start age is the scenario retirement age.
        Lead fers = FedWorkbook_TestData.fersBefore62(); // Scenario1_Primary, age 60
        FedWorkbook_FinancialSnapshotExt fersExt =
            new FedWorkbook_FinancialSnapshotExt(FedWorkbook_TestData.sc(fers.Id));
        System.assertEquals(60, fersExt.getSocialSecurityStartAge(),
            'FERS primary scenario => scenario retirement age');

        // Special Group member WITH a primary scenario → must IGNORE the scenario
        // age and use the date-derived expected retirement age, matching getSocialSecurityEligible.
        Lead sg = new Lead(
            LastName = 'SgScenario', Company = 'Fed Agency',
            Special_Group_Member__c = true, FERS__c = true,
            High_3_Salary__c = 115000, Remaining_Years__c = 3,
            Scenario1_Primary__c = true, Scenario1_Retirement_Age__c = 58,
            Date_of_Birth__c = System.today().addYears(-53),
            Date_of_Hire__c = System.today().addYears(-23),
            Expected_Retirement_Date__c = System.today().addYears(-1)
        );
        insert sg;
        FedWorkbook_FinancialSnapshotExt sgExt =
            new FedWorkbook_FinancialSnapshotExt(FedWorkbook_TestData.sc(sg.Id));
        Decimal derivedAge = FedWorkbook_Util.expectedRetirementAge(sgExt.lead);
        Decimal expectedAge = derivedAge == null ? 0 : derivedAge;
        System.assertEquals(expectedAge, sgExt.getSocialSecurityStartAge(),
            'Special Group => date-derived expected retirement age, not the primary scenario age');
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
