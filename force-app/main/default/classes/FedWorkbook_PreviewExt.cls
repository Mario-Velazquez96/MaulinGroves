public with sharing class FedWorkbook_PreviewExt {

    private final ApexPages.StandardController stdCtrl;

    public FedWorkbook_PreviewExt(ApexPages.StandardController stdController) {
        this.stdCtrl = stdController;
    }

    // Expected retirement age (date-derived; see FedWorkbook_Util) — used by the
    // preview nav's Special Supplement render gate. Replaces the unreliable stored
    // Expected_Retirement_Age__c formula. Lazily queried/cached: the Preview page
    // composes sub-pages via apex:include, so the dates aren't otherwise loaded here.
    private Decimal expectedRetAge;
    private Boolean expectedRetAgeLoaded = false;
    public Decimal getExpectedRetirementAge() {
        if (!expectedRetAgeLoaded) {
            expectedRetAgeLoaded = true;
            Id leadId = stdCtrl.getId();
            if (leadId != null) {
                Lead l = [
                    SELECT Date_of_Birth__c, Expected_Retirement_Date__c
                    FROM Lead WHERE Id = :leadId LIMIT 1
                ];
                expectedRetAge = FedWorkbook_Util.expectedRetirementAge(l);
            }
        }
        return expectedRetAge;
    }

    // -----------------------------------------------------------------------
    // reseedYosOnOpen()
    // Invoked from the page's action= attribute. Each time the workbook is opened,
    // reset the editable "Times (x) Years of Service" overrides
    // (Scenario1/2_YOS_Manual__c) to the current Flow-computed values
    // (Scenario1/2_YOS__c).
    //
    // The action runs AFTER the apex:include section controllers have already
    // constructed and queried the Lead, so the reseed's DML isn't visible to them
    // on this render. To avoid that one-render lag we reseed and then redirect once
    // to the same page (?yosSeeded=1); on that clean request the sections re-query
    // and read the committed values.
    //
    // Skip markers:
    //   yosSeeded=1 — the post-reseed redirect (don't reseed again / no loop)
    //   yosEdited=1 — the reload after a manual YOS edit (preserve the entry)
    // -----------------------------------------------------------------------
    public PageReference reseedYosOnOpen() {
        Id leadId = stdCtrl.getId();
        if (leadId == null) { return null; }

        PageReference p = ApexPages.currentPage();
        Map<String, String> params = (p == null)
            ? new Map<String, String>() : p.getParameters();
        if (params.get('yosSeeded') == '1' || params.get('yosEdited') == '1') {
            return null; // already seeded this open, or preserving a manual edit
        }

        try {
            Lead l = [
                SELECT Scenario1_YOS__c, Scenario2_YOS__c,
                       Scenario1_YOS_Manual__c, Scenario2_YOS_Manual__c
                FROM Lead WHERE Id = :leadId LIMIT 1
            ];
            l.Scenario1_YOS_Manual__c = l.Scenario1_YOS__c;
            l.Scenario2_YOS_Manual__c = l.Scenario2_YOS__c;
            update l;
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            return null;
        }

        if (p == null) { return null; } // test context with no page — DML already done

        // Redirect to the same page so the included sections re-query the committed
        // overrides on a fresh request (their constructors run before this action).
        p.getParameters().put('yosSeeded', '1');
        p.setRedirect(true);
        return p;
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
