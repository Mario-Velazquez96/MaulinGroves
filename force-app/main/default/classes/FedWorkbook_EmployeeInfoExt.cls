/**
 * FedWorkbook_EmployeeInfoExt
 *
 * Extension for the rebranded Federal Workbook page 2
 * (FedWorkbook_EmployeeInfo).
 *
 * Purpose:
 *  - Exposes the Lead's date fields as controller properties so the page
 *    can use native HTML5 date pickers via <apex:input type="date">.
 *  - Maps four FEGLI Plan checkboxes onto the FEGLI_Plan__c multi-select
 *    picklist (each checkbox toggles one value in the picklist).
 *  - Provides saveLead() — an explicit auto-save with error handling.
 *
 * All getters/setters and saveLead() ALWAYS read the live record from the
 * standard controller (stdCtrl.getRecord()) rather than caching a copy,
 * which can drift across Visualforce view-state round-trips.
 */
public with sharing class FedWorkbook_EmployeeInfoExt {

    private final ApexPages.StandardController stdCtrl;

    // FEGLI_Plan__c multi-select picklist values, in display order.
    private static final List<String> FEGLI_PLAN_ORDER =
        new List<String>{ 'Basic', 'Option A', 'Option B', 'Option C' };

    public FedWorkbook_EmployeeInfoExt(ApexPages.StandardController stdController) {
        this.stdCtrl = stdController;
        // Fields bound through this extension (not {!Lead.x}) must be added
        // explicitly so the standard controller includes them in its query.
        // addFields() is only valid on a page-created controller; when a record
        // is passed in directly (e.g. unit tests) it throws — in that case the
        // caller already supplied the fields, so the exception is safe to ignore.
        try {
            stdController.addFields(new List<String>{
                'Date_of_Hire__c',
                'Date_of_Birth__c',
                'Expected_Retirement_Date__c',
                'FEGLI_Plan__c'
            });
        } catch (Exception e) {
            // Record provided by caller — fields are already available.
        }
    }

    // Always the standard controller's CURRENT record — never a cached copy.
    private Lead liveLead() {
        return (Lead) stdCtrl.getRecord();
    }

    // ----- Date pickers ----------------------------------------------------
    public Date getHireDate()             { return liveLead().Date_of_Hire__c; }
    public void setHireDate(Date value)   { liveLead().Date_of_Hire__c = value; }

    public Date getBirthDate()            { return liveLead().Date_of_Birth__c; }
    public void setBirthDate(Date value)  { liveLead().Date_of_Birth__c = value; }

    public Date getRetireDate()           { return liveLead().Expected_Retirement_Date__c; }
    public void setRetireDate(Date value) { liveLead().Expected_Retirement_Date__c = value; }

    // ----- FEGLI Plan: checkboxes <-> FEGLI_Plan__c multi-select picklist --
    // FEGLI_Plan__c stores a semicolon-delimited string. Each checkbox
    // toggles one value within it.

    private Boolean planHas(String val) {
        String current = liveLead().FEGLI_Plan__c;
        if (String.isBlank(current)) { return false; }
        for (String part : current.split(';')) {
            if (part.trim() == val) { return true; }
        }
        return false;
    }

    private void planSet(String val, Boolean isOn) {
        Set<String> selected = new Set<String>();
        String current = liveLead().FEGLI_Plan__c;
        if (String.isNotBlank(current)) {
            for (String part : current.split(';')) {
                selected.add(part.trim());
            }
        }
        if (isOn == true) { selected.add(val); }
        else { selected.remove(val); }

        // Rebuild in a stable display order.
        List<String> ordered = new List<String>();
        for (String opt : FEGLI_PLAN_ORDER) {
            if (selected.contains(opt)) { ordered.add(opt); }
        }
        liveLead().FEGLI_Plan__c = String.join(ordered, ';');
    }

    public Boolean getPlanBasic()             { return planHas('Basic'); }
    public void    setPlanBasic(Boolean v)    { planSet('Basic', v); }

    public Boolean getPlanOptionA()           { return planHas('Option A'); }
    public void    setPlanOptionA(Boolean v)  { planSet('Option A', v); }

    public Boolean getPlanOptionB()           { return planHas('Option B'); }
    public void    setPlanOptionB(Boolean v)  { planSet('Option B', v); }

    public Boolean getPlanOptionC()           { return planHas('Option C'); }
    public void    setPlanOptionC(Boolean v)  { planSet('Option C', v); }

    // ----- Save ------------------------------------------------------------
    /**
     * Auto-save invoked by every editable field's onchange handler.
     * Saves the same record instance the page binds to, so dates, the
     * FEGLI plan picklist, and the {!Lead.x} fields persist together.
     */
    public PageReference saveLead() {
        try {
            Lead toSave = liveLead();
            update toSave;
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(
                ApexPages.Severity.ERROR, e.getMessage()));
        }
        return null;
    }
}
