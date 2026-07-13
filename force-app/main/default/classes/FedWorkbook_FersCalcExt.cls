/**
 * FedWorkbook_FersCalcExt
 *
 * Extension for page 8 (FedWorkbook_FersCalc). Computes the two
 * FERS retirement scenarios using the same Lead fields as the
 * original FERS_System.page:
 *
 *   Scenario 1: Scenario1_Retirement_Age__c, Scenario1_YOS__c, High_3_Salary__c
 *   Scenario 2: Scenario2_Retirement_Age__c, Scenario2_YOS__c, High_3_Salary2__c
 *
 * Plus the page-shared Contact_Age__c.
 *
 * FERS factor rule (from the red bullets at the top of the page):
 *   - 1.1% if retirement age >= 62 AND years of service >= 20
 *   - 1.0% otherwise
 *
 * Annual Annuity = High-3 x (factor / 100) x Years of Service
 * Monthly Annuity = Annual Annuity / 12
 */
public with sharing class FedWorkbook_FersCalcExt {

    // Public property so apex:inputField can bind to lead.Field__c
    // and saveLead() operates on the same instance.
    public Lead lead { get; set; }

    private Id leadId;

    public FedWorkbook_FersCalcExt(ApexPages.StandardController stdController) {
        this.leadId = stdController.getId();
        this.lead = fetchLead();
    }

    // NOTE: the open-time reseed of Scenario1/2_YOS_Manual__c from the Flow
    // values is performed by the container page's action method
    // (FedWorkbook_PreviewExt.reseedYosOnOpen), NOT here. DML is not allowed in
    // an extension constructor while the page is being rendered as an
    // apex:include, which is how this page is shown in the workbook.

    // Editable "Times (x) Years of Service".
    //
    // Stored in the Flow-safe Scenario1/2_YOS_Manual__c field — the client's Flow
    // recomputes Scenario1/2_YOS__c on every Lead update, so a manual entry kept
    // there would be overwritten. Shared across the workbook pages so FersCalc,
    // FersSurvivor and FinancialSnapshot all agree on the value.
    //
    // Each time the workbook is opened the override is reseeded from the current
    // Flow value (see FedWorkbook_PreviewExt.reseedYosOnOpen); during the session
    // the user can edit it and the entry persists. The getter returns the effective
    // whole-number YOS (manual -> Flow -> projected); the setter stores the entered
    // whole number.
    public Decimal scenario1XYOS {
        get { return wholeYos(effectiveYos(lead.Scenario1_YOS_Manual__c, lead.Scenario1_YOS__c, lead.Scenario1_Retirement_Age__c)); }
        set { lead.Scenario1_YOS_Manual__c = (value == null) ? null : wholeYos(value); }
    }
    public Decimal scenario2XYOS {
        get { return wholeYos(effectiveYos(lead.Scenario2_YOS_Manual__c, lead.Scenario2_YOS__c, lead.Scenario2_Retirement_Age__c)); }
        set { lead.Scenario2_YOS_Manual__c = (value == null) ? null : wholeYos(value); }
    }
    private Decimal effectiveYos(Decimal manualYos, Decimal flowYos, Decimal retAge) {
        if (manualYos != null && manualYos != 0) { return manualYos; }
        if (flowYos != null && flowYos != 0) { return flowYos; }
        return projectedYos(retAge);
    }
    // Years of Service is a whole-year value, so show/use it without decimals
    // (the underlying Number(8,2) field would otherwise render e.g. "55.00").
    private Decimal wholeYos(Decimal v) {
        return v == null ? null : v.setScale(0, System.RoundingMode.HALF_UP);
    }

    // Centralised SOQL fetch — called by constructor and after save so
    // computed getters always see fresh values.
    private Lead fetchLead() {
        if (this.leadId == null) { return new Lead(); }
        return [
            SELECT FERS__c,
                   Contact_Age__c,
                   Years_of_Employment__c,
                   Base_Salary__c,
                   Date_of_Birth__c,
                   Date_of_Hire__c,
                   Expected_Retirement_Date__c,
                   Scenario1_Primary__c,
                   Scenario2_Primary__c,
                   Scenario1_Retirement_Age__c,
                   Scenario2_Retirement_Age__c,
                   Scenario1_YOS__c,
                   Scenario2_YOS__c,
                   Scenario1_YOS_Manual__c,
                   Scenario2_YOS_Manual__c,
                   High_3_Salary__c,
                   High_3_Salary2__c
            FROM Lead
            WHERE Id = :this.leadId
            LIMIT 1
        ];
    }

    // Auto-save invoked by onchange on editable input cells.
    // Re-fetches after update so computed getters reflect fresh values.
    public PageReference saveLead() {
        try {
            update lead;
            lead = fetchLead();
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(
                ApexPages.Severity.ERROR, e.getMessage()));
        }
        return null;
    }

    // ---- Top summary (read-only "current" values) --------------------------
    public Decimal getCurrentAge() {
        return lead.Contact_Age__c == null ? 0 : lead.Contact_Age__c;
    }
    // Expected retirement age = whole years between birth and the expected
    // retirement date, derived from the two dates (the stored
    // Expected_Retirement_Age__c formula was unreliable). See FedWorkbook_Util.
    public Decimal getExpectedRetirementAge() {
        Decimal age = FedWorkbook_Util.expectedRetirementAge(lead);
        return age == null ? 0 : age;
    }
    public Decimal getCurrentYOS() {
        return lead.Years_of_Employment__c == null ? 0 : lead.Years_of_Employment__c;
    }
    public Decimal getCurrentBasePay() {
        return lead.Base_Salary__c == null ? 0 : lead.Base_Salary__c;
    }

    // ---- Primary scenario selection (mutually exclusive) -------------------
    // Mirrors the legacy setprimary1 / setprimary2: checking one clears the
    // other. The checkboxes render only once a retirement age is entered.
    public Boolean getS1HasRetAge() {
        return lead.Scenario1_Retirement_Age__c != null && lead.Scenario1_Retirement_Age__c != 0;
    }
    public Boolean getS2HasRetAge() {
        return lead.Scenario2_Retirement_Age__c != null && lead.Scenario2_Retirement_Age__c != 0;
    }
    public Boolean getS1Primary() { return lead.Scenario1_Primary__c == true; }
    public Boolean getS2Primary() { return lead.Scenario2_Primary__c == true; }
    public PageReference setPrimary1() {
        if (lead.Scenario1_Primary__c == true) { lead.Scenario2_Primary__c = false; }
        return saveLead();
    }
    public PageReference setPrimary2() {
        if (lead.Scenario2_Primary__c == true) { lead.Scenario1_Primary__c = false; }
        return saveLead();
    }

    // ---- Projected Years of Service at retirement --------------------------
    // Legacy: RetirementAge - ageAtHire, where ageAtHire is derived from the
    // hire/birth dates. Shown read-only beneath each Retirement Age input.
    private Decimal projectedYos(Decimal retAge) {
        if (retAge == null || retAge == 0
                || lead.Date_of_Birth__c == null || lead.Date_of_Hire__c == null) {
            return 0;
        }
        Integer ageAtHire = (Integer) Math.floor(
            lead.Date_of_Birth__c.daysBetween(lead.Date_of_Hire__c) / 365.25);
        return retAge - Math.abs(ageAtHire);
    }
    public Decimal getS1ProjectedYOS() { return projectedYos(lead.Scenario1_Retirement_Age__c); }
    public Decimal getS2ProjectedYOS() { return projectedYos(lead.Scenario2_Retirement_Age__c); }

    // Retirement-age change seeds the editable "Times Years of Service" with the
    // projected YOS (legacy scenario1XYOS = RetAge - ageAtHire), then saves.
    // Retirement-age change just persists (the Flow recomputes Scenario1/2_YOS__c).
    // A manual override, if present, deliberately persists across an age change;
    // clearing it is an explicit user action (blank the YOS box).
    public PageReference saveS1Age() { return saveLead(); }
    public PageReference saveS2Age() { return saveLead(); }

    // ---- Scenario 1 --------------------------------------------------------
    public Decimal getS1RetirementAge() {
        return lead.Scenario1_Retirement_Age__c == null ? 0 : lead.Scenario1_Retirement_Age__c;
    }
    public Decimal getS1YearsOfService() {
        return scenario1XYOS == null ? 0 : scenario1XYOS;
    }
    public Decimal getS1HighThree() {
        return lead.High_3_Salary__c == null ? 0 : lead.High_3_Salary__c;
    }
    public Decimal getS1Factor() {
        // 1.1% if retirement age >= 62 AND >= 20 years of service, else 1.0%
        if (getS1RetirementAge() >= 62 && getS1YearsOfService() >= 20) { return 1.1; }
        return 1.0;
    }
    /** Intermediate: High-3 x factor (in dollars per year, before YoS). */
    public Decimal getS1FactorTimesHighThree() {
        return getS1HighThree() * (getS1Factor() / 100);
    }
    public Decimal getS1AnnualAnnuity() {
        return getS1FactorTimesHighThree() * getS1YearsOfService();
    }
    public Decimal getS1MonthlyAnnuity() {
        return getS1AnnualAnnuity() / 12;
    }

    // ---- Scenario 2 --------------------------------------------------------
    public Decimal getS2RetirementAge() {
        return lead.Scenario2_Retirement_Age__c == null ? 0 : lead.Scenario2_Retirement_Age__c;
    }
    public Decimal getS2YearsOfService() {
        return scenario2XYOS == null ? 0 : scenario2XYOS;
    }
    public Decimal getS2HighThree() {
        return lead.High_3_Salary2__c == null ? 0 : lead.High_3_Salary2__c;
    }
    public Decimal getS2Factor() {
        if (getS2RetirementAge() >= 62 && getS2YearsOfService() >= 20) { return 1.1; }
        return 1.0;
    }
    public Decimal getS2FactorTimesHighThree() {
        return getS2HighThree() * (getS2Factor() / 100);
    }
    public Decimal getS2AnnualAnnuity() {
        return getS2FactorTimesHighThree() * getS2YearsOfService();
    }
    public Decimal getS2MonthlyAnnuity() {
        return getS2AnnualAnnuity() / 12;
    }
}
