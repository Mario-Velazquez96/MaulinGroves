@isTest
private class FedWorkbook_SpecialGroupsExtTest {

    @isTest
    static void testCalculations() {
        Lead l = FedWorkbook_TestData.specialGroup();
        Test.startTest();
        FedWorkbook_SpecialGroupsExt ext =
            new FedWorkbook_SpecialGroupsExt(FedWorkbook_TestData.sc(l.Id));
        System.assertEquals(115000 * 0.017, ext.getFactor17xHigh3(), '1.7% x high-3');
        System.assertEquals(115000 * 0.017 * 20, ext.getBlock20YearAnnuity(), '20-year block');
        System.assertEquals(115000 * 0.01, ext.getFactor01xHigh3(), '1% x high-3');
        System.assertEquals(115000 * 0.01 * 3, ext.getFactor01xRemainingAnnuity(), '1% x remaining');
        System.assertNotEquals(null, ext.getTotalAnnual(), 'Total annual');
        System.assertEquals(ext.getTotalAnnual() / 12, ext.getTotalMonthly(), 'Total monthly = annual/12');
        ext.saveLead();
        Test.stopTest();
    }

    @isTest
    static void testNullId() {
        Test.startTest();
        FedWorkbook_SpecialGroupsExt ext =
            new FedWorkbook_SpecialGroupsExt(new ApexPages.StandardController(new Lead()));
        System.assertEquals(0, ext.getFactor17xHigh3(), 'No data => 0');
        System.assertEquals(0, ext.getTotalMonthly(), 'No data => 0 monthly');
        Test.stopTest();
    }
}
