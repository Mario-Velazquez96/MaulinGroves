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
 * Plus the page-shared Sick_Leave__c and Contact_Age__c.
 *
 * FERS factor rule (from the red bullets at the top of the page):
 *   - 1.1% if retirement age >= 62 AND years of service >= 20
 *   - 1.0% otherwise
 *
 * Annual Annuity = High-3 x (factor / 100) x Years of Service
 * Monthly Annuity = Annual Annuity / 12
 */
public with sharing class FedWorkbook_FersCalcExt {

    private final Lead lead;

    public FedWorkbook_FersCalcExt(ApexPages.StandardController stdController) {
        Id leadId = stdController.getId();
        if (leadId != null) {
            this.lead = [
                SELECT Sick_Leave__c,
                       Contact_Age__c,
                       Scenario1_Retirement_Age__c,
                       Scenario2_Retirement_Age__c,
                       Scenario1_YOS__c,
                       Scenario2_YOS__c,
                       High_3_Salary__c,
                       High_3_Salary2__c
                FROM Lead
                WHERE Id = :leadId
                LIMIT 1
            ];
        } else {
            this.lead = new Lead();
        }
    }

    // ---- Shared ------------------------------------------------------------
    public Decimal getSickLeave() {
        return lead.Sick_Leave__c == null ? 0 : lead.Sick_Leave__c;
    }
    public Decimal getCurrentAge() {
        return lead.Contact_Age__c == null ? 0 : lead.Contact_Age__c;
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
