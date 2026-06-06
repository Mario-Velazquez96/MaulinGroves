/**
 * FedWorkbook_OptionBExt
 *
 * Extension for page 5 (FedWorkbook_OptionB). Exposes the values
 * needed for the Option B calculation block AND the "Total Basic &
 * Optional Life Insurance" summary at the bottom of the page.
 *
 * All Lead fields read here are the same ones the original
 * OptionB.page uses. A direct SOQL avoids the addFields() ordering
 * issue caused by the page-level rendered attribute.
 */
public with sharing class FedWorkbook_OptionBExt {

    private final ApexPages.StandardController stdCtrl;
    private final Id leadId;
    private Lead lead;

    // Escalating Option B cost-projection bands, in display order. Each band's
    // bi-weekly factor (per $1,000 of coverage) and the text field that holds
    // the user-entered number of years spent in that band. Mirrors the legacy
    // GPIS_Federal_Workbook page-6 projection table.
    private static final List<String>  PROJ_LABELS = new List<String>{
        '34', '35-39', '40-44', '45-49', '50-54', '55-59',
        '60-64', '65-69', '70-74', '75-79', '80+'
    };
    private static final List<Decimal> PROJ_FACTORS = new List<Decimal>{
        0.02, 0.02, 0.03, 0.06, 0.10, 0.18, 0.40, 0.48, 0.86, 1.80, 2.88
    };
    private static final List<Schema.SObjectField> PROJ_YEAR_FIELDS =
        new List<Schema.SObjectField>{
            Lead.Years_34__c, Lead.Years_35_39__c, Lead.Years_40_44__c,
            Lead.Years_45_49__c, Lead.Years_50_54__c, Lead.Years_55_59__c,
            Lead.Years_60_64__c, Lead.Years_65_69__c, Lead.Years_70_74__c,
            Lead.Years_75_79__c, Lead.Years_80__c
        };

    public FedWorkbook_OptionBExt(ApexPages.StandardController stdController) {
        this.stdCtrl = stdController;
        this.leadId = stdController.getId();
        loadLead();
    }

    // (Re)loads the working copy of the Lead. Called in the constructor and
    // after every save/lock/unlock/reset so the computed getters reflect the
    // freshly-persisted values (including server-recalculated formula fields).
    private void loadLead() {
        if (leadId != null) {
            this.lead = [
                SELECT Name, FEGLI_Code_Picklist__c,
                       Contact_Age__c, Base_Salary__c,
                       Affiliation__c,
                       Basic__c, OptionA__c, OptionB__c, OptionC__c,
                       Age_Option_B_Manual__c, Age_Option_C_Manual__c,
                       Multiples_B_Manual__c, Multiples_C_Manual__c,
                       formula_basePay__c,
                       Total_Basic_Benefit__c,
                       AgeFactorFormula_OptionA__c,
                       AgeFactorformula_OptionB__c,
                       AgeFactorformula_OptionC__c,
                       Starting_Age__c, Starting_Age_Set__c,
                       Standard_Monthly__c, Standard_Amount__c,
                       Years_34__c, Years_35_39__c, Years_40_44__c,
                       Years_45_49__c, Years_50_54__c, Years_55_59__c,
                       Years_60_64__c, Years_65_69__c, Years_70_74__c,
                       Years_75_79__c, Years_80__c
                FROM Lead
                WHERE Id = :leadId
                LIMIT 1
            ];
        } else {
            this.lead = new Lead();
        }
    }

    public Lead getLeadRecord() { return lead; }

    private Boolean hasFegliCode() {
        String code = lead.FEGLI_Code_Picklist__c;
        return String.isNotBlank(code) && code != '--';
    }

    /**
     * Option B multiplier (0-5) for a given FEGLI code + manual value.
     *   G/H/I/J -> 1   K/L/M/N -> 2   P/Q/R -> 3
     *   S/T/U/V -> 4   W/X/Y/Z -> 5
     * With no code, the manual Multiples_B value is used.
     */
    private Integer multiplierOf(String code, String manual) {
        if (String.isNotBlank(code) && code != '--') {
            if (code.contains('G') || code.contains('H')
             || code.contains('I') || code.contains('J')) { return 1; }
            if (code.contains('K') || code.contains('L')
             || code.contains('M') || code.contains('N')) { return 2; }
            if (code.contains('P') || code.contains('Q')
             || code.contains('R'))                       { return 3; }
            if (code.contains('S') || code.contains('T')
             || code.contains('U') || code.contains('V')) { return 4; }
            if (code.contains('W') || code.contains('X')
             || code.contains('Y') || code.contains('Z')) { return 5; }
            return 0;
        }
        if (String.isBlank(manual)) { return 0; }
        try { return Integer.valueOf(manual); } catch (Exception e) { return 0; }
    }

    public Boolean getHasBasic()   { return lead.Basic__c   == true; }
    public Boolean getHasOptionA() { return lead.OptionA__c == true; }
    public Boolean getHasOptionB() { return lead.OptionB__c == true; }
    public Boolean getHasOptionC() { return lead.OptionC__c == true; }
    public Boolean getIsUSPS() {
        return lead.Affiliation__c == 'United States Postal Service (USPS)';
    }

    // ---- Option B (main calculation block) ----------------------------------
    public Decimal getAnnualRatePay() {
        return lead.formula_basePay__c == null ? 0 : lead.formula_basePay__c;
    }

    /**
     * Option B multiplier (0-5).
     * Matches OptionB.page: when a FEGLI code is set the multiplier is
     * derived from the letter:
     *   G/H/I/J -> 1   K/L/M/N -> 2   P/Q/R -> 3
     *   S/T/U/V -> 4   W/X/Y/Z -> 5
     * Otherwise (no code), read Multiples_B_Manual__c.
     */
    public Integer getMultiplier() {
        return multiplierOf(lead.FEGLI_Code_Picklist__c, lead.Multiples_B_Manual__c);
    }

    public Decimal getOptionBCoverage() {
        return getAnnualRatePay() * getMultiplier();
    }

    /**
     * Bi-weekly factor per $1,000 of Option B coverage.
     * With FEGLI code  -> AgeFactorformula_OptionB__c (Lead formula).
     * Without code     -> hardcoded lookup against Age_Option_B_Manual__c
     *                     (same values OptionB.page uses).
     */
    public Decimal getOptionBBiWeeklyFactor() {
        if (hasFegliCode()) {
            return lead.AgeFactorformula_OptionB__c == null
                ? 0
                : lead.AgeFactorformula_OptionB__c;
        }
        String band = lead.Age_Option_B_Manual__c;
        if (band == 'Under 35' || band == '35-39') { return 0.02; }
        if (band == '40-44') { return 0.03; }
        if (band == '45-49') { return 0.06; }
        if (band == '50-54') { return 0.10; }
        if (band == '55-59') { return 0.18; }
        if (band == '60-64') { return 0.40; }
        if (band == '65-69') { return 0.48; }
        if (band == '70-74') { return 0.86; }
        if (band == '75-79') { return 1.80; }
        if (band == '80+')   { return 2.88; }
        return 0;
    }

    public Decimal getOptionBMonthlyFactor() {
        return (getOptionBBiWeeklyFactor() * 26) / 12;
    }

    public Decimal getOptionBBiWeeklyCost() {
        Decimal cov = getOptionBCoverage();
        if (cov == 0) { return 0; }
        return (cov / 1000) * getOptionBBiWeeklyFactor();
    }

    public Decimal getOptionBMonthlyCost() {
        Decimal cov = getOptionBCoverage();
        if (cov == 0) { return 0; }
        return (cov / 1000) * getOptionBMonthlyFactor();
    }

    // ---- Basic Life (summary row) -------------------------------------------
    public Decimal getBasicCoverage() {
        if (!getHasBasic()) { return 0; }
        return lead.Total_Basic_Benefit__c == null ? 0 : lead.Total_Basic_Benefit__c;
    }

    /** Same formula OptionB.page uses: (BIA/1000) * 0.3467 * 12 / 26.
     *  USPS employees pay nothing (USPS covers Basic in full). */
    public Decimal getBasicBiWeeklyCost() {
        if (!getHasBasic()) { return 0; }
        if (getIsUSPS())    { return 0; }
        Decimal bia = (lead.formula_basePay__c == null ? 0 : lead.formula_basePay__c) + 2000;
        return ((bia / 1000) * 0.3467 * 12) / 26;
    }

    // ---- Option A (summary row) ---------------------------------------------
    public Decimal getOptionACoverage() {
        return getHasOptionA() ? 10000 : 0;
    }

    public Decimal getOptionABiWeeklyCost() {
        if (!getHasOptionA()) { return 0; }
        return lead.AgeFactorFormula_OptionA__c == null
            ? 0
            : lead.AgeFactorFormula_OptionA__c;
    }

    // ---- Option C (summary row) ---------------------------------------------
    public Integer getOptionCMultiples() {
        if (hasFegliCode()) {
            String code = lead.FEGLI_Code_Picklist__c;
            if (code.contains('1')) { return 1; }
            if (code.contains('2')) { return 2; }
            if (code.contains('3')) { return 3; }
            if (code.contains('4')) { return 4; }
            if (code.contains('5')) { return 5; }
            return 0;
        }
        String m = lead.Multiples_C_Manual__c;
        if (String.isBlank(m)) { return 0; }
        try { return Integer.valueOf(m); } catch (Exception e) { return 0; }
    }

    /** Per-multiple bi-weekly rate by age band (Option C). */
    public Decimal getOptionCBiWeeklyFactor() {
        if (hasFegliCode()) {
            return lead.AgeFactorformula_OptionC__c == null
                ? 0
                : lead.AgeFactorformula_OptionC__c;
        }
        String band = lead.Age_Option_C_Manual__c;
        if (band == 'Under 35') { return 0.20; }
        if (band == '35-39')    { return 0.24; }
        if (band == '40-44')    { return 0.37; }
        if (band == '45-49')    { return 0.53; }
        if (band == '50-54')    { return 0.83; }
        if (band == '55-59')    { return 1.33; }
        if (band == '60-64')    { return 2.43; }
        if (band == '65-69')    { return 2.83; }
        if (band == '70-74')    { return 3.83; }
        if (band == '75-79')    { return 5.76; }
        if (band == '80+')      { return 7.80; }
        return 0;
    }

    public Decimal getOptionCBiWeeklyCost() {
        if (!getHasOptionC()) { return 0; }
        return getOptionCBiWeeklyFactor() * getOptionCMultiples();
    }

    // ---- Totals --------------------------------------------------------------
    public Decimal getTotalCoverage() {
        return getBasicCoverage() + getOptionACoverage() + getOptionBCoverage();
    }

    public Decimal getTotalBiWeeklyCost() {
        return getBasicBiWeeklyCost()
             + getOptionABiWeeklyCost()
             + getOptionBBiWeeklyCost()
             + getOptionCBiWeeklyCost();
    }

    public Decimal getTotalMonthlyCost() {
        return (getTotalBiWeeklyCost() * 26) / 12;
    }

    // =====================================================================
    //  Escalating cost projection (legacy GPIS_Federal_Workbook page 6)
    // =====================================================================

    /** Parses a Years_* text field to a Decimal; blank/invalid -> 0. */
    private Decimal toDec(String s) {
        if (String.isBlank(s)) { return 0; }
        try { return Decimal.valueOf(s.trim()); } catch (Exception e) { return 0; }
    }

    /** True once the Starting Age has been set (table is locked / read-only). */
    public Boolean getStartingAgeLocked() {
        return lead.Starting_Age_Set__c == true;
    }

    /** One row of the escalating projection table. */
    public class ProjRow {
        public String  ageLabel { get; set; }
        public Decimal biWeekly { get; set; }
        public Decimal annual   { get; set; }
        public Decimal years    { get; set; }
        public Decimal total    { get; set; }
    }

    /** Alternative-policy monthly premium (0 when blank). */
    private Decimal monthlyPremium() {
        return lead.Standard_Monthly__c == null ? 0 : lead.Standard_Monthly__c;
    }

    /**
     * Builds the 11 projection rows. Coverage is the same for every band
     * (annual rate of pay rounded up x the Option B multiplier); only the
     * bi-weekly factor changes by age band. Total = annual cost x the number
     * of years the employee is projected to spend in that band.
     *
     * Reads the persisted record (this.lead), which the interactive page
     * refreshes on every auto-save (loadLead) and which the PDF delegation
     * supplies via its own query — so the same getters serve both.
     */
    public List<ProjRow> getProjectionRows() {
        Decimal cov = getOptionBCoverage();
        List<ProjRow> rows = new List<ProjRow>();
        for (Integer i = 0; i < PROJ_LABELS.size(); i++) {
            ProjRow r = new ProjRow();
            r.ageLabel = PROJ_LABELS[i];
            r.biWeekly = (cov == 0) ? 0 : (cov / 1000) * PROJ_FACTORS[i];
            r.annual   = r.biWeekly * 26;
            r.years    = toDec((String) lead.get(PROJ_YEAR_FIELDS[i]));
            r.total    = r.annual * r.years;
            rows.add(r);
        }
        return rows;
    }

    /** Total number of projected years across all bands. */
    public Decimal getProjTotalYears() {
        Decimal t = 0;
        for (Schema.SObjectField f : PROJ_YEAR_FIELDS) { t += toDec((String) lead.get(f)); }
        return t;
    }

    /** Total FEGLI Option B cost across all projected years. */
    public Decimal getProjFegliTotal() {
        Decimal t = 0;
        for (ProjRow r : getProjectionRows()) { t += r.total; }
        return t;
    }

    /** Cost of the alternative (private) policy over the same years. */
    public Decimal getProjAltTotal() {
        return monthlyPremium() * 12 * getProjTotalYears();
    }

    /** Savings of the alternative policy vs. FEGLI over the projection. */
    public Decimal getProjSavings() {
        return getProjFegliTotal() - getProjAltTotal();
    }

    /** Current FEGLI Option B benefit (coverage amount) the projection is based on. */
    public Decimal getCurrentBenefit() {
        return getOptionBCoverage();
    }

    /** Alternative (private) policy bi-weekly cost, derived from the monthly premium. */
    public Decimal getAltBiWeekly() {
        return (monthlyPremium() * 12) / 26;
    }

    /** Alternative (private) policy annual cost, derived from the monthly premium. */
    public Decimal getAltAnnual() {
        return monthlyPremium() * 12;
    }

    /** Starting age / projection inputs exposed read-only for the PDF. */
    public Decimal getStartingAge()  { return lead.Starting_Age__c; }
    public Decimal getFaceAmount()   { return lead.Standard_Amount__c; }
    public Decimal getMonthlyPremium() { return monthlyPremium(); }

    // ---- Actions -------------------------------------------------------------

    /** Auto-save invoked by the editable inputs (multiplier, years, premium). */
    public PageReference saveLead() {
        try {
            update (Lead) stdCtrl.getRecord();
            loadLead();
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }
        return null;
    }

    /** Locks the projection once a Starting Age is entered (legacy startingAgeSet). */
    public PageReference lockStartingAge() {
        Lead l = (Lead) stdCtrl.getRecord();
        l.Starting_Age_Set__c = true;
        try { update l; loadLead(); }
        catch (Exception e) { ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage())); }
        return null;
    }

    /** Re-opens the projection for editing (legacy Unlock). */
    public PageReference unlockStartingAge() {
        Lead l = (Lead) stdCtrl.getRecord();
        l.Starting_Age_Set__c = false;
        try { update l; loadLead(); }
        catch (Exception e) { ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage())); }
        return null;
    }

    /** Clears the projection back to zero (legacy Reset). */
    public PageReference resetProjection() {
        Lead l = (Lead) stdCtrl.getRecord();
        l.Starting_Age__c = 0;
        for (Schema.SObjectField f : PROJ_YEAR_FIELDS) { l.put(f, '0'); }
        l.Standard_Amount__c = 0;
        l.Standard_Monthly__c = 0;
        l.Starting_Age_Set__c = false;
        try { update l; loadLead(); }
        catch (Exception e) { ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage())); }
        return null;
    }
}
