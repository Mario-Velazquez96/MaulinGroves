public with sharing class FedWorkbook_PreviewExt {

    private final ApexPages.StandardController stdCtrl;

    public FedWorkbook_PreviewExt(ApexPages.StandardController stdController) {
        this.stdCtrl = stdController;
    }

    // -----------------------------------------------------------------------
    // saveAttachment()
    // Rebrand equivalent of Federal_LeadControllerExtension.pdfAction():
    //   - bumps Lead.Workbook_Version__c,
    //   - renders FedWorkbook_PDF to a PDF Blob,
    //   - saves it as a ContentVersion linked to the Lead,
    //   - redirects to the Lead record.
    // -----------------------------------------------------------------------
    public PageReference saveAttachment() {
        Id leadId = stdCtrl.getId();
        if (leadId == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                'No Lead context — open the preview with ?id=<LeadId> to save the workbook.'));
            return null;
        }

        try {
            Lead currentClient = [SELECT Id, Workbook_Version__c FROM Lead WHERE Id = :leadId];
            if (currentClient.Workbook_Version__c == null) {
                currentClient.Workbook_Version__c = 1.0;
            }
            String pdfTitle = 'Groves Federal Retirement Planning Workbook_v'
                + currentClient.Workbook_Version__c + '_' + String.valueOf(System.today());
            currentClient.Workbook_Version__c++;
            update currentClient;

            PageReference savePage = Page.FedWorkbook_PDF;
            savePage.getParameters().put('id', leadId);
            savePage.setRedirect(true);

            Blob pdfBlob = Test.isRunningTest()
                ? Blob.valueOf('UNIT.TEST')
                : savePage.getContent();

            ContentVersion pdf = new ContentVersion();
            pdf.Title = pdfTitle;
            pdf.VersionData = pdfBlob;
            pdf.ContentLocation = 'S';
            pdf.Origin = 'C';
            pdf.PathOnClient = pdfTitle + '.pdf';
            insert pdf;

            ContentVersion pdf2 = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :pdf.Id];

            ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.LinkedEntityId = leadId;
            cdl.ContentDocumentId = pdf2.ContentDocumentId;
            cdl.ShareType = 'V';
            cdl.Visibility = 'AllUsers';
            insert cdl;

            PageReference pageRef = new PageReference('/' + leadId);
            pageRef.setRedirect(true);
            return pageRef;

        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            return null;
        }
    }
}
