@isTest
private class FedWorkbook_PreviewExtTest {

    @isTest
    static void testSaveAttachment() {
        Lead l = FedWorkbook_TestData.fersBefore62();

        Test.startTest();
        FedWorkbook_PreviewExt ext =
            new FedWorkbook_PreviewExt(FedWorkbook_TestData.sc(l.Id));
        PageReference ref = ext.saveAttachment();
        Test.stopTest();

        System.assertNotEquals(null, ref, 'saveAttachment should redirect to the Lead');
        System.assert(ref.getUrl().contains(l.Id), 'Redirect should target the Lead record');

        // The version number is bumped and a PDF document is linked to the Lead.
        Lead reloaded = [SELECT Workbook_Version__c FROM Lead WHERE Id = :l.Id];
        System.assertNotEquals(null, reloaded.Workbook_Version__c, 'Workbook version should be set');

        List<ContentDocumentLink> links = [
            SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :l.Id
        ];
        System.assertEquals(1, links.size(), 'Exactly one PDF should be linked to the Lead');
    }

    @isTest
    static void testNullIdContext() {
        Test.startTest();
        FedWorkbook_PreviewExt ext =
            new FedWorkbook_PreviewExt(new ApexPages.StandardController(new Lead()));
        PageReference ref = ext.saveAttachment();
        Test.stopTest();

        System.assertEquals(null, ref, 'No Lead context should return null');
        System.assert(ApexPages.hasMessages(), 'A missing Lead context should add an error message');
    }
}
