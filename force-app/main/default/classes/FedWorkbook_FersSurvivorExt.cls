/**
 * FedWorkbook_FersSurvivorExt
 *
 * Extension for page 9 (FedWorkbook_FersSurvivor).
 * Drives two sections:
 *
 *   Section A - "FERS - Calculating FERS Retirement" (continuation)
 *     4-column grid: Age at Retirement | Current Monthly Income |
 *                    Monthly Retirement Annuity | Difference in Monthly Annuity
 *     Two scenario rows, matching FERS_System.page lines 1474-1768
 *     (PAGE 12 BEGIN / FERS_Gap_Survivor_Benefit block).
 *
 *   Section B - "FERS - Survivor Benefit Annuity"
 *     Minimum / Maximum Survivor Benefit boxes.
 *     Monthly Annuity formula from FERS_System.page lines 1951-2940
 *     (SM New Changes 25th Spet 2025 / Spouse Annuity block).
 *
 * Fields queried (Lead):
 *   Scenario1_Retirement_Age__c, Scenario1_YOS__c, Scenario1_Primary__c
 *   Scenario2_Retirement_Age__c, Scenario2_YOS__c, Scenario2_Primary__c
 *   High_3_Salary__c, High_3_Salary2__c
 *   Base_Salary__c
 *   Expected_Retirement_Age__c, Years_of_Employment__c
 *
 * Factor rule (mirrors FedWorkbook_FersCalcExt):
 *   1.1% when retirement age >= 62 AND years of service >= 20; else 1.0%
 *
 * Difference in Monthly Annuity = Current Monthly Income - Monthly Retirement Annuity
 *   (i.e. Base_Salary__c / 12 minus the annuity, so the gap is positive when
 *   take-home drops; mirrors FERS_System.page line 1556:
 *   "(Lead.Base_Salary__c / 12) - (((Lead.High_3_Salary__c * 0.01) * scenario1XYOS) / 12)")
 *
 * The survivor-benefit Monthly Annuity used in the Min/Max boxes is the
 * "primary" scenario annuity (Scenario 1 if Scenario1_Primary__c, else
 * Scenario 2 if Scenario2_Primary__c, else the default calculation using
 * Expected_Retirement_Age__c and Years_of_Employment__c).
 */
public with sharing class FedWorkbook_FersSurvivorExt {

    // Public property so apex:inputField can bind to lead.Field__c
    // and saveLead() operates on the same instance.
    public Lead lead { get; set; }

    private Id leadId;

    public FedWorkbook_FersSurvivorExt(ApexPages.StandardController stdController) {
        this.leadId = stdController.getId();
        this.lead = fetchLead();
    }

    // Centralised SOQL fetch — called by constructor and after save so
    // computed getters always see fresh values.
    private Lead fetchLead() {
        if (this.leadId == null) { return new Lead(); }
        return [
            SELECT FERS__c,
                   Marital_Status__c,
                   Scenario1_Retirement_Age__c,
                   Scenario1_YOS__c,
                   Scenario1_Primary__c,
                   Scenario2_Retirement_Age__c,
                   Scenario2_YOS__c,
                   Scenario2_Primary__c,
                   High_3_Salary__c,
                   High_3_Salary2__c,
                   Base_Salary__c,
                   Expected_Retirement_Age__c,
                   Years_of_Employment__c,
                   Min__c,
                   Max__c,
                   Snapshot_Flow_Completed__c
            FROM Lead
            WHERE Id = :this.leadId
            LIMIT 1
        ];
    }

    // Auto-save invoked by onchange on editable age cells.
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

    // =========================================================================
    // Survivor benefit election (Min / Max — mutually exclusive)
    //
    // Mirrors the legacy setmin / setmax (Federal_LeadControllerExtension):
    // choosing one clears the other and resets Snapshot_Flow_Completed__c so
    // the downstream financial snapshot recomputes with the new election.
    // =========================================================================

    public Boolean getMinSelected() { return lead.Min__c == true; }
    public Boolean getMaxSelected() { return lead.Max__c == true; }

    public PageReference setMin() {
        if (lead.Min__c == true) {
            lead.Max__c = false;
            lead.Snapshot_Flow_Completed__c = false;
        }
        return saveLead();
    }

    public PageReference setMax() {
        if (lead.Max__c == true) {
            lead.Min__c = false;
            lead.Snapshot_Flow_Completed__c = false;
        }
        return saveLead();
    }

    // =========================================================================
    // Helpers
    // =========================================================================

    private Decimal safe(Decimal v) {
        return v == null ? 0 : v;
    }

    private Decimal factor(Decimal retAge, Decimal yos) {
        // 1.1% if age >= 62 AND yos >= 20; otherwise 1.0%
        if (retAge >= 62 && yos >= 20) { return 1.1; }
        return 1.0;
    }

    private Decimal monthlyAnnuityCalc(Decimal high3, Decimal retAge, Decimal yos) {
        Decimal f = factor(retAge, yos);
        return (high3 * (f / 100) * yos) / 12;
    }

    // =========================================================================
    // Section A — Scenario 1
    // =========================================================================

    public Decimal getS1RetirementAge() {
        return safe(lead.Scenario1_Retirement_Age__c);
    }

    public Decimal getS1CurrentMonthlyIncome() {
        // Current Monthly Income = Base_Salary__c / 12
        // (mirrors FERS_System.page line 1503: {!Lead.Base_Salary__c / 12})
        return safe(lead.Base_Salary__c) / 12;
    }

    public Decimal getS1MonthlyRetirementAnnuity() {
        // Mirrors FERS_System.page lines 1515/1524/1533/1542:
        //   ((Lead.High_3_Salary__c * 0.01 or 0.011) * scenario1XYOS) / 12
        // scenario1XYOS == Scenario1_YOS__c in the rebrand extension convention
        return monthlyAnnuityCalc(
            safe(lead.High_3_Salary__c),
            safe(lead.Scenario1_Retirement_Age__c),
            safe(lead.Scenario1_YOS__c)
        );
    }

    public Decimal getS1DifferenceInMonthlyAnnuity() {
        // Mirrors FERS_System.page line 1556:
        //   (Lead.Base_Salary__c / 12) - (((Lead.High_3_Salary__c * 0.01) * scenario1XYOS) / 12)
        return getS1CurrentMonthlyIncome() - getS1MonthlyRetirementAnnuity();
    }

    // =========================================================================
    // Section A — Scenario 2
    // =========================================================================

    public Decimal getS2RetirementAge() {
        return safe(lead.Scenario2_Retirement_Age__c);
    }

    public Decimal getS2CurrentMonthlyIncome() {
        // Same base salary for both scenarios (mirrors FERS_System.page line 1649)
        return safe(lead.Base_Salary__c) / 12;
    }

    public Decimal getS2MonthlyRetirementAnnuity() {
        // Mirrors FERS_System.page lines 1661/1670/1679/1688:
        //   ((Lead.High_3_Salary2__c * 0.01 or 0.011) * scenario2XYOS) / 12
        return monthlyAnnuityCalc(
            safe(lead.High_3_Salary2__c),
            safe(lead.Scenario2_Retirement_Age__c),
            safe(lead.Scenario2_YOS__c)
        );
    }

    public Decimal getS2DifferenceInMonthlyAnnuity() {
        // Mirrors FERS_System.page line 1702:
        //   (Lead.Base_Salary__c / 12) - (((Lead.High_3_Salary2__c * 0.01) * scenario2XYOS) / 12)
        return getS2CurrentMonthlyIncome() - getS2MonthlyRetirementAnnuity();
    }

    // =========================================================================
    // Section B — Monthly Annuity (for survivor benefit boxes)
    //
    // Picks the "primary" scenario annuity, mirroring the conditional
    // rendered= chains in FERS_System.page lines 1995-2084 (Min box) and
    // 2104-2195 (Max box).  Both boxes use the identical annuity value as
    // their starting point.
    // =========================================================================

    public Decimal getMonthlyAnnuity() {
        Boolean s1Primary = lead.Scenario1_Primary__c == true;
        Boolean s2Primary = lead.Scenario2_Primary__c == true;

        if (s1Primary && lead.Scenario1_Retirement_Age__c != null) {
            return monthlyAnnuityCalc(
                safe(lead.High_3_Salary__c),
                safe(lead.Scenario1_Retirement_Age__c),
                safe(lead.Scenario1_YOS__c)
            );
        }
        if (s2Primary && lead.Scenario2_Retirement_Age__c != null) {
            return monthlyAnnuityCalc(
                safe(lead.High_3_Salary2__c),
                safe(lead.Scenario2_Retirement_Age__c),
                safe(lead.Scenario2_YOS__c)
            );
        }
        // Default (no scenario is primary): Expected_Retirement_Age__c + Years_of_Employment__c
        // Mirrors FERS_System.page lines 2067-2080
        return monthlyAnnuityCalc(
            safe(lead.High_3_Salary__c),
            safe(lead.Expected_Retirement_Age__c),
            safe(lead.Years_of_Employment__c)
        );
    }

    // ---- Minimum Survivor Benefit (5% reduction, 25% surviving spouse) ------

    public Decimal getMinus5Pct() {
        // Mirrors FERS_System.page line 2226: (monthly annuity) * 0.05
        return getMonthlyAnnuity() * 0.05;
    }

    public Decimal getReducedMin() {
        // Reduced annuity after 5% deduction
        return getMonthlyAnnuity() - getMinus5Pct();
    }

    public Decimal getSurvivingSpouseMin() {
        // 25% of Monthly Annuity (surviving spouse monthly income)
        // Mirrors FERS_System.page lines 2292-2307 pattern (the surviving-spouse
        // income is the elected 25% of the full annuity, not of the reduced annuity)
        return getMonthlyAnnuity() * 0.25;
    }

    // ---- Maximum Survivor Benefit (10% reduction, 50% surviving spouse) -----

    public Decimal getMinus10Pct() {
        // Mirrors FERS_System.page line 2342: (monthly annuity) * 0.10
        return getMonthlyAnnuity() * 0.10;
    }

    public Decimal getReducedMax() {
        return getMonthlyAnnuity() - getMinus10Pct();
    }

    public Decimal getSurvivingSpouseMax() {
        // 50% of Monthly Annuity
        return getMonthlyAnnuity() * 0.50;
    }
}
