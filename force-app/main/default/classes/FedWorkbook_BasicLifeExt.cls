/**
 * FedWorkbook_BasicLifeExt
 *
 * Extension for the rebranded Federal Workbook page 3
 * (FedWorkbook_BasicLife).
 *
 * Purpose:
 *  - Provides saveLead() so the "Starting Age" input
 *    (Age_Option_Basic_Manual__c) persists when the FEGLI code is '--'
 *    (manual-age path), mirroring the legacy BasicLife.page behavior.
 *  - Computes the Extra Benefit (Age Multiplication Factor) amount, the
 *    Total Current Benefit, and the Extra Benefit Years Remaining directly
 *    from the age source — the manual Starting Age (code == '--') or the
 *    derived Contact Age (code set) — replicating the legacy page's inline
 *    factor math. This avoids depending on the Total_Basic_Benefit__c
 *    formula field (which returns null in some orgs) so the values update
 *    whenever the Starting Age changes.
 *
 * Read pattern: getters read a self-queried snapshot (this.lead) so the same
 * extension serves both the interactive page (re-queried after each save) and
 * the PDF (which delegates with a bare-Id record). saveLead() updates the
 * record the page's {!Lead.x} inputs bind to (stdCtrl.getRecord()).
 */
public with sharing class FedWorkbook_BasicLifeExt {

    private final ApexPages.StandardController stdCtrl;
    private final Id leadId;
    private Lead lead;

    public FedWorkbook_BasicLifeExt(ApexPages.StandardController stdController) {
        this.stdCtrl = stdController;
        this.leadId = stdController.getId();
        loadLead();
    }

    // Self-queried snapshot used for all computed getters.
    private void loadLead() {
        if (leadId == null) {
            this.lead = (Lead) stdCtrl.getRecord();
            return;
        }
        this.lead = [
            SELECT Basic__c, FEGLI_Code_Picklist__c, Contact_Age__c,
                   Age_Option_Basic_Manual__c, Base_Salary__c, formula_basePay__c
            FROM Lead WHERE Id = :leadId LIMIT 1
        ];
    }

    public Lead getLeadRecord() { return lead; }

    // ----- Age resolution --------------------------------------------------
    private Boolean codePath() {
        String code = lead.FEGLI_Code_Picklist__c;
        return code != null && code != '--' && code != '';
    }

    // Effective numeric age for the factor lookup; null when unknown.
    private Decimal effectiveAge() {
        if (codePath()) { return lead.Contact_Age__c; }
        String s = lead.Age_Option_Basic_Manual__c;
        if (String.isBlank(s)) { return null; }
        if (s == 'Under 35') { return 35; }
        try { return Decimal.valueOf(s.trim()); }
        catch (Exception e) { return null; }
    }

    // Age Multiplication Factor (1.0 at <=35 down to 0.1 at 44); null when the
    // age is unknown or above 44 (no extra benefit -> page shows "--").
    private Decimal extraFactor() {
        Decimal age = effectiveAge();
        if (age == null || age > 44) { return null; }
        if (age <= 35) { return 1.0; }
        if (age == 36) { return 0.9; }
        if (age == 37) { return 0.8; }
        if (age == 38) { return 0.7; }
        if (age == 39) { return 0.6; }
        if (age == 40) { return 0.5; }
        if (age == 41) { return 0.4; }
        if (age == 42) { return 0.3; }
        if (age == 43) { return 0.2; }
        return 0.1; // age == 44
    }

    // BIA Amount = Base Pay Round-Up + $2,000.
    private Decimal bia() {
        Decimal bp = lead.formula_basePay__c;
        return (bp == null ? 0 : bp) + 2000;
    }

    // ----- Computed values shown on the page -------------------------------
    /** Extra Benefit (Age 45 & under) dollar amount; null -> show "--". */
    public Decimal getExtraBenefit() {
        Decimal f = extraFactor();
        return (f == null) ? null : bia() * f;
    }

    /** Total Current Benefit = BIA + Extra Benefit (BIA alone when no extra). */
    public Decimal getTotalCurrentBenefit() {
        Decimal eb = getExtraBenefit();
        return (eb == null) ? bia() : bia() + eb;
    }

    /** Whether the Extra Benefit Years Remaining row should render. */
    public Boolean getShowYearsRemaining() {
        Decimal age = effectiveAge();
        if (age == null) { return false; }
        return codePath() ? (age <= 45) : (age >= 36 && age <= 45);
    }

    /** Years until age 45 (when extra-benefit coverage ends). */
    public Decimal getExtraBenefitYearsRemaining() {
        Decimal age = effectiveAge();
        return (age == null) ? null : 45 - age;
    }

    // ----- Save ------------------------------------------------------------
    /**
     * Auto-save invoked by the Starting Age input's onchange handler.
     * Saves the record the page binds to, then re-queries the snapshot so the
     * computed getters reflect the new age on reRender.
     */
    public PageReference saveLead() {
        try {
            update (Lead) stdCtrl.getRecord();
            loadLead();
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(
                ApexPages.Severity.ERROR, e.getMessage()));
        }
        return null;
    }
}
