/**
 * FedWorkbook_TestData
 *
 * Shared test data factory for the Federal Workbook rebrand test classes.
 * Builds Lead records using only writeable fields. Formula fields
 * (Contact_Age__c, Years_of_Employment__c, Expected_Retirement_Age__c,
 * formula_basePay__c, etc.) are driven indirectly via Date_of_Birth__c /
 * Date_of_Hire__c / Expected_Retirement_Date__c so no formula field is ever
 * written. Picklist values are resolved at runtime via Schema describe so a
 * restricted picklist never rejects a hardcoded value, and no hardcoded Ids
 * are used anywhere.
 */
@isTest
public class FedWorkbook_TestData {

    /**
     * Resolve a value for a picklist/text field safely:
     *  - Picklist: return the first PREFERRED active value if present, else the
     *    first active value, skipping the blank "--" sentinel.
     *  - Text (no picklist entries): return the textFallback literal.
     */
    public static String pickVal(Schema.SObjectField field, Set<String> preferred, String textFallback) {
        List<Schema.PicklistEntry> entries = field.getDescribe().getPicklistValues();
        if (entries != null && !entries.isEmpty()) {
            if (preferred != null) {
                for (Schema.PicklistEntry e : entries) {
                    if (e.isActive() && preferred.contains(e.getValue())) { return e.getValue(); }
                }
            }
            for (Schema.PicklistEntry e : entries) {
                if (e.isActive() && e.getValue() != '--') { return e.getValue(); }
            }
            return null;
        }
        return textFallback;
    }

    /** A fresh StandardController carrying only the Id, like the live pages. */
    public static ApexPages.StandardController sc(Id leadId) {
        return new ApexPages.StandardController(new Lead(Id = leadId));
    }

    /** Marital status resolved to "Married" when that value is defined. */
    public static String married() {
        return pickVal(Lead.Marital_Status__c, new Set<String>{ 'Married' }, 'Married');
    }

    private static void applyPercents(Lead l) {
        l.taxRate3_Picklist__c = pickVal(Lead.taxRate3_Picklist__c,
            new Set<String>{ '12%', '15%', '20%', '25%' }, '12%');
        l.taxRate5_Picklist__c = pickVal(Lead.taxRate5_Picklist__c,
            new Set<String>{ '10%', '12%', '15%' }, '10%');
        l.AnnualWithdraw1__c = pickVal(Lead.AnnualWithdraw1__c,
            new Set<String>{ '10%', '20%', '5%', '4%' }, '10%');
        l.AnnualWithdraw2__c = pickVal(Lead.AnnualWithdraw2__c,
            new Set<String>{ '10%', '20%', '5%', '4%' }, '10%');
    }

    /**
     * FERS lead — Scenario 1 primary, retiring before 62, married with the
     * minimum (25%) survivor election. Exercises the "before 62" gates and the
     * Min survivor-reduction paths across the calculators.
     */
    public static Lead fersBefore62() {
        Lead l = new Lead(
            LastName = 'FersBefore', Company = 'Fed Agency',
            FERS__c = true,
            Scenario1_Primary__c = true,
            Scenario1_Retirement_Age__c = 60,
            Scenario1_YOS__c = 25,
            Scenario2_Retirement_Age__c = 0,
            Scenario2_YOS__c = 0,
            High_3_Salary__c = 100000,
            High_3_Salary2__c = 90000,
            Base_Salary__c = 95000,
            Remaining_Years__c = 3,
            YOS_Special_Supplement__c = 20,
            Predicted_Social_Security__c = 2000,
            Spouse_Social_Security__c = 1000,
            Military_Retirement__c = 500,
            Disability_in_Retirement__c = 250,
            Additional_Income1__c = 200,
            Additional_Income2__c = 100,
            currentNET__c = 4000,
            Total_Health__c = 300,
            Additional_Insurance__c = 50,
            TSP_Balance_No_Match__c = 200000,
            ROTH_Contributions__c = 50000,
            Min__c = true,
            Date_of_Birth__c = System.today().addYears(-58),
            Date_of_Hire__c = System.today().addYears(-25),
            Expected_Retirement_Date__c = System.today().addYears(4),
            Description = 'Initial notes'
        );
        l.Marital_Status__c = married();
        applyPercents(l);
        insert l;
        return l;
    }

    /**
     * FERS lead — Scenario 2 primary, retiring at/after 62, married with the
     * maximum (50%) survivor election. Exercises the >=62 / 1.1% factor paths
     * and the Max survivor-reduction paths.
     */
    public static Lead fersAfter62() {
        Lead l = new Lead(
            LastName = 'FersAfter', Company = 'Fed Agency',
            FERS__c = true,
            Scenario2_Primary__c = true,
            Scenario2_Retirement_Age__c = 65,
            Scenario2_YOS__c = 22,
            Scenario1_Retirement_Age__c = 0,
            Scenario1_YOS__c = 0,
            High_3_Salary__c = 110000,
            High_3_Salary2__c = 120000,
            Base_Salary__c = 105000,
            YOS_Special_Supplement__c = 30,
            Predicted_Social_Security__c = 2500,
            currentNET__c = 5000,
            TSP_Balance_No_Match__c = 0,
            ROTH_Contributions__c = 75000,
            Max__c = true,
            Date_of_Birth__c = System.today().addYears(-64),
            Date_of_Hire__c = System.today().addYears(-22),
            Expected_Retirement_Date__c = System.today().addYears(1)
        );
        l.Marital_Status__c = married();
        applyPercents(l);
        insert l;
        return l;
    }

    /**
     * Neither scenario primary, married with Max election but opted out.
     * Exercises the non-scenario (Expected_Retirement) pension path and the
     * opted-out spouse-benefit display gate.
     */
    public static Lead neitherScenario() {
        Lead l = new Lead(
            LastName = 'NoScenario', Company = 'Fed Agency',
            FERS__c = true,
            Scenario1_Primary__c = false,
            Scenario2_Primary__c = false,
            High_3_Salary__c = 80000,
            High_3_Salary2__c = 80000,
            Base_Salary__c = 78000,
            YOS_Special_Supplement__c = 18,
            Predicted_Social_Security__c = 1800,
            currentNET__c = 3500,
            TSP_Balance_No_Match__c = 150000,
            ROTH_Contributions__c = 0,
            Max__c = true,
            Opt_Out__c = true,
            Date_of_Birth__c = System.today().addYears(-60),
            Date_of_Hire__c = System.today().addYears(-30),
            Expected_Retirement_Date__c = System.today().addYears(2)
        );
        l.Marital_Status__c = married();
        applyPercents(l);
        insert l;
        return l;
    }

    /** Special Group member lead — drives the Special Group calc + gate paths. */
    public static Lead specialGroup() {
        Lead l = new Lead(
            LastName = 'SpecialGrp', Company = 'Fed Agency',
            Special_Group_Member__c = true,
            FERS__c = true,
            High_3_Salary__c = 115000,
            Remaining_Years__c = 3,
            YOS_Special_Supplement__c = 23,
            Predicted_Social_Security__c = 2200,
            Date_of_Birth__c = System.today().addYears(-53),
            Date_of_Hire__c = System.today().addYears(-23),
            Expected_Retirement_Date__c = System.today().addYears(-1)
        );
        applyPercents(l);
        insert l;
        return l;
    }

    /**
     * FEGLI lead with a FEGLI code set (drives the "has code" branches in the
     * FEGLI extensions) and a DOB-derived age. Basic + all options selected.
     */
    public static Lead fegliWithCode() {
        Lead l = new Lead(
            LastName = 'FegliCode', Company = 'Fed Agency',
            Basic__c = true, OptionA__c = true, OptionB__c = true, OptionC__c = true,
            Date_of_Birth__c = System.today().addYears(-47)
        );
        l.FEGLI_Code_Picklist__c = pickVal(Lead.FEGLI_Code_Picklist__c,
            new Set<String>{ 'K1', 'K2', 'C1', 'C2', 'B1' }, 'K1');
        l.Affiliation__c = pickVal(Lead.Affiliation__c,
            new Set<String>{ 'United States Postal Service (USPS)' },
            'United States Postal Service (USPS)');
        insert l;
        return l;
    }

    /**
     * FEGLI lead WITHOUT a code, using the manual age-band / multiples inputs.
     * Drives the manual-lookup branches in the FEGLI extensions.
     */
    public static Lead fegliManual() {
        Lead l = new Lead(
            LastName = 'FegliManual', Company = 'Fed Agency',
            Basic__c = true, OptionA__c = true, OptionB__c = true, OptionC__c = true
        );
        l.Age_Option_A_Manual__c = pickVal(Lead.Age_Option_A_Manual__c,
            new Set<String>{ '50-54' }, '50-54');
        l.Age_Option_B_Manual__c = pickVal(Lead.Age_Option_B_Manual__c,
            new Set<String>{ '55-59' }, '55-59');
        l.Age_Option_C_Manual__c = pickVal(Lead.Age_Option_C_Manual__c,
            new Set<String>{ '60-64' }, '60-64');
        l.Multiples_B_Manual__c = pickVal(Lead.Multiples_B_Manual__c,
            new Set<String>{ '3' }, '3');
        l.Multiples_C_Manual__c = pickVal(Lead.Multiples_C_Manual__c,
            new Set<String>{ '2' }, '2');
        insert l;
        return l;
    }
}
