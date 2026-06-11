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
        System.assertNotEquals(null, ext.getShowCurrentAge(), 'Show Current Age');
        System.assertNotEquals(null, ext.getShowStartingAge(), 'Show Starting Age');
        System.assertNotEquals(null, ext.getShowMultiplierManual(), 'Show manual multiplier');
    }

    @isTest
    static void testWithFegliCode() {
        Lead l = FedWorkbook_TestData.fegliWithCode();
        Test.startTest();
        FedWorkbook_OptionBExt ext = new FedWorkbook_OptionBExt(FedWorkbook_TestData.sc(l.Id));
        exerciseAll(ext);
        // Code on file => locked Current Age + derived multiplier.
        System.assertEquals(true, ext.getShowCurrentAge(), 'Coded => Current Age');
        System.assertEquals(false, ext.getShowStartingAge(), 'Coded => no Starting Age');
        System.assertEquals(false, ext.getShowMultiplierManual(), 'Coded => derived multiplier');
        Test.stopTest();
    }

    @isTest
    static void testManualBands() {
        Lead l = FedWorkbook_TestData.fegliManual();
        Test.startTest();
        FedWorkbook_OptionBExt ext = new FedWorkbook_OptionBExt(FedWorkbook_TestData.sc(l.Id));
        exerciseAll(ext);
        // No code => editable Starting Age + manual multiplier.
        System.assertEquals(true, ext.getShowStartingAge(), 'Manual => Starting Age');
        System.assertEquals(false, ext.getShowCurrentAge(), 'Manual => no Current Age');
        System.assertEquals(true, ext.getShowMultiplierManual(), 'Manual => editable multiplier');
        Test.stopTest();
    }

    @isTest
    static void testProjectionAndActions() {
        Lead l = FedWorkbook_TestData.fegliManual();
        // Years_*__c are restricted picklists; resolve valid values via describe.
        l.Years_34__c = FedWorkbook_TestData.pickVal(
            Lead.Years_34__c, new Set<String>{ '5', '4', '3', '2', '1' }, '5');
        l.Years_80__c = FedWorkbook_TestData.pickVal(
            Lead.Years_80__c, new Set<String>{ '3', '2', '1' }, '3');
        l.Standard_Monthly__c = 25;
        update l;

        Test.startTest();
        // Pass the populated record so live() (the projection's editable source)
        // sees the Years / premium values, as it would on the live page.
        FedWorkbook_OptionBExt ext =
            new FedWorkbook_OptionBExt(new ApexPages.StandardController(l));

        Decimal expectedYears = Decimal.valueOf(l.Years_34__c) + Decimal.valueOf(l.Years_80__c);
        System.assertEquals(11, ext.getProjectionRows().size(), '11 projection bands');
        System.assertEquals(expectedYears, ext.getProjTotalYears(), 'Years summed from live record');
        System.assertNotEquals(null, ext.getProjFegliTotal(), 'FEGLI total');
        System.assertNotEquals(null, ext.getProjAltTotal(), 'Alternative total');
        System.assertNotEquals(null, ext.getProjSavings(), 'Savings');
        System.assertNotEquals(null, ext.getCurrentBenefit(), 'Current benefit');
        System.assertNotEquals(null, ext.getLeadRecord(), 'Lead record');

        ext.saveLead();
        ext.lockStartingAge();
        System.assertEquals(true, ext.getStartingAgeLocked(), 'Locked after lock');
        ext.unlockStartingAge();
        System.assertEquals(false, ext.getStartingAgeLocked(), 'Unlocked');
        ext.resetProjection();
        System.assertEquals(0, ext.getProjTotalYears(), 'Reset clears years');
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
