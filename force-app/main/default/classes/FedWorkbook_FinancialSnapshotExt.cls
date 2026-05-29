public with sharing class FedWorkbook_FinancialSnapshotExt {

    public Lead lead { get; set; }
    private Id leadId;

    public FedWorkbook_FinancialSnapshotExt(ApexPages.StandardController stdController) {
        this.leadId = stdController.getId();
        this.lead = fetchLead();
    }

    private Lead fetchLead() {
        if (this.leadId == null) { return new Lead(); }
        return [
            SELECT Id, Name,
                   Contact_Age__c,
                   Expected_Retirement_Age__c,
                   FERS__c,
                   Special_Group_Member__c, Remaining_Years__c,
                   Scenario1_Primary__c, Scenario1_Retirement_Age__c, Scenario1_YOS__c,
                   Scenario2_Primary__c, Scenario2_Retirement_Age__c, Scenario2_YOS__c,
                   High_3_Salary2__c, Years_of_Employment__c,
                   Date_of_Birth__c, Date_of_Hire__c,
                   Marital_Status__c, Opt_Out__c, Min__c, Max__c,
                   Spouse_Name__c, Spouse_Name__r.Name,
                   Total_Health__c,
                   Additional_Insurance__c,
                   YOS_Special_Supplement__c,
                   Predicted_Social_Security__c,
                   Spouse_Social_Security__c,
                   Military_Retirement__c,
                   Disability_in_Retirement__c,
                   Additional_Income1__c,
                   Additional_Income2__c,
                   currentNET__c,
                   TSP_Balance_No_Match__c,
                   ROTH_Contributions__c,
                   AnnualWithdraw1__c,
                   AnnualWithdraw2__c,
                   taxRate3_Picklist__c,
                   High_3_Salary__c
            FROM Lead WHERE Id = :this.leadId LIMIT 1
        ];
    }

    public PageReference saveLead() {
        try {
            update lead;
            lead = fetchLead();
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }
        return null;
    }

    // -----------------------------------------------------------------------
    // Helper: safe decimal (null → 0)
    // -----------------------------------------------------------------------
    private Decimal d(Decimal v) { return v == null ? 0 : v; }

    // -----------------------------------------------------------------------
    // Helper: YOS (years of service) value used in pension formula.
    // Legacy pages use YOS_Special_Supplement__c as the editable YOS input
    // for the FERS Special Supplement formula section (legacy lines 1970-1983).
    // -----------------------------------------------------------------------
    private Decimal yos() { return d(lead.YOS_Special_Supplement__c); }

    // -----------------------------------------------------------------------
    // Helper: FERS supplement value (legacy lines 2012-2013).
    // = Predicted_Social_Security__c * (YOS / 40)
    // -----------------------------------------------------------------------
    private Decimal fersSupplementValue() {
        return d(lead.Predicted_Social_Security__c) * (yos() / 40);
    }

    // -----------------------------------------------------------------------
    // "Retiring before 62" — income-total gate used for Social Security and
    // FERS supplement values. Mirrors Federal_LeadControllerExtension lines
    // 591-594 / 606-609 (scenario/Expected logic, NO Special Group branch).
    // -----------------------------------------------------------------------
    private Boolean retiringBefore62() {
        return (lead.Scenario1_Primary__c == true && d(lead.Scenario1_Retirement_Age__c) < 62)
            || (lead.Scenario2_Primary__c == true && d(lead.Scenario2_Retirement_Age__c) < 62)
            || (lead.Scenario1_Primary__c != true && lead.Scenario2_Primary__c != true
                && d(lead.Expected_Retirement_Age__c) < 62);
    }

    // SocialSecurityValue — legacy lines 606-615: 0 when retiring before 62, else Predicted SS.
    private Decimal socialSecurityValue() {
        return retiringBefore62() ? 0 : d(lead.Predicted_Social_Security__c);
    }

    // fERSSpecialSupplementValue — legacy lines 591-602:
    //   floor(Predicted SS * (YOS / 40)) when retiring before 62, else 0.
    private Decimal fersSupplementGated() {
        return retiringBefore62() ? fersSupplementValue().round(System.RoundingMode.FLOOR) : 0;
    }

    // SpecialAndSupplementVal — legacy lines 617-622: the single income-line value.
    //   = fERSSpecialSupplementValue when a scenario is primary and < 62, else SocialSecurityValue.
    private Decimal specialAndSupplementVal() {
        Boolean scenarioBefore62 =
            (lead.Scenario1_Primary__c == true && d(lead.Scenario1_Retirement_Age__c) < 62)
            || (lead.Scenario2_Primary__c == true && d(lead.Scenario2_Retirement_Age__c) < 62);
        return scenarioBefore62 ? fersSupplementGated() : socialSecurityValue();
    }

    // -----------------------------------------------------------------------
    // Social Security eligibility for the DISPLAY ("Not Eligible" vs "$value").
    // Inverse of legacy "Not Eligible" gate at page line 2062 (four-branch,
    // includes the Special Group branch). Eligible => show $ + editable value.
    // -----------------------------------------------------------------------
    public Boolean getSocialSecurityEligible() {
        if (lead.Special_Group_Member__c == true) {
            return d(lead.Expected_Retirement_Age__c) >= 62;
        }
        if (lead.FERS__c == true) {
            return (lead.Scenario1_Primary__c == true && d(lead.Scenario1_Retirement_Age__c) >= 62)
                || (lead.Scenario2_Primary__c == true && d(lead.Scenario2_Retirement_Age__c) >= 62)
                || (lead.Scenario1_Primary__c != true && lead.Scenario2_Primary__c != true
                    && d(lead.Expected_Retirement_Age__c) >= 62);
        }
        return d(lead.Expected_Retirement_Age__c) >= 62;
    }

    // -----------------------------------------------------------------------
    // Helper: TSP monthly income (legacy lines 2998-3005).
    // Uses TSP_Balance_No_Match__c and AnnualWithdraw1__c for traditional TSP,
    // ROTH_Contributions__c and AnnualWithdraw2__c for Roth TSP.
    // -----------------------------------------------------------------------
    private Decimal tspWithdrawPct(String picklistVal) {
        if (String.isBlank(picklistVal)) { return 0; }
        try { return Decimal.valueOf(picklistVal.left(2)) / 100; }
        catch (Exception e) { return 0; }
    }

    private Decimal tspCalculateValue() {
        Decimal tspBal  = d(lead.TSP_Balance_No_Match__c);
        Decimal rothBal = d(lead.ROTH_Contributions__c);
        Decimal pct1 = tspWithdrawPct(lead.AnnualWithdraw1__c);
        Decimal pct2 = tspWithdrawPct(lead.AnnualWithdraw2__c);

        // Legacy lines 2998-3005 (active logic after commented-out blocks):
        if (tspBal != 0 && rothBal == 0) {
            return (tspBal * pct1) / 12;
        } else if (rothBal != 0 && tspBal == 0) {
            return (rothBal * pct2) / 12;
        } else if (tspBal != 0 && rothBal != 0) {
            return ((tspBal * pct1) / 12) + ((rothBal * pct2) / 12);
        }
        return 0;
    }

    // -----------------------------------------------------------------------
    // Helper: Tax rate (legacy taxRate3_Picklist__c, e.g. "12%", "15%", ...).
    // -----------------------------------------------------------------------
    private Decimal taxRate() {
        if (String.isBlank(lead.taxRate3_Picklist__c)) { return 0; }
        try { return Decimal.valueOf(lead.taxRate3_Picklist__c.left(2)) / 100; }
        catch (Exception e) { return 0; }
    }

    // -----------------------------------------------------------------------
    // Helper: Simplified pension base (using Expected_Retirement_Age__c path,
    // no scenario branching needed — the Financial Snapshot uses simple stored
    // or user-entered values via the editable fields below; pension display
    // on this page is read-only output from Predicted_Pension__c or a simple
    // formula via High_3_Salary__c * 0.01 * YOS / 12).
    //
    // For the Financial Snapshot page the key EDITABLE inputs are:
    //   Total_Health__c, Additional_Insurance__c, currentNET__c,
    //   TSP_Balance_No_Match__c, AnnualWithdraw1__c, YOS_Special_Supplement__c,
    //   Predicted_Social_Security__c, Spouse_Social_Security__c,
    //   Military_Retirement__c, Disability_in_Retirement__c,
    //   Additional_Income1__c, Additional_Income2__c.
    //
    // The expense total uses High_3_Salary__c * 0.01 * YOS / 12 for pension
    // (default/simple case, matching legacy non-scenario, non-married path).
    // For a standalone page the simplest defensible formula is the one for the
    // Expected_Retirement_Age__c path without Min/Max branching.
    // -----------------------------------------------------------------------
    // -----------------------------------------------------------------------
    // Career years of service at retirement, mirroring Federal_LeadControllerExtension
    // lines 581-589:
    //   yearsAtHire = floor((DoB.daysBetween(DoH)) / 365.25)
    //   scenarioXYOS = retirementAge - abs(yearsAtHire)
    // -----------------------------------------------------------------------
    private Decimal scenarioXYos(Decimal retirementAge) {
        if (retirementAge == null || lead.Date_of_Birth__c == null || lead.Date_of_Hire__c == null) {
            return 0;
        }
        Integer yearsBetween = (Integer) Math.floor(
            (lead.Date_of_Birth__c.daysBetween(lead.Date_of_Hire__c)) / 365.25
        );
        return retirementAge - Math.abs(yearsBetween);
    }

    // -----------------------------------------------------------------------
    // Raw (un-reduced) monthly pension. Handles two paths:
    //   * Special Group Members: ((High_3 * 0.017 * 20) + (High_3 * 0.01 * Remaining_Years)) / 12
    //     (mirrors Federal_LeadControllerExtension lines 630/632 — pensionMin/MaxValue)
    //   * Regular FERS: pick Scenario 1 / Scenario 2 / fallback to Expected_Retirement_Age.
    //     Apply 1.1% bonus when retirement age > 61 AND career YOS >= 20 (legacy lines 764-769 / 796-801).
    // -----------------------------------------------------------------------
    private Decimal rawPensionBase() {
        // ---- Special Group path (legacy lines 1002-1004, 630-632) ----
        if (lead.Special_Group_Member__c == true) {
            Decimal sgHigh3 = d(lead.High_3_Salary__c);
            Decimal sgRemaining = d(lead.Remaining_Years__c);
            return ((sgHigh3 * 0.017 * 20) + (sgHigh3 * 0.01 * sgRemaining)) / 12;
        }

        // ---- Regular FERS path ----
        Decimal high3;
        Decimal yosCareer;
        Decimal retirementAge;
        Decimal scenarioYosField;

        if (lead.Scenario1_Primary__c == true) {
            high3            = d(lead.High_3_Salary__c);
            yosCareer        = scenarioXYos(lead.Scenario1_Retirement_Age__c);
            retirementAge    = d(lead.Scenario1_Retirement_Age__c);
            scenarioYosField = d(lead.Scenario1_YOS__c);
        } else if (lead.Scenario2_Primary__c == true) {
            high3            = d(lead.High_3_Salary2__c);
            yosCareer        = scenarioXYos(lead.Scenario2_Retirement_Age__c);
            retirementAge    = d(lead.Scenario2_Retirement_Age__c);
            scenarioYosField = d(lead.Scenario2_YOS__c);
        } else {
            // Neither scenario primary — legacy non-scenario path (lines 804-833)
            // uses Years_of_Employment__c instead of scenarioXYos.
            high3            = d(lead.High_3_Salary__c);
            yosCareer        = d(lead.Years_of_Employment__c);
            retirementAge    = d(lead.Expected_Retirement_Age__c);
            scenarioYosField = d(lead.Years_of_Employment__c);
        }

        // 1.1% bonus when retirement age > 61 AND career YOS >= 20.
        Decimal factor = (retirementAge > 61 && scenarioYosField >= 20) ? 0.011 : 0.01;

        return (high3 * factor * yosCareer) / 12;
    }

    // -----------------------------------------------------------------------
    // getPensionBase() — value shown in the "Pension:" field.
    // Applies the survivor-benefit reduction when married (no opt-out):
    //   Min__c → × 0.95 (5% reduction, legacy line 842 / 1006)
    //   Max__c → × 0.90 (10% reduction, legacy line 920 / 1003)
    // -----------------------------------------------------------------------
    public Decimal getPensionBase() {
        Decimal base = rawPensionBase();
        Boolean married  = lead.Marital_Status__c == 'Married';
        Boolean optedOut = lead.Opt_Out__c == true;
        if (married && !optedOut) {
            if (lead.Min__c == true) { return base - (base * 0.05); }
            if (lead.Max__c == true) { return base - (base * 0.10); }
        }
        return base;
    }

    // -----------------------------------------------------------------------
    // Surviving Spouse Benefit reduction ratio depends on the rendering path:
    //   * Special Group:        Max → × 0.50 (line 1188), Min → × 0.25 (line 1191)
    //   * Non-scenario (regular FERS): × 0.50 (line 1176, Max-gated)
    //   * Scenario primary:     × 0.25 (line 1040, scenario-gated)
    // -----------------------------------------------------------------------
    public Decimal getSurvivingSpouseBenefit() {
        Decimal base = rawPensionBase();
        if (lead.Special_Group_Member__c == true) {
            if (lead.Min__c == true) { return base * 0.25; }
            return base * 0.50; // default to Max when Special Group
        }
        // Non-scenario regular FERS uses × 0.50; scenario primary uses × 0.25
        Boolean noScenarioPrimary = (lead.Scenario1_Primary__c != true && lead.Scenario2_Primary__c != true);
        return noScenarioPrimary ? base * 0.50 : base * 0.25;
    }

    private Decimal pensionBase() {
        return getPensionBase();
    }

    // -----------------------------------------------------------------------
    // getExpenseTotal()
    // Section A total: Pension - Taxes - Health - Additional Insurance.
    // Legacy pattern (line 1646 simplified):
    //   pensionBase - (taxRate * pensionBase) - Total_Health__c - Additional_Insurance__c
    // -----------------------------------------------------------------------
    public Decimal getExpenseTotal() {
        Decimal pension = pensionBase();
        // Legacy line 1646: pension - (taxRate * pension) - Health - AddlIns
        return pension - (taxRate() * pension) - d(lead.Total_Health__c) - d(lead.Additional_Insurance__c);
    }

    // -----------------------------------------------------------------------
    // getYosPercent()
    // YOS / 40 * 100, displayed as #0.0 percent.
    // Legacy lines 1979-1981: (Lead.YOS_Special_Supplement__c / 40) * 100
    // -----------------------------------------------------------------------
    public Decimal getYosPercent() {
        return (yos() / 40) * 100;
    }

    // -----------------------------------------------------------------------
    // getFersSupplementDisplay()
    // FERS Special Supplement computed value (read-only display).
    // Legacy line 2013: Predicted_Social_Security__c * (YOS / 40)
    // -----------------------------------------------------------------------
    public Decimal getFersSupplementDisplay() {
        // Gated: only paid when retiring before 62 (legacy lines 591-602).
        return fersSupplementGated();
    }

    // -----------------------------------------------------------------------
    // getTspDisplay()
    // TSP monthly income (read-only display).
    // Legacy lines 2998-3005.
    // -----------------------------------------------------------------------
    public Decimal getTspDisplay() {
        return tspCalculateValue();
    }

    // -----------------------------------------------------------------------
    // getIncomeTotal()
    // Section B total: ExpenseTotal + FersSupplement + SocialSecurity +
    //   SpouseSS + MilitaryRetirement + DisabilityInRetirement +
    //   AdditionalIncome1 + AdditionalIncome2
    // Legacy line 2328 simplified (non-married, basic scenario):
    //   ExpenseTotal + SpecialAndSupplementVal + Spouse_SS + Military +
    //   Disability + AddInc1 + AddInc2
    // -----------------------------------------------------------------------
    public Decimal getIncomeTotal() {
        // Legacy line 2328: ExpenseTotal + SpecialAndSupplementVal + Spouse_SS +
        // Military + Disability + AddInc1 + AddInc2.
        // SpecialAndSupplementVal is EITHER the FERS supplement OR Social Security
        // (mutually exclusive) — never both.
        return getExpenseTotal()
             + specialAndSupplementVal()
             + d(lead.Spouse_Social_Security__c)
             + d(lead.Military_Retirement__c)
             + d(lead.Disability_in_Retirement__c)
             + d(lead.Additional_Income1__c)
             + d(lead.Additional_Income2__c);
    }

    // -----------------------------------------------------------------------
    // getDifference()
    // = Income Total - Current Net.
    // Legacy line 2664: incomeTotal - currentNET__c
    // -----------------------------------------------------------------------
    public Decimal getDifference() {
        return getIncomeTotal() - d(lead.currentNET__c);
    }

    // -----------------------------------------------------------------------
    // getBottomLine()
    // = Difference + TSP monthly income.
    // Legacy line 3106 (TspCalculateValue added to IncomeTotal path,
    // then minus currentNET produces BottomLine = Difference + Tsp).
    // -----------------------------------------------------------------------
    public Decimal getBottomLine() {
        return getDifference() + tspCalculateValue();
    }
}
