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

    @isTest
    static void testReseedYosOnOpen() {
        // Opening the workbook reseeds the manual YOS overrides from the Flow values,
        // discarding any stale override left from a previous session, then redirects
        // once (?yosSeeded=1) so the sections re-read the committed values.
        Lead l = FedWorkbook_TestData.fersBefore62();   // Scenario1_YOS__c = 25, Scenario2_YOS__c = 0
        l.Scenario1_YOS_Manual__c = 99;                 // stale override
        update l;

        PageReference pr = new PageReference('/apex/FedWorkbook_Preview');
        pr.getParameters().put('id', l.Id);
        Test.setCurrentPage(pr);

        Test.startTest();
        FedWorkbook_PreviewExt ext =
            new FedWorkbook_PreviewExt(FedWorkbook_TestData.sc(l.Id));
        PageReference ref = ext.reseedYosOnOpen();
        Test.stopTest();

        Lead fresh = [SELECT Scenario1_YOS_Manual__c, Scenario2_YOS_Manual__c
                      FROM Lead WHERE Id = :l.Id];
        System.assertEquals(25, fresh.Scenario1_YOS_Manual__c,
            'Opening reseeds Scenario1 override from Scenario1_YOS__c');
        System.assertEquals(0, fresh.Scenario2_YOS_Manual__c,
            'Opening reseeds Scenario2 override from Scenario2_YOS__c');
        System.assertNotEquals(null, ref, 'Reseed should redirect to re-read committed values');
        System.assertEquals('1', ref.getParameters().get('yosSeeded'),
            'Redirect carries the yosSeeded marker to avoid reseeding again');
    }

    @isTest
    static void testReseedSkippedWhenAlreadySeeded() {
        // The post-reseed redirect (?yosSeeded=1) must not reseed again (no loop).
        Lead l = FedWorkbook_TestData.fersBefore62();
        l.Scenario1_YOS_Manual__c = 44;
        update l;

        PageReference pr = new PageReference('/apex/FedWorkbook_Preview');
        pr.getParameters().put('yosSeeded', '1');
        Test.setCurrentPage(pr);

        Test.startTest();
        FedWorkbook_PreviewExt ext =
            new FedWorkbook_PreviewExt(FedWorkbook_TestData.sc(l.Id));
        PageReference ref = ext.reseedYosOnOpen();
        Test.stopTest();

        System.assertEquals(null, ref, 'Already-seeded request renders normally (no redirect)');
        Lead fresh = [SELECT Scenario1_YOS_Manual__c FROM Lead WHERE Id = :l.Id];
        System.assertEquals(44, fresh.Scenario1_YOS_Manual__c, 'Override preserved on the seeded request');
    }

    @isTest
    static void testReseedSkippedOnYosEditReload() {
        // The post-edit reload carries ?yosEdited=1; the reseed must be skipped so
        // the just-entered override is preserved.
        Lead l = FedWorkbook_TestData.fersBefore62();   // Scenario1_YOS__c = 25
        l.Scenario1_YOS_Manual__c = 44;                 // user's just-entered value
        update l;

        PageReference pr = new PageReference('/apex/FedWorkbook_Preview');
        pr.getParameters().put('yosEdited', '1');
        Test.setCurrentPage(pr);

        Test.startTest();
        FedWorkbook_PreviewExt ext =
            new FedWorkbook_PreviewExt(FedWorkbook_TestData.sc(l.Id));
        ext.reseedYosOnOpen();
        Test.stopTest();

        Lead fresh = [SELECT Scenario1_YOS_Manual__c FROM Lead WHERE Id = :l.Id];
        System.assertEquals(44, fresh.Scenario1_YOS_Manual__c,
            'On the post-edit reload the override is preserved (not reseeded)');
    }

    @isTest
    static void testReseedNullIdNoOp() {
        Test.startTest();
        FedWorkbook_PreviewExt ext =
            new FedWorkbook_PreviewExt(new ApexPages.StandardController(new Lead()));
        PageReference ref = ext.reseedYosOnOpen();
        Test.stopTest();
        System.assertEquals(null, ref, 'No Lead context is a no-op');
    }
}
