@isTest
private class FedWorkbook_PDFExtTest {

    private static void exerciseAll(FedWorkbook_PDFExt ext) {
        // Page 2 — FEGLI plan checkbox marks
        ext.getPlanBasicMark();
        ext.getPlanOptionAMark();
        ext.getPlanOptionBMark();
        ext.getPlanOptionCMark();

        // Page 4 — Option A / C
        ext.getAcOptionACost();
        ext.getAcOptionCMultiples();
        ext.getAcOptionCBiWeeklyFactor();

        // Page 5 — Option B + Total summary
        ext.getObHasOptionA();
        ext.getObHasOptionB();
        ext.getObHasOptionC();
        ext.getObAnnualRatePay();
        ext.getObMultiplier();
        ext.getObOptionBCoverage();
        ext.getObOptionBBiWeeklyCost();
        ext.getObOptionBMonthlyCost();
        ext.getObBasicCoverage();
        ext.getObBasicBiWeeklyCost();
        ext.getObOptionACoverage();
        ext.getObOptionABiWeeklyCost();
        ext.getObOptionCBiWeeklyCost();
        ext.getObTotalCoverage();
        ext.getObTotalBiWeeklyCost();
        ext.getObTotalMonthlyCost();

        // Page 7 — Calculating FERS
        ext.getFcCurrentAge();
        ext.getFcS1RetirementAge();
        ext.getFcS1YearsOfService();
        ext.getFcS1HighThree();
        ext.getFcS1Factor();
        ext.getFcS1FactorTimesHighThree();
        ext.getFcS1AnnualAnnuity();
        ext.getFcS1MonthlyAnnuity();
        ext.getFcS2RetirementAge();
        ext.getFcS2YearsOfService();
        ext.getFcS2HighThree();
        ext.getFcS2Factor();
        ext.getFcS2FactorTimesHighThree();
        ext.getFcS2AnnualAnnuity();
        ext.getFcS2MonthlyAnnuity();

        // Page 8 — Survivor
        ext.getFsS1CurrentMonthlyIncome();
        ext.getFsS1MonthlyRetirementAnnuity();
        ext.getFsS1DifferenceInMonthlyAnnuity();
        ext.getFsS2CurrentMonthlyIncome();
        ext.getFsS2MonthlyRetirementAnnuity();
        ext.getFsS2DifferenceInMonthlyAnnuity();
        ext.getFsMonthlyAnnuity();
        ext.getFsMinus5Pct();
        ext.getFsReducedMin();
        ext.getFsSurvivingSpouseMin();
        ext.getFsMinus10Pct();
        ext.getFsReducedMax();
        ext.getFsSurvivingSpouseMax();

        // Page 9 — Special Groups
        ext.getSgFactor17xHigh3();
        ext.getSgBlock20YearAnnuity();
        ext.getSgFactor01xHigh3();
        ext.getSgFactor01xRemainingAnnuity();
        ext.getSgTotalAnnual();
        ext.getSgTotalMonthly();

        // Page 10 — Special Supplement
        ext.getSsSupplementPct();
        ext.getSsSupplementDollars();
        ext.getSsShowSpecialSupp();

        // Page 11 — TSP
        ext.getTspTotalContribution();
        ext.getTspRegularLimit();
        ext.getTspCatchUpLimit();

        // Page 12 — Financial Snapshot
        ext.getSnapSocialSecurityEligible();
        ext.getSnapPensionBase();
        ext.getSnapSurvivingSpouseBenefit();
        ext.getSnapIsMarried();
        ext.getSnapSpouseBenefitOptedOut();
        ext.getSnapExpenseTotal();
        ext.getSnapYosPercent();
        ext.getSnapYosFormulaVisible();
        ext.getSnapFersSupplementDisplay();
        ext.getSnapFersSupplementEligible();
        ext.getSnapTspDisplay();
        ext.getSnapIncomeTotal();
        ext.getSnapDifference();
        System.assertNotEquals(null, ext.getSnapBottomLine(), 'Bottom line should compute');
    }

    @isTest
    static void testFersLead() {
        Lead l = FedWorkbook_TestData.fersBefore62();
        Test.startTest();
        exerciseAll(new FedWorkbook_PDFExt(FedWorkbook_TestData.sc(l.Id)));
        Test.stopTest();
    }

    @isTest
    static void testFegliLead() {
        Lead l = FedWorkbook_TestData.fegliWithCode();
        Test.startTest();
        exerciseAll(new FedWorkbook_PDFExt(FedWorkbook_TestData.sc(l.Id)));
        Test.stopTest();
    }

    @isTest
    static void testSpecialGroupLead() {
        Lead l = FedWorkbook_TestData.specialGroup();
        Test.startTest();
        exerciseAll(new FedWorkbook_PDFExt(FedWorkbook_TestData.sc(l.Id)));
        Test.stopTest();
    }
}
