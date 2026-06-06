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

    // Centralised SOQL fetch — called by constructor and after save so
    // computed getters always see fresh values.
    private Lead fetchLead() {
        if (this.leadId == null) { return new Lead(); }
        return [
            SELECT FERS__c,
                   Contact_Age__c,
                   Expected_Retirement_Age__c,
                   Years_of_Employment__c,
                   Base_Salary__c,
                   Date_of_Birth__c,
                   Date_of_Hire__c,
                   Scenario1_Primary__c,
                   Scenario2_Primary__c,
                   Scenario1_Retirement_Age__c,
                   Scenario2_Retirement_Age__c,
                   Scenario1_YOS__c,
                   Scenario2_YOS__c,
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
    public Decimal getExpectedRetirementAge() {
        return lead.Expected_Retirement_Age__c == null ? 0 : lead.Expected_Retirement_Age__c;
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
    public PageReference saveS1Age() {
        Decimal proj = projectedYos(lead.Scenario1_Retirement_Age__c);
        if (proj != 0) { lead.Scenario1_YOS__c = proj; }
        return saveLead();
    }
    public PageReference saveS2Age() {
        Decimal proj = projectedYos(lead.Scenario2_Retirement_Age__c);
        if (proj != 0) { lead.Scenario2_YOS__c = proj; }
        return saveLead();
    }

    // ---- Scenario 1 --------------------------------------------------------
    public Decimal getS1RetirementAge() {
        return lead.Scenario1_Retirement_Age__c == null ? 0 : lead.Scenario1_Retirement_Age__c;
    }
    public Decimal getS1YearsOfService() {
        return lead.Scenario1_YOS__c == null ? 0 : lead.Scenario1_YOS__c;
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
        return lead.Scenario2_YOS__c == null ? 0 : lead.Scenario2_YOS__c;
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
