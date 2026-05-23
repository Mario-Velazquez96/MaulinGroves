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

    private final Lead lead;

    public FedWorkbook_OptionBExt(ApexPages.StandardController stdController) {
        Id leadId = stdController.getId();
        if (leadId != null) {
            this.lead = [
                SELECT FEGLI_Code_Picklist__c,
                       Contact_Age__c,
                       Affiliation__c,
                       Basic__c, OptionA__c, OptionB__c, OptionC__c,
                       Age_Option_B_Manual__c, Age_Option_C_Manual__c,
                       Multiples_B_Manual__c, Multiples_C_Manual__c,
                       formula_basePay__c,
                       Total_Basic_Benefit__c,
                       AgeFactorFormula_OptionA__c,
                       AgeFactorformula_OptionB__c,
                       AgeFactorformula_OptionC__c
                FROM Lead
                WHERE Id = :leadId
                LIMIT 1
            ];
        } else {
            this.lead = new Lead();
        }
    }

    private Boolean hasFegliCode() {
        String code = lead.FEGLI_Code_Picklist__c;
        return String.isNotBlank(code) && code != '--';
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
        if (hasFegliCode()) {
            String code = lead.FEGLI_Code_Picklist__c;
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
        String m = lead.Multiples_B_Manual__c;
        if (String.isBlank(m)) { return 0; }
        try { return Integer.valueOf(m); } catch (Exception e) { return 0; }
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
}
