@isTest
private class FedWorkbook_NotesExtTest {

    @isTest
    static void testSaveNotes() {
        Lead l = FedWorkbook_TestData.fersBefore62();

        Test.startTest();
        // Mirror the page: the standard controller loads the record, the bound
        // Description edit lives on it, and saveNotes() commits without redirect.
        ApexPages.StandardController std = new ApexPages.StandardController(l);
        FedWorkbook_NotesExt ext = new FedWorkbook_NotesExt(std);
        Lead bound = (Lead) std.getRecord();
        bound.Description = 'Updated notes from the workbook';
        PageReference result = ext.saveNotes();
        Test.stopTest();

        System.assertEquals(null, result, 'saveNotes should return null (stay on page)');
        Lead reloaded = [SELECT Description FROM Lead WHERE Id = :l.Id];
        System.assertEquals('Updated notes from the workbook', reloaded.Description,
            'Description should persist');
    }

    @isTest
    static void testSaveNotesError() {
        Test.startTest();
        // A Lead with no Id cannot be updated; the exception is caught and surfaced.
        FedWorkbook_NotesExt ext =
            new FedWorkbook_NotesExt(new ApexPages.StandardController(new Lead()));
        ext.saveNotes();
        Test.stopTest();
        System.assert(ApexPages.hasMessages(), 'Saving without an Id should add an error message');
    }
}
