/**
 * FedWorkbook_PDFExt
 *
 * Single consolidated controller for the PDF-optimized workbook
 * (FedWorkbook_PDF). The interactive pages each have their own
 * extension that defines lead/saveLead, so they cannot be combined as
 * multiple extensions on one page (getter/method collisions).
 *
 * Instead this class DELEGATES to each interactive extension (all of
 * which self-query in their constructors) and re-exposes their computed
 * values read-only, under namespaced getter names so there are no
 * collisions. This reuses the exact formulas the interactive pages use.
 */
public with sharing class FedWorkbook_PDFExt {

    private final ApexPages.StandardController stdCtrl;
    private final Id leadId;

    public FedWorkbook_PDFExt(ApexPages.StandardController stdController) {
        this.stdCtrl = stdController;
        this.leadId = stdController.getId();
        // addFields() is only valid on a page-created controller; when a record
        // is passed in directly (e.g. unit tests) it throws and the caller has
        // already supplied the field, so the exception is safe to ignore.
        try {
            stdController.addFields(new List<String>{ 'FEGLI_Plan__c' });
        } catch (Exception e) {
            // Record provided by caller — FEGLI_Plan__c is already available.
        }
    }

    private Lead lead() { return (Lead) stdCtrl.getRecord(); }

    // A fresh StandardController carrying just the Id, so each delegated
    // extension's constructor (which self-queries on getId()) works.
    private ApexPages.StandardController sc() {
        return new ApexPages.StandardController(new Lead(Id = leadId));
    }

    // ----- Lazily-constructed delegate extensions --------------------------
    private FedWorkbook_FegliACExt acExt;
    private FedWorkbook_FegliACExt ac() { if (acExt == null) acExt = new FedWorkbook_FegliACExt(sc()); return acExt; }

    private FedWorkbook_OptionBExt obExt;
    private FedWorkbook_OptionBExt ob() { if (obExt == null) obExt = new FedWorkbook_OptionBExt(sc()); return obExt; }

    private FedWorkbook_BasicLifeExt blExt;
    private FedWorkbook_BasicLifeExt bl() { if (blExt == null) blExt = new FedWorkbook_BasicLifeExt(sc()); return blExt; }

    private FedWorkbook_FersCalcExt fcExt;
    private FedWorkbook_FersCalcExt fc() { if (fcExt == null) fcExt = new FedWorkbook_FersCalcExt(sc()); return fcExt; }

    private FedWorkbook_FersSurvivorExt fsExt;
    private FedWorkbook_FersSurvivorExt fs() { if (fsExt == null) fsExt = new FedWorkbook_FersSurvivorExt(sc()); return fsExt; }

    private FedWorkbook_SpecialGroupsExt sgExt;
    private FedWorkbook_SpecialGroupsExt sg() { if (sgExt == null) sgExt = new FedWorkbook_SpecialGroupsExt(sc()); return sgExt; }

    private FedWorkbook_SpecialSupplementExt ssExt;
    private FedWorkbook_SpecialSupplementExt ss() { if (ssExt == null) ssExt = new FedWorkbook_SpecialSupplementExt(sc()); return ssExt; }

    private FedWorkbook_TspResourcesExt tspExt;
    private FedWorkbook_TspResourcesExt tsp() { if (tspExt == null) tspExt = new FedWorkbook_TspResourcesExt(sc()); return tspExt; }

    private FedWorkbook_FinancialSnapshotExt snapExt;
    private FedWorkbook_FinancialSnapshotExt snap() { if (snapExt == null) snapExt = new FedWorkbook_FinancialSnapshotExt(sc()); return snapExt; }

    // ----- Page 2: Employee Info — FEGLI Plan checkboxes (read-only) -------
    private Boolean planHas(String val) {
        String current = lead().FEGLI_Plan__c;
        if (String.isBlank(current)) { return false; }
        for (String part : current.split(';')) {
            if (part.trim() == val) { return true; }
        }
        return false;
    }
    public String getPlanBasicMark()   { return planHas('Basic')    ? 'X' : ''; }
    public String getPlanOptionAMark() { return planHas('Option A') ? 'X' : ''; }
    public String getPlanOptionBMark() { return planHas('Option B') ? 'X' : ''; }
    public String getPlanOptionCMark() { return planHas('Option C') ? 'X' : ''; }

    // ----- Page 3: Basic Life — Extra Benefit / Total Current Benefit ------
    public Decimal getBlExtraBenefit()              { return bl().getExtraBenefit(); }
    public Decimal getBlTotalCurrentBenefit()       { return bl().getTotalCurrentBenefit(); }
    public Boolean getBlShowYearsRemaining()        { return bl().getShowYearsRemaining(); }
    public Decimal getBlExtraBenefitYearsRemaining() { return bl().getExtraBenefitYearsRemaining(); }

    // ----- Page 4: FEGLI Option A / C -------------------------------------
    public Decimal getAcOptionACost()          { return ac().getOptionACost(); }
    public Integer getAcOptionCMultiples()      { return ac().getOptionCMultiples(); }
    public Decimal getAcOptionCBiWeeklyFactor() { return ac().getOptionCBiWeeklyFactor(); }
    // Current Age (locked) vs Starting Age (manual) label gates — match the
    // interactive page so the label always agrees with the displayed rate.
    public Boolean getAcShowCurrentAgeA()  { return ac().getShowCurrentAgeA(); }
    public Boolean getAcShowStartingAgeA() { return ac().getShowStartingAgeA(); }
    public Boolean getAcShowCurrentAgeC()  { return ac().getShowCurrentAgeC(); }
    public Boolean getAcShowStartingAgeC() { return ac().getShowStartingAgeC(); }

    // ----- Page 5: FEGLI Option B + Total Basic & Optional summary --------
    public Boolean getObHasOptionA()        { return ob().getHasOptionA(); }
    public Boolean getObHasOptionB()        { return ob().getHasOptionB(); }
    public Boolean getObHasOptionC()        { return ob().getHasOptionC(); }
    public Decimal getObAnnualRatePay()     { return ob().getAnnualRatePay(); }
    public Integer getObMultiplier()        { return ob().getMultiplier(); }
    // Current Age (locked) vs Starting Age (manual) label gates — match the page.
    public Boolean getObShowCurrentAge()    { return ob().getShowCurrentAge(); }
    public Boolean getObShowStartingAge()   { return ob().getShowStartingAge(); }
    public Decimal getObOptionBCoverage()   { return ob().getOptionBCoverage(); }
    public Decimal getObOptionBBiWeeklyCost() { return ob().getOptionBBiWeeklyCost(); }
    public Decimal getObOptionBMonthlyCost()  { return ob().getOptionBMonthlyCost(); }
    public Decimal getObBasicCoverage()     { return ob().getBasicCoverage(); }
    public Decimal getObBasicBiWeeklyCost() { return ob().getBasicBiWeeklyCost(); }
    public Decimal getObOptionACoverage()   { return ob().getOptionACoverage(); }
    public Decimal getObOptionABiWeeklyCost() { return ob().getOptionABiWeeklyCost(); }
    public Decimal getObOptionCBiWeeklyCost() { return ob().getOptionCBiWeeklyCost(); }
    public Decimal getObTotalCoverage()     { return ob().getTotalCoverage(); }
    public Decimal getObTotalBiWeeklyCost() { return ob().getTotalBiWeeklyCost(); }
    public Decimal getObTotalMonthlyCost()  { return ob().getTotalMonthlyCost(); }

    // ----- Page 5b: Option B Coverage projection (read-only) --------------
    public List<FedWorkbook_OptionBExt.ProjRow> getObProjectionRows() { return ob().getProjectionRows(); }
    public Decimal getObProjTotalYears()  { return ob().getProjTotalYears(); }
    public Decimal getObProjFegliTotal()  { return ob().getProjFegliTotal(); }
    public Decimal getObProjAltTotal()    { return ob().getProjAltTotal(); }
    public Decimal getObProjSavings()     { return ob().getProjSavings(); }
    public Decimal getObCurrentBenefit()  { return ob().getCurrentBenefit(); }
    public Decimal getObAltBiWeekly()     { return ob().getAltBiWeekly(); }
    public Decimal getObAltAnnual()       { return ob().getAltAnnual(); }
    public Decimal getObStartingAge()     { return ob().getStartingAge(); }
    public Decimal getObFaceAmount()      { return ob().getFaceAmount(); }
    public Decimal getObMonthlyPremium()  { return ob().getMonthlyPremium(); }

    // ----- Page 7: Calculating FERS Retirement ---------------------------
    public Decimal getFcCurrentAge()            { return fc().getCurrentAge(); }
    public Decimal getFcExpectedRetirementAge() { return fc().getExpectedRetirementAge(); }
    public Decimal getFcCurrentYOS()            { return fc().getCurrentYOS(); }
    public Decimal getFcCurrentBasePay()        { return fc().getCurrentBasePay(); }
    public Boolean getFcS1Primary()             { return fc().getS1Primary(); }
    public Boolean getFcS2Primary()             { return fc().getS2Primary(); }
    public Boolean getFcS1HasRetAge()           { return fc().getS1HasRetAge(); }
    public Boolean getFcS2HasRetAge()           { return fc().getS2HasRetAge(); }
    public Decimal getFcS1ProjectedYOS()        { return fc().getS1ProjectedYOS(); }
    public Decimal getFcS2ProjectedYOS()        { return fc().getS2ProjectedYOS(); }
    public Decimal getFcS1RetirementAge()       { return fc().getS1RetirementAge(); }
    public Decimal getFcS1YearsOfService()      { return fc().getS1YearsOfService(); }
    public Decimal getFcS1HighThree()           { return fc().getS1HighThree(); }
    public Decimal getFcS1Factor()              { return fc().getS1Factor(); }
    public Decimal getFcS1FactorTimesHighThree(){ return fc().getS1FactorTimesHighThree(); }
    public Decimal getFcS1AnnualAnnuity()       { return fc().getS1AnnualAnnuity(); }
    public Decimal getFcS1MonthlyAnnuity()      { return fc().getS1MonthlyAnnuity(); }
    public Decimal getFcS2RetirementAge()       { return fc().getS2RetirementAge(); }
    public Decimal getFcS2YearsOfService()      { return fc().getS2YearsOfService(); }
    public Decimal getFcS2HighThree()           { return fc().getS2HighThree(); }
    public Decimal getFcS2Factor()              { return fc().getS2Factor(); }
    public Decimal getFcS2FactorTimesHighThree(){ return fc().getS2FactorTimesHighThree(); }
    public Decimal getFcS2AnnualAnnuity()       { return fc().getS2AnnualAnnuity(); }
    public Decimal getFcS2MonthlyAnnuity()      { return fc().getS2MonthlyAnnuity(); }

    // ----- Page 8: FERS Survivor Benefit Annuity -------------------------
    public Decimal getFsS1CurrentMonthlyIncome()      { return fs().getS1CurrentMonthlyIncome(); }
    public Decimal getFsS1MonthlyRetirementAnnuity()  { return fs().getS1MonthlyRetirementAnnuity(); }
    public Decimal getFsS1DifferenceInMonthlyAnnuity(){ return fs().getS1DifferenceInMonthlyAnnuity(); }
    public Decimal getFsS2CurrentMonthlyIncome()      { return fs().getS2CurrentMonthlyIncome(); }
    public Decimal getFsS2MonthlyRetirementAnnuity()  { return fs().getS2MonthlyRetirementAnnuity(); }
    public Decimal getFsS2DifferenceInMonthlyAnnuity(){ return fs().getS2DifferenceInMonthlyAnnuity(); }
    public Boolean getFsMinSelected()       { return fs().getMinSelected(); }
    public Boolean getFsMaxSelected()       { return fs().getMaxSelected(); }
    public Decimal getFsMonthlyAnnuity()    { return fs().getMonthlyAnnuity(); }
    public Decimal getFsMinus5Pct()         { return fs().getMinus5Pct(); }
    public Decimal getFsReducedMin()        { return fs().getReducedMin(); }
    public Decimal getFsSurvivingSpouseMin(){ return fs().getSurvivingSpouseMin(); }
    public Decimal getFsMinus10Pct()        { return fs().getMinus10Pct(); }
    public Decimal getFsReducedMax()        { return fs().getReducedMax(); }
    public Decimal getFsSurvivingSpouseMax(){ return fs().getSurvivingSpouseMax(); }

    // ----- Page 9: FERS Special Groups -----------------------------------
    public Decimal getSgFactor17xHigh3()           { return sg().getFactor17xHigh3(); }
    public Decimal getSgBlock20YearAnnuity()        { return sg().getBlock20YearAnnuity(); }
    public Decimal getSgFactor01xHigh3()            { return sg().getFactor01xHigh3(); }
    public Decimal getSgFactor01xRemainingAnnuity() { return sg().getFactor01xRemainingAnnuity(); }
    public Decimal getSgTotalAnnual()               { return sg().getTotalAnnual(); }
    public Decimal getSgTotalMonthly()              { return sg().getTotalMonthly(); }

    // ----- Page 10: FERS Special Supplement ------------------------------
    public Decimal getSsSupplementPct()     { return ss().getSupplementPct(); }
    public Decimal getSsSupplementDollars() { return ss().getSupplementDollars(); }
    public Boolean getSsShowSpecialSupp()   { return ss().getShowSpecialSupp(); }

    // ----- Page 11: TSP --------------------------------------------------
    public Decimal getTspTotalContribution() { return tsp().getTotalContribution(); }
    public Decimal getTspRegularLimit() {
        return (tsp().currentYear == null) ? null : tsp().currentYear.Regular_Contribution__c;
    }
    public Decimal getTspCatchUpLimit() {
        return (tsp().currentYear == null) ? null : tsp().currentYear.Catch_Up_Contribution__c;
    }

    // ----- Page 12: Financial Snapshot -----------------------------------
    public Boolean getSnapSocialSecurityEligible()  { return snap().getSocialSecurityEligible(); }
    public Decimal getSnapPensionBase()             { return snap().getPensionBase(); }
    public Decimal getSnapSurvivingSpouseBenefit()  { return snap().getSurvivingSpouseBenefit(); }
    public Boolean getSnapIsMarried()               { return snap().getIsMarried(); }
    public Boolean getSnapSpouseBenefitOptedOut()   { return snap().getSpouseBenefitOptedOut(); }
    public Decimal getSnapExpenseTotal()            { return snap().getExpenseTotal(); }
    public Decimal getSnapTotalTaxes()              { return snap().getTotalTaxes(); }
    public Decimal getSnapTspPreTaxTotal()          { return snap().getTspPreTaxTotal(); }
    public Decimal getSnapYosPercent()              { return snap().getYosPercent(); }
    public Boolean getSnapYosFormulaVisible()       { return snap().getYosFormulaVisible(); }
    public Decimal getSnapFersSupplementDisplay()   { return snap().getFersSupplementDisplay(); }
    public Boolean getSnapFersSupplementEligible()  { return snap().getFersSupplementEligible(); }
    public Decimal getSnapTspDisplay()              { return snap().getTspDisplay(); }
    public Decimal getSnapIncomeTotal()             { return snap().getIncomeTotal(); }
    public Decimal getSnapDifference()              { return snap().getDifference(); }
    public Decimal getSnapBottomLine()              { return snap().getBottomLine(); }
}
