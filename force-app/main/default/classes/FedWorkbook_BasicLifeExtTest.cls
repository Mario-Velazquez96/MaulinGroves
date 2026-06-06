/**
 * FedWorkbook_BasicLifeExtTest
 *
 * Covers FedWorkbook_BasicLifeExt — saveLead() plus the Extra Benefit /
 * Total Current Benefit / Years Remaining computations used by the
 * rebranded Basic Life page.
 */
@isTest
private class FedWorkbook_BasicLifeExtTest {

    @isTest
    static void testSaveStartingAge() {
        // Manual-age lead (FEGLI code path absent) — the page exposes the
        // editable Starting Age (Age_Option_Basic_Manual__c) for this case.
        Lead l = FedWorkbook_TestData.fegliManual();

        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(l);
        FedWorkbook_BasicLifeExt ext = new FedWorkbook_BasicLifeExt(sc);

        // Simulate the user entering a Starting Age, then auto-saving.
        l.Age_Option_Basic_Manual__c = FedWorkbook_TestData.pickVal(
            Lead.Age_Option_Basic_Manual__c,
            new Set<String>{ '41', '40', '36' }, '41');
        PageReference ref = ext.saveLead();
        Test.stopTest();

        System.assertEquals(null, ref, 'saveLead returns null (stays on page)');
        System.assert(!ApexPages.hasMessages(ApexPages.Severity.ERROR),
            'saveLead should not produce errors');

        Lead reloaded = [SELECT Age_Option_Basic_Manual__c FROM Lead WHERE Id = :l.Id];
        System.assertEquals(l.Age_Option_Basic_Manual__c,
            reloaded.Age_Option_Basic_Manual__c,
            'Starting Age should be persisted by saveLead');
    }

    @isTest
    static void testManualAgeComputations() {
        // Manual path with a numeric Starting Age: Extra Benefit and Years
        // Remaining are driven off that age.
        Lead l = FedWorkbook_TestData.fegliManual();
        l.Age_Option_Basic_Manual__c = FedWorkbook_TestData.pickVal(
            Lead.Age_Option_Basic_Manual__c,
            new Set<String>{ '41', '40', '36' }, '41');
        update l;

        FedWorkbook_BasicLifeExt ext = new FedWorkbook_BasicLifeExt(
            new ApexPages.StandardController(new Lead(Id = l.Id)));

        Lead q = [SELECT formula_basePay__c FROM Lead WHERE Id = :l.Id];
        Decimal bia = (q.formula_basePay__c == null ? 0 : q.formula_basePay__c) + 2000;
        Decimal age = Decimal.valueOf(ext.getLeadRecord().Age_Option_Basic_Manual__c);

        System.assertNotEquals(null, ext.getExtraBenefit(),
            'Extra benefit is computed for a numeric age <= 44');
        System.assertEquals(bia + ext.getExtraBenefit(), ext.getTotalCurrentBenefit(),
            'Total Current Benefit = BIA + Extra Benefit');
        System.assertEquals(true, ext.getShowYearsRemaining(),
            'Years Remaining shown for ages 36..45');
        System.assertEquals(45 - age, ext.getExtraBenefitYearsRemaining(),
            'Years Remaining = 45 - age');
    }

    @isTest
    static void testUnder35ManualAge() {
        // "Under 35" -> full 1.0 factor, but Years Remaining is not shown
        // (legacy only shows it for ages 36..45).
        Lead l = FedWorkbook_TestData.fegliManual();
        l.Age_Option_Basic_Manual__c = FedWorkbook_TestData.pickVal(
            Lead.Age_Option_Basic_Manual__c, new Set<String>{ 'Under 35' }, 'Under 35');
        update l;

        FedWorkbook_BasicLifeExt ext = new FedWorkbook_BasicLifeExt(
            new ApexPages.StandardController(new Lead(Id = l.Id)));

        Lead q = [SELECT formula_basePay__c FROM Lead WHERE Id = :l.Id];
        Decimal bia = (q.formula_basePay__c == null ? 0 : q.formula_basePay__c) + 2000;

        if (ext.getLeadRecord().Age_Option_Basic_Manual__c == 'Under 35') {
            System.assertEquals(bia, ext.getExtraBenefit(),
                'Under 35 uses the full 1.0 factor (Extra Benefit == BIA)');
            System.assertEquals(false, ext.getShowYearsRemaining(),
                'Years Remaining not shown for Under 35');
        }
    }

    @isTest
    static void testCodePathOver44() {
        // FEGLI code present with Contact Age > 44 -> no extra benefit,
        // Total Current Benefit == BIA, Years Remaining hidden.
        Lead l = FedWorkbook_TestData.fegliWithCode(); // DOB = 47 years ago

        FedWorkbook_BasicLifeExt ext = new FedWorkbook_BasicLifeExt(
            new ApexPages.StandardController(new Lead(Id = l.Id)));

        Lead q = [SELECT formula_basePay__c, Contact_Age__c FROM Lead WHERE Id = :l.Id];
        Decimal bia = (q.formula_basePay__c == null ? 0 : q.formula_basePay__c) + 2000;

        if (q.Contact_Age__c != null && q.Contact_Age__c > 44) {
            System.assertEquals(null, ext.getExtraBenefit(),
                'No extra benefit above age 44');
            System.assertEquals(bia, ext.getTotalCurrentBenefit(),
                'Total Current Benefit falls back to BIA above age 44');
            System.assertEquals(false, ext.getShowYearsRemaining(),
                'Years Remaining hidden above age 45');
        }
    }

    @isTest
    static void testSaveErrorIsCaught() {
        // Deleting the record before saving forces update to fail, exercising
        // the catch branch (the error is surfaced as a page message, not thrown).
        Lead l = FedWorkbook_TestData.fegliManual();
        ApexPages.StandardController sc = new ApexPages.StandardController(l);
        FedWorkbook_BasicLifeExt ext = new FedWorkbook_BasicLifeExt(sc);
        delete l;

        Test.startTest();
        PageReference ref = ext.saveLead();
        Test.stopTest();

        System.assertEquals(null, ref, 'saveLead returns null even on error');
        System.assert(ApexPages.hasMessages(ApexPages.Severity.ERROR),
            'saveLead should surface the update failure as a page message');
    }
}
