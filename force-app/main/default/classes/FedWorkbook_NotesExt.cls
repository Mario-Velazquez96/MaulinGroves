public with sharing class FedWorkbook_NotesExt {

    private final ApexPages.StandardController stdCtrl;

    public FedWorkbook_NotesExt(ApexPages.StandardController stdController) {
        this.stdCtrl = stdController;
    }

    // -----------------------------------------------------------------------
    // saveNotes()
    // Persists the edited Lead (Description) and returns null so the page
    // stays put. Using the StandardController's own save() would redirect to
    // the record detail page, which is why the Notes textarea calls this
    // instead. The bound {!Lead.Description} edits live on the same record
    // returned by getRecord(), so a plain update commits them.
    // -----------------------------------------------------------------------
    public PageReference saveNotes() {
        try {
            update stdCtrl.getRecord();
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }
        return null;
    }
}
