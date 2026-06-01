@isTest
private class FedWorkbook_TspResourcesExtTest {

    @isTest
    static void testTotalContribution() {
        Lead l = FedWorkbook_TestData.fersBefore62();
        Test.startTest();
        FedWorkbook_TspResourcesExt ext =
            new FedWorkbook_TspResourcesExt(FedWorkbook_TestData.sc(l.Id));
        // currentYear comes from TSP_Contribution__mdt custom metadata. The total
        // is the sum of the regular + catch-up limits (0 when no metadata exists).
        System.assertNotEquals(null, ext.getTotalContribution(), 'Total contribution computes');
        Test.stopTest();
    }

    @isTest
    static void testNullId() {
        Test.startTest();
        FedWorkbook_TspResourcesExt ext =
            new FedWorkbook_TspResourcesExt(new ApexPages.StandardController(new Lead()));
        System.assertNotEquals(null, ext.getTotalContribution(), 'Computes without a Lead Id');
        Test.stopTest();
    }
}
