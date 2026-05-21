public with sharing class Federal_LeadControllerExtension {

    private final Lead lead;
    public string id = '00QDz00000HCQKDMA5';
    String[] states = new String[] {};
    String[] Ages = new String[] {};
    Boolean max;
    Boolean min;
    String[] fegliValues = new String[] {};

    // SM Starts Bajrang Changes 
    public Decimal TSP_Const_Balance_Value { get; set; }
    // SM END Bajrang Changes


    public TSP_Contribution__mdt previousYear {get; private set;}
    public TSP_Contribution__mdt currentYear {get;private set;}
    // public Decimal timesXYOS { get; set; }

    // SM Starts
    public Decimal scenario1XYOS {get;set;}
    public Decimal fERSSpecialSupplementValue {get;set;}
    public Decimal SocialSecurityValue {get;set;}
    public Decimal scenario2XYOS {get;set;}
    public Decimal SpecialAndSupplementVal {get;set;}
    // SM Ends

    public Decimal pensionMaxValue{get;set;}
    public Decimal pensionMinValue{get;set;}
    public Decimal TspCalculateValue{get;set;}
    public Boolean FERSValue { get; set; }
    public Boolean SpecialCheck { get; set; }


    public Federal_LeadControllerExtension(ApexPages.StandardController stdController) {

        this.lead = [SELECT FEGLI_Code_Picklist__c, OptionA__c, Age_Option_A_Manual__c, Contact_Age__c, OptionC__c, Age_Option_C_Manual__c, Multiples_C_Manual__c, AgeFactorformula_OptionC__c, FirstName, LastName, MiddleName, Street, City, PostalCode, MobilePhone_Formatted__c, LeadPhone_Formatted__c, Best_Day_of_the_Week_to_Contact__c, Best_Time_to_Contact__c, Prefer_Text__c, Email, Employment_Status__c, Company, Title, Date_of_Birth__c, Date_of_Hire__c, Years_of_Employment__c, Expected_Retirement_Date__c, Expected_Retirement_Age__c, Base_Salary__c, Salary_Interval__c, Marital_Status__c, Spouse_Name__r.Name, Spouse_Name__r.Date_of_Birth__c, Spouse_Name__r.Phone, Description, Predicted_Social_Security__c, Spouse_Social_Security__c, Predicted_Pension__c, Spouse_Pension__c, Pg7Rw3__c, Pg7Rw3_Spouse__c, Pg7Rw4__c, Pg7Rw4_Spouse__c, Pg7Rw5__c, Pg7Rw5_Spouse__c, Pg7Rw6__c, Pg7Rw6_Spouse__c, Pg7Rw7__c, Pg7Rw7_Spouse__c, Pg7Rw8__c, Pg7Rw8_Spouse__c, Pg7Rw9__c, Pg7Rw9_Spouse__c, Pg7Rw10__c, Pg7Rw10_Spouse__c, Pg8Rw1__c, Pg8Rw1_Spouse__c, Pg8Rw2__c, Pg8Rw2_Spouse__c, Pg8Rw3__c, Pg8Rw3_Spouse__c, Pg8Rw4__c, Pg8Rw4_Spouse__c, Pg8Rw5__c, Pg8Rw5_Spouse__c, Pg8Rw6__c, Pg8Rw6_Spouse__c, Pg8Rw7__c, Pg8Rw7_Spouse__c, Pg8Rw8__c, Pg8Rw8_Spouse__c, Pg8Rw9__c, Pg8Rw9_Spouse__c, Pg8Rw10__c, Pg8Rw10_Spouse__c, Pg8Rw11__c, Pg8Rw11_Spouse__c, Pg9Rw01__c, Pg9Rw02__c, Pg9Rw03__c, Pg9Rw04__c, Pg9Rw05__c, Pg9Rw06__c, Pg9Rw01_Spouse__c, Pg9Rw02_Spouse__c, Pg9Rw03_Spouse__c, Pg9Rw04_Spouse__c, Pg9Rw05_Spouse__c, Pg9Rw06_Spouse__c, Pg9Rw07__c, Pg9Rw08__c, Pg9Rw09__c, Pg9Rw10__c, Pg9Rw11__c, Pg9Rw07_Spouse__c, Pg9Rw08_Spouse__c, Pg9Rw09_Spouse__c, Pg9Rw10_Spouse__c, Pg9Rw11_Spouse__c, Pg9Rw12__c, Pg9Rw13__c, Pg9Rw14__c, Pg9Rw15__c, Pg9Rw16__c, Pg9Rw17__c, Pg9Rw12_Spouse__c, Pg9Rw13_Spouse__c, Pg9Rw14_Spouse__c, Pg9Rw15_Spouse__c, Pg9Rw16_Spouse__c, Pg9Rw17_Spouse__c, Pg9Rw18__c, Pg9Rw19__c, Pg9Rw20__c, Pg9Rw21__c, Pg9Rw18_Spouse__c, Pg9Rw19_Spouse__c, Pg9Rw20_Spouse__c, Pg9Rw21_Spouse__c, Pg10Rw01__c, Pg10Rw02__c, Pg10Rw03__c, Pg10Rw04__c, Pg10Rw01_Spouse__c, Pg10Rw02_Spouse__c, Pg10Rw03_Spouse__c, Pg10Rw04_Spouse__c, Pg10Rw05__c, Pg10Rw06__c, Pg10Rw07__c, Pg10Rw08__c, Pg10Rw05_Spouse__c, Pg10Rw06_Spouse__c, Pg10Rw07_Spouse__c, Pg10Rw08_Spouse__c, Pg10Rw09__c, Pg10Rw10__c, Pg10Rw11__c, Pg10Rw12__c, Pg10Rw13__c, Pg10Rw14__c, Pg10Rw09_Spouse__c, Pg10Rw10_Spouse__c, Pg10Rw11_Spouse__c, Pg10Rw12_Spouse__c, Pg10Rw13_Spouse__c, Pg10Rw14_Spouse__c, Pg10Rw15__c, Pg10Rw16__c, Pg10Rw17__c, Pg10Rw18__c, Pg10Rw15_Spouse__c, Pg10Rw16_Spouse__c, Pg10Rw17_Spouse__c, Pg10Rw18_Spouse__c, Pg10Rw19__c, Pg10Rw19_Spouse__c, Pg10Rw20__c, Pg10Rw20_Spouse__c, Pg10Rw21__c, Pg10Rw21_Spouse__c, Pg10Rw22__c, Pg10Rw22_Spouse__c, Pg10Rw23__c, Pg10Rw23_Spouse__c, Snapshot_Flow_Completed__c, Investment_Risk_Question_1__c, Investment_Risk_Question_2__c, Investment_Risk_Question_3__c, Investment_Risk_Question_4__c, Name, Spouse_Name__r.Contact_Age__c, taxRate1_Picklist__c, taxRate2_Picklist__c, taxRate3_Picklist__c, taxRate4_Picklist__c, totalTaxes__c, formula_totalHealth__c, formula_addlInsurance__c, combined_Expenses__c, Additional_Income1__c, BottomLine__c, Additional_Income2__c, Additional_Income3__c, subTotal__c, currentNET__c, formula_401k_Tax__c, AnnualWithdraw1__c, taxRate5_Picklist__c, GAP_Difference__c, formula_401k_TaxFREE__c, AnnualWithdraw2__c, IRA_401_k__c, pre_tax_Total__c, Appointment_Time__c, Referral__c, Referred_By__c, Federal_Employee__c, Spouse_Name__r.Account.Name, Spouse_Name__r.Title, State, Spouse_Name__r.Date_of_Hire__c, FERS__c, Special_Group_Member__c, Basic__c, OptionB__c, FEGLI_Code__c, TSP_Contribution__c, TSP_Balance__c, TSP_Total__c, ROTH_Total__c, TSP_Balance_No_Match__c, Scenario1_Primary__c, Scenario1_Retirement_Age__c, Scenario2_Primary__c, Scenario2_Retirement_Age__c, ShowTotal__c, ROTH_Contributions__c, Opt_Out__c, High_3_Salary__c, Total_Health__c, Additional_Insurance__c, FERS_Special_Supplement__c, Military_Retirement__c, Disability_in_Retirement__c, Scenario1_YOS__c, High_3_Salary2__c, Scenario2_YOS__c, Min__c, Max__c, How_Did_You_Hear__c, Union_Association__c, Local__c, Chapter__c, Branch__c, Branch_No__c, President__c, President_Phone__c, President_Email__c, Union_Website__c, Appointment_Results__c, Reset_Date__c, Reset_Time__c, Office__c, Specialist__c, Call_Back_Date__c, Call_Back_Time__c, OBEF_Notes__c, Age_Option_B_Manual__c, formula_basePay__c, Multiples_B_Manual__c, AgeFactorformula_OptionB__c, Age_Option_Basic_Manual__c, Affiliation__c, AgeFactorFormula_OptionA__c, AgeFactorformula_Basic__c, BasicBiWeekly__c, OptionABiWeekly__c, Option_B_Choice_Selection__c, Option_C_Choice_Selection__c, Starting_Age__c, Starting_Age_Set__c, Years_34__c, Years_35_39__c, Years_40_44__c, Years_45_49__c, Years_50_54__c, Years_55_59__c, Years_60_64__c, Years_65_69__c, Years_70_74__c, Years_75_79__c, Years_80__c, Standard_Monthly__c, Standard_Amount__c, Id, IsDeleted, MasterRecordId, Callback_Time__c, Salutation, Suffix, RecordTypeId, Country, Latitude, Longitude, GeocodeAccuracy, Address, Phone, MobilePhone, Fax, Website, PhotoUrl, LeadSource, Status, Industry, Rating, AnnualRevenue, NumberOfEmployees, OwnerId, HasOptedOutOfEmail, GenderIdentity, IsPriorityRecord, Carrier__c, Policy_Issue_Date__c, Policy__c, X401K_TaxFree__c, X401K_Tax__c, totalExpenses_Spouse__c, totalExpenses__c, totalTaxes_Currency__c, formula_totalExpenses_Spouse__c, formula_totalExpenses__c, hiddenTaxFormula1__c, hiddenTaxFormula2__c, hiddenTaxFormula3__c, hiddenTaxFormula4__c, hiddenTaxFormula_IRAFree__c, hiddenTaxFormula_IRA_Tax__c, hiddenTaxFormula_IRA__c, Age__c, Years_of_Service__c, LeadId__c, CSRS_Offset__c, CSRS__c, FEGLI_Plan__c, Federal_Indicator__c, Birth_Month__c, Birth_Month_Formula__c, Date_Turning_59_formula__c, Annuity_Task_Generated__c, Owner_Full_Name__c, Today__c, Date_Turning_59__c, Rollover_Task_Generated__c, Primary_Scenario__c, Spouse_Option__c, Date_Turning_65_formula__c, AgeFactorformula_OptionB_Text__c, AgeFactorformula_OptionC_Text__c, CSRS_Annuity_Retirement__c, Catchup_Contribution__c, Monthly_Contribution__c, Monthly_ROTH_Contribution__c, Notes__c, ROTH_TSP_Contribution__c, Regular_Contribution__c, Remaining_Years__c, YOS_Special_Supplement__c, dollarROTH__c, dollarTSP__c, percROTH__c, percTSP__c, total_Years__c, OptedOut_Annuity__c, OptionB_Insurance_Cover__c, formula_SurvivingSpouse__c, formula_annuityNotMarried__c, formula_monthlyAnnuity__c, hiddenExtraBenefitformula__c, hiddenTotalBenefitformula__c, hiddentaxFormula_TSP_Tax__c, hiddentaxFormula_TSP__c, hiddentaxformula_ROTHTSP__c FROM Lead Where Id = : stdController.getId() LIMIT 1];

        if(Lead.Base_Salary__c == null || Lead.Base_Salary__c <= 0 ){
            Lead.Base_Salary__c = 0;
        }
        if(Lead.Predicted_Social_Security__c == null || Lead.Predicted_Social_Security__c <= 0 ){
            Lead.Predicted_Social_Security__c = 0;
        }
        if(Lead.Spouse_Social_Security__c == null || Lead.Spouse_Social_Security__c <= 0 ){
            Lead.Spouse_Social_Security__c = 0;
        }
        if(Lead.Predicted_Pension__c == null || Lead.Predicted_Pension__c <= 0 ){
            Lead.Predicted_Pension__c = 0;
        }
        if(Lead.Spouse_Pension__c == null || Lead.Spouse_Pension__c <= 0 ){
            Lead.Spouse_Pension__c = 0;
        }
        if(Lead.Pg7Rw3__c == null || Lead.Pg7Rw3__c <= 0 ){
            Lead.Pg7Rw3__c = 0;
        }
        if(Lead.Pg7Rw3_Spouse__c == null || Lead.Pg7Rw3_Spouse__c <= 0 ){
            Lead.Pg7Rw3_Spouse__c = 0;
        }
        if(Lead.Pg7Rw4__c == null || Lead.Pg7Rw4__c <= 0 ){
            Lead.Pg7Rw4__c = 0;
        }
        if(Lead.Pg7Rw4_Spouse__c == null || Lead.Pg7Rw4_Spouse__c <= 0 ){
            Lead.Pg7Rw4_Spouse__c = 0;
        }
        if(Lead.Pg7Rw5__c == null || Lead.Pg7Rw5__c <= 0 ){
            Lead.Pg7Rw5__c = 0;
        }
        if(Lead.Pg7Rw5_Spouse__c == null || Lead.Pg7Rw5_Spouse__c <= 0 ){
            Lead.Pg7Rw5_Spouse__c = 0;
        }
        if(Lead.Pg7Rw6__c == null || Lead.Pg7Rw6__c <= 0 ){
            Lead.Pg7Rw6__c = 0;
        }
        if(Lead.Pg7Rw6_Spouse__c == null || Lead.Pg7Rw6_Spouse__c <= 0 ){
            Lead.Pg7Rw6_Spouse__c = 0;
        }
        if(Lead.Pg7Rw7__c == null || Lead.Pg7Rw7__c <= 0 ){
            Lead.Pg7Rw7__c = 0;
        }
        if(Lead.Pg7Rw7_Spouse__c == null || Lead.Pg7Rw7_Spouse__c <= 0 ){
            Lead.Pg7Rw7_Spouse__c = 0;
        }
        if(Lead.Pg7Rw8__c == null || Lead.Pg7Rw8__c <= 0 ){
            Lead.Pg7Rw8__c = 0;
        }
        if(Lead.Pg7Rw8_Spouse__c == null || Lead.Pg7Rw8_Spouse__c <= 0 ){
            Lead.Pg7Rw8_Spouse__c = 0;
        }
        if(Lead.Pg7Rw9__c == null || Lead.Pg7Rw9__c <= 0 ){
            Lead.Pg7Rw9__c = 0;
        }
        if(Lead.Pg7Rw9_Spouse__c == null || Lead.Pg7Rw9_Spouse__c <= 0 ){
            Lead.Pg7Rw9_Spouse__c = 0;
        }
        if(Lead.Pg7Rw10__c == null || Lead.Pg7Rw10__c <= 0 ){
            Lead.Pg7Rw10__c = 0;
        }
        if(Lead.Pg7Rw10_Spouse__c == null || Lead.Pg7Rw10_Spouse__c <= 0 ){
            Lead.Pg7Rw10_Spouse__c = 0;
        }
        if(Lead.Pg8Rw1__c == null || Lead.Pg8Rw1__c <= 0 ){
            Lead.Pg8Rw1__c = 0;
        }
        if(Lead.Pg8Rw1_Spouse__c == null || Lead.Pg8Rw1_Spouse__c <= 0 ){
            Lead.Pg8Rw1_Spouse__c = 0;
        }
        if(Lead.Pg8Rw2__c == null || Lead.Pg8Rw2__c <= 0 ){
            Lead.Pg8Rw2__c = 0;
        }
        if(Lead.Pg8Rw2_Spouse__c == null || Lead.Pg8Rw2_Spouse__c <= 0 ){
            Lead.Pg8Rw2_Spouse__c = 0;
        }
        if(Lead.Pg8Rw3__c == null || Lead.Pg8Rw3__c <= 0 ){
            Lead.Pg8Rw3__c = 0;
        }
        if(Lead.Pg8Rw3_Spouse__c == null || Lead.Pg8Rw3_Spouse__c <= 0 ){
            Lead.Pg8Rw3_Spouse__c = 0;
        }
        if(Lead.Pg8Rw4__c == null || Lead.Pg8Rw4__c <= 0 ){
            Lead.Pg8Rw4__c = 0;
        }
        if(Lead.Pg8Rw4_Spouse__c == null || Lead.Pg8Rw4_Spouse__c <= 0 ){
            Lead.Pg8Rw4_Spouse__c = 0;
        }
        if(Lead.Pg8Rw5__c == null || Lead.Pg8Rw5__c <= 0 ){
            Lead.Pg8Rw5__c = 0;
        }
        if(Lead.Pg8Rw5_Spouse__c == null || Lead.Pg8Rw5_Spouse__c <= 0 ){
            Lead.Pg8Rw5_Spouse__c = 0;
        }
        if(Lead.Pg8Rw6__c == null || Lead.Pg8Rw6__c <= 0 ){
            Lead.Pg8Rw6__c = 0;
        }
        if(Lead.Pg8Rw6_Spouse__c == null || Lead.Pg8Rw6_Spouse__c <= 0 ){
            Lead.Pg8Rw6_Spouse__c = 0;
        }
        if(Lead.Pg8Rw7__c == null || Lead.Pg8Rw7__c <= 0 ){
            Lead.Pg8Rw7__c = 0;
        }
        if(Lead.Pg8Rw7_Spouse__c == null || Lead.Pg8Rw7_Spouse__c <= 0 ){
            Lead.Pg8Rw7_Spouse__c = 0;
        }
        if(Lead.Pg8Rw8__c == null || Lead.Pg8Rw8__c <= 0 ){
            Lead.Pg8Rw8__c = 0;
        }
        if(Lead.Pg8Rw8_Spouse__c == null || Lead.Pg8Rw8_Spouse__c <= 0 ){
            Lead.Pg8Rw8_Spouse__c = 0;
        }
        if(Lead.Pg8Rw9__c == null || Lead.Pg8Rw9__c <= 0 ){
            Lead.Pg8Rw9__c = 0;
        }
        if(Lead.Pg8Rw9_Spouse__c == null || Lead.Pg8Rw9_Spouse__c <= 0 ){
            Lead.Pg8Rw9_Spouse__c = 0;
        }
        if(Lead.Pg8Rw10__c == null || Lead.Pg8Rw10__c <= 0 ){
            Lead.Pg8Rw10__c = 0;
        }
        if(Lead.Pg8Rw10_Spouse__c == null || Lead.Pg8Rw10_Spouse__c <= 0 ){
            Lead.Pg8Rw10_Spouse__c = 0;
        }
        if(Lead.Pg8Rw11__c == null || Lead.Pg8Rw11__c <= 0 ){
            Lead.Pg8Rw11__c = 0;
        }
        if(Lead.Pg8Rw11_Spouse__c == null || Lead.Pg8Rw11_Spouse__c <= 0 ){
            Lead.Pg8Rw11_Spouse__c = 0;
        }
        if(Lead.Pg9Rw01__c == null || Lead.Pg9Rw01__c <= 0 ){
            Lead.Pg9Rw01__c = 0;
        }
        if(Lead.Pg9Rw02__c == null || Lead.Pg9Rw02__c <= 0 ){
            Lead.Pg9Rw02__c = 0;
        }
        if(Lead.Pg9Rw03__c == null || Lead.Pg9Rw03__c <= 0 ){
            Lead.Pg9Rw03__c = 0;
        }
        if(Lead.Pg9Rw04__c == null || Lead.Pg9Rw04__c <= 0 ){
            Lead.Pg9Rw04__c = 0;
        }
        if(Lead.Pg9Rw05__c == null || Lead.Pg9Rw05__c <= 0 ){
            Lead.Pg9Rw05__c = 0;
        }
        if(Lead.Pg9Rw06__c == null || Lead.Pg9Rw06__c <= 0 ){
            Lead.Pg9Rw06__c = 0;
        }
        if(Lead.Pg9Rw01_Spouse__c == null || Lead.Pg9Rw01_Spouse__c <= 0 ){
            Lead.Pg9Rw01_Spouse__c = 0;
        }
        if(Lead.Pg9Rw02_Spouse__c == null || Lead.Pg9Rw02_Spouse__c <= 0 ){
            Lead.Pg9Rw02_Spouse__c = 0;
        }
        if(Lead.Pg9Rw03_Spouse__c == null || Lead.Pg9Rw03_Spouse__c <= 0 ){
            Lead.Pg9Rw03_Spouse__c = 0;
        }
        if(Lead.Pg9Rw04_Spouse__c == null || Lead.Pg9Rw04_Spouse__c <= 0 ){
            Lead.Pg9Rw04_Spouse__c = 0;
        }
        if(Lead.Pg9Rw05_Spouse__c == null || Lead.Pg9Rw05_Spouse__c <= 0 ){
            Lead.Pg9Rw05_Spouse__c = 0;
        }
        if(Lead.Pg9Rw06_Spouse__c == null || Lead.Pg9Rw06_Spouse__c <= 0 ){
            Lead.Pg9Rw06_Spouse__c = 0;
        }
        if(Lead.Pg9Rw07__c == null || Lead.Pg9Rw07__c <= 0 ){
            Lead.Pg9Rw07__c = 0;
        }
        if(Lead.Pg9Rw08__c == null || Lead.Pg9Rw08__c <= 0 ){
            Lead.Pg9Rw08__c = 0;
        }
        if(Lead.Pg9Rw09__c == null || Lead.Pg9Rw09__c <= 0 ){
            Lead.Pg9Rw09__c = 0;
        }
        if(Lead.Pg9Rw10__c == null || Lead.Pg9Rw10__c <= 0 ){
            Lead.Pg9Rw10__c = 0;
        }
        if(Lead.Pg9Rw11__c == null || Lead.Pg9Rw11__c <= 0 ){
            Lead.Pg9Rw11__c = 0;
        }
        if(Lead.Pg9Rw07_Spouse__c == null || Lead.Pg9Rw07_Spouse__c <= 0 ){
            Lead.Pg9Rw07_Spouse__c = 0;
        }
        if(Lead.Pg9Rw08_Spouse__c == null || Lead.Pg9Rw08_Spouse__c <= 0 ){
            Lead.Pg9Rw08_Spouse__c = 0;
        }
        if(Lead.Pg9Rw09_Spouse__c == null || Lead.Pg9Rw09_Spouse__c <= 0 ){
            Lead.Pg9Rw09_Spouse__c = 0;
        }
        if(Lead.Pg9Rw10_Spouse__c == null || Lead.Pg9Rw10_Spouse__c <= 0 ){
            Lead.Pg9Rw10_Spouse__c = 0;
        }
        if(Lead.Pg9Rw11_Spouse__c == null || Lead.Pg9Rw11_Spouse__c <= 0 ){
            Lead.Pg9Rw11_Spouse__c = 0;
        }
        if(Lead.Pg9Rw12__c == null || Lead.Pg9Rw12__c <= 0 ){
            Lead.Pg9Rw12__c = 0;
        }
        if(Lead.Pg9Rw13__c == null || Lead.Pg9Rw13__c <= 0 ){
            Lead.Pg9Rw13__c = 0;
        }
        if(Lead.Pg9Rw14__c == null || Lead.Pg9Rw14__c <= 0 ){
            Lead.Pg9Rw14__c = 0;
        }
        if(Lead.Pg9Rw15__c == null || Lead.Pg9Rw15__c <= 0 ){
            Lead.Pg9Rw15__c = 0;
        }
        if(Lead.Pg9Rw16__c == null || Lead.Pg9Rw16__c <= 0 ){
            Lead.Pg9Rw16__c = 0;
        }
        if(Lead.Pg9Rw17__c == null || Lead.Pg9Rw17__c <= 0 ){
            Lead.Pg9Rw17__c = 0;
        }
        if(Lead.Pg9Rw12_Spouse__c == null || Lead.Pg9Rw12_Spouse__c <= 0 ){
            Lead.Pg9Rw12_Spouse__c = 0;
        }
        if(Lead.Pg9Rw13_Spouse__c == null || Lead.Pg9Rw13_Spouse__c <= 0 ){
            Lead.Pg9Rw13_Spouse__c = 0;
        }
        if(Lead.Pg9Rw14_Spouse__c == null || Lead.Pg9Rw14_Spouse__c <= 0 ){
            Lead.Pg9Rw14_Spouse__c = 0;
        }
        if(Lead.Pg9Rw15_Spouse__c == null || Lead.Pg9Rw15_Spouse__c <= 0 ){
            Lead.Pg9Rw15_Spouse__c = 0;
        }
        if(Lead.Pg9Rw16_Spouse__c == null || Lead.Pg9Rw16_Spouse__c <= 0 ){
            Lead.Pg9Rw16_Spouse__c = 0;
        }
        if(Lead.Pg9Rw17_Spouse__c == null || Lead.Pg9Rw17_Spouse__c <= 0 ){
            Lead.Pg9Rw17_Spouse__c = 0;
        }
        if(Lead.Pg9Rw18__c == null || Lead.Pg9Rw18__c <= 0 ){
            Lead.Pg9Rw18__c = 0;
        }
        if(Lead.Pg9Rw19__c == null || Lead.Pg9Rw19__c <= 0 ){
            Lead.Pg9Rw19__c = 0;
        }
        if(Lead.Pg9Rw20__c == null || Lead.Pg9Rw20__c <= 0 ){
            Lead.Pg9Rw20__c = 0;
        }
        if(Lead.Pg9Rw21__c == null || Lead.Pg9Rw21__c <= 0 ){
            Lead.Pg9Rw21__c = 0;
        }
        if(Lead.Pg9Rw18_Spouse__c == null || Lead.Pg9Rw18_Spouse__c <= 0 ){
            Lead.Pg9Rw18_Spouse__c = 0;
        }
        if(Lead.Pg9Rw19_Spouse__c == null || Lead.Pg9Rw19_Spouse__c <= 0 ){
            Lead.Pg9Rw19_Spouse__c = 0;
        }
        if(Lead.Pg9Rw20_Spouse__c == null || Lead.Pg9Rw20_Spouse__c <= 0 ){
            Lead.Pg9Rw20_Spouse__c = 0;
        }
        if(Lead.Pg9Rw21_Spouse__c == null || Lead.Pg9Rw21_Spouse__c <= 0 ){
            Lead.Pg9Rw21_Spouse__c = 0;
        }
        if(Lead.Pg10Rw01__c == null || Lead.Pg10Rw01__c <= 0 ){
            Lead.Pg10Rw01__c = 0;
        }
        if(Lead.Pg10Rw02__c == null || Lead.Pg10Rw02__c <= 0 ){
            Lead.Pg10Rw02__c = 0;
        }
        if(Lead.Pg10Rw03__c == null || Lead.Pg10Rw03__c <= 0 ){
            Lead.Pg10Rw03__c = 0;
        }
        if(Lead.Pg10Rw04__c == null || Lead.Pg10Rw04__c <= 0 ){
            Lead.Pg10Rw04__c = 0;
        }
        if(Lead.Pg10Rw01_Spouse__c == null || Lead.Pg10Rw01_Spouse__c <= 0 ){
            Lead.Pg10Rw01_Spouse__c = 0;
        }
        if(Lead.Pg10Rw02_Spouse__c == null || Lead.Pg10Rw02_Spouse__c <= 0 ){
            Lead.Pg10Rw02_Spouse__c = 0;
        }
        if(Lead.Pg10Rw03_Spouse__c == null || Lead.Pg10Rw03_Spouse__c <= 0 ){
            Lead.Pg10Rw03_Spouse__c = 0;
        }
        if(Lead.Pg10Rw04_Spouse__c == null || Lead.Pg10Rw04_Spouse__c <= 0 ){
            Lead.Pg10Rw04_Spouse__c = 0;
        }
        if(Lead.Pg10Rw05__c == null || Lead.Pg10Rw05__c <= 0 ){
            Lead.Pg10Rw05__c = 0;
        }
        if(Lead.Pg10Rw06__c == null || Lead.Pg10Rw06__c <= 0 ){
            Lead.Pg10Rw06__c = 0;
        }
        if(Lead.Pg10Rw07__c == null || Lead.Pg10Rw07__c <= 0 ){
            Lead.Pg10Rw07__c = 0;
        }
        if(Lead.Pg10Rw08__c == null || Lead.Pg10Rw08__c <= 0 ){
            Lead.Pg10Rw08__c = 0;
        }
        if(Lead.Pg10Rw05_Spouse__c == null || Lead.Pg10Rw05_Spouse__c <= 0 ){
            Lead.Pg10Rw05_Spouse__c = 0;
        }
        if(Lead.Pg10Rw06_Spouse__c == null || Lead.Pg10Rw06_Spouse__c <= 0 ){
            Lead.Pg10Rw06_Spouse__c = 0;
        }
        if(Lead.Pg10Rw07_Spouse__c == null || Lead.Pg10Rw07_Spouse__c <= 0 ){
            Lead.Pg10Rw07_Spouse__c = 0;
        }
        if(Lead.Pg10Rw08_Spouse__c == null || Lead.Pg10Rw08_Spouse__c <= 0 ){
            Lead.Pg10Rw08_Spouse__c = 0;
        }
        if(Lead.Pg10Rw09__c == null || Lead.Pg10Rw09__c <= 0 ){
            Lead.Pg10Rw09__c = 0;
        }
        if(Lead.Pg10Rw10__c == null || Lead.Pg10Rw10__c <= 0 ){
            Lead.Pg10Rw10__c = 0;
        }
        if(Lead.Pg10Rw11__c == null || Lead.Pg10Rw11__c <= 0 ){
            Lead.Pg10Rw11__c = 0;
        }
        if(Lead.Pg10Rw12__c == null || Lead.Pg10Rw12__c <= 0 ){
            Lead.Pg10Rw12__c = 0;
        }
        if(Lead.Pg10Rw13__c == null || Lead.Pg10Rw13__c <= 0 ){
            Lead.Pg10Rw13__c = 0;
        }
        if(Lead.Pg10Rw14__c == null || Lead.Pg10Rw14__c <= 0 ){
            Lead.Pg10Rw14__c = 0;
        }
        if(Lead.Pg10Rw09_Spouse__c == null || Lead.Pg10Rw09_Spouse__c <= 0 ){
            Lead.Pg10Rw09_Spouse__c = 0;
        }
        if(Lead.Pg10Rw10_Spouse__c == null || Lead.Pg10Rw10_Spouse__c <= 0 ){
            Lead.Pg10Rw10_Spouse__c = 0;
        }
        if(Lead.Pg10Rw11_Spouse__c == null || Lead.Pg10Rw11_Spouse__c <= 0 ){
            Lead.Pg10Rw11_Spouse__c = 0;
        }
        if(Lead.Pg10Rw12_Spouse__c == null || Lead.Pg10Rw12_Spouse__c <= 0 ){
            Lead.Pg10Rw12_Spouse__c = 0;
        }
        if(Lead.Pg10Rw13_Spouse__c == null || Lead.Pg10Rw13_Spouse__c <= 0 ){
            Lead.Pg10Rw13_Spouse__c = 0;
        }
        if(Lead.Pg10Rw14_Spouse__c == null || Lead.Pg10Rw14_Spouse__c <= 0 ){
            Lead.Pg10Rw14_Spouse__c = 0;
        }
        if(Lead.Pg10Rw15__c == null || Lead.Pg10Rw15__c <= 0 ){
            Lead.Pg10Rw15__c = 0;
        }
        if(Lead.Pg10Rw16__c == null || Lead.Pg10Rw16__c <= 0 ){
            Lead.Pg10Rw16__c = 0;
        }
        if(Lead.Pg10Rw17__c == null || Lead.Pg10Rw17__c <= 0 ){
            Lead.Pg10Rw17__c = 0;
        }
        if(Lead.Pg10Rw18__c == null || Lead.Pg10Rw18__c <= 0 ){
            Lead.Pg10Rw18__c = 0;
        }
        if(Lead.Pg10Rw15_Spouse__c == null || Lead.Pg10Rw15_Spouse__c <= 0 ){
            Lead.Pg10Rw15_Spouse__c = 0;
        }
        if(Lead.Pg10Rw16_Spouse__c == null || Lead.Pg10Rw16_Spouse__c <= 0 ){
            Lead.Pg10Rw16_Spouse__c = 0;
        }
        if(Lead.Pg10Rw17_Spouse__c == null || Lead.Pg10Rw17_Spouse__c <= 0 ){
            Lead.Pg10Rw17_Spouse__c = 0;
        }
        if(Lead.Pg10Rw18_Spouse__c == null || Lead.Pg10Rw18_Spouse__c <= 0 ){
            Lead.Pg10Rw18_Spouse__c = 0;
        }
        if(Lead.Pg10Rw19__c == null || Lead.Pg10Rw19__c <= 0 ){
            Lead.Pg10Rw19__c = 0;
        }
        if(Lead.Pg10Rw19_Spouse__c == null || Lead.Pg10Rw19_Spouse__c <= 0 ){
            Lead.Pg10Rw19_Spouse__c = 0;
        }
        if(Lead.Pg10Rw20__c == null || Lead.Pg10Rw20__c <= 0 ){
            Lead.Pg10Rw20__c = 0;
        }
        if(Lead.Pg10Rw20_Spouse__c == null || Lead.Pg10Rw20_Spouse__c <= 0 ){
            Lead.Pg10Rw20_Spouse__c = 0;
        }
        if(Lead.Pg10Rw21__c == null || Lead.Pg10Rw21__c <= 0 ){
            Lead.Pg10Rw21__c = 0;
        }
        if(Lead.Pg10Rw21_Spouse__c == null || Lead.Pg10Rw21_Spouse__c <= 0 ){
            Lead.Pg10Rw21_Spouse__c = 0;
        }
        if(Lead.Pg10Rw22__c == null || Lead.Pg10Rw22__c <= 0 ){
            Lead.Pg10Rw22__c = 0;
        }
        if(Lead.Pg10Rw22_Spouse__c == null || Lead.Pg10Rw22_Spouse__c <= 0 ){
            Lead.Pg10Rw22_Spouse__c = 0;
        }
        if(Lead.Pg10Rw23__c == null || Lead.Pg10Rw23__c <= 0 ){
            Lead.Pg10Rw23__c = 0;
        }
        if(Lead.Pg10Rw23_Spouse__c == null || Lead.Pg10Rw23_Spouse__c <= 0 ){
            Lead.Pg10Rw23_Spouse__c = 0;
        }
        if(Lead.Additional_Income1__c == null || Lead.Additional_Income1__c <= 0 ){
            Lead.Additional_Income1__c = 0;
        }
        if(Lead.Additional_Income2__c == null || Lead.Additional_Income2__c <= 0 ){
            Lead.Additional_Income2__c = 0;
        }
        if(Lead.Additional_Income3__c == null || Lead.Additional_Income3__c <= 0 ){
            Lead.Additional_Income3__c = 0;
        }
        if(Lead.currentNET__c == null || Lead.currentNET__c <= 0 ){
            Lead.currentNET__c = 0;
        }
        if(Lead.TSP_Contribution__c == null || Lead.TSP_Contribution__c <= 0 ){
            Lead.TSP_Contribution__c = 0;
        }
        if(Lead.TSP_Balance__c == null || Lead.TSP_Balance__c <= 0 ){
            Lead.TSP_Balance__c = 0;
        }
        if(Lead.TSP_Total__c == null || Lead.TSP_Total__c <= 0 ){
            Lead.TSP_Total__c = 0;
        }
        if(Lead.ROTH_Total__c == null || Lead.ROTH_Total__c <= 0 ){
            Lead.ROTH_Total__c = 0;
        }
        if(Lead.TSP_Balance_No_Match__c == null || Lead.TSP_Balance_No_Match__c <= 0 ){
            Lead.TSP_Balance_No_Match__c = 0;
        }
        if(Lead.Scenario1_Retirement_Age__c == null || Lead.Scenario1_Retirement_Age__c <= 0 ){
            Lead.Scenario1_Retirement_Age__c = 0;
        }
        if(Lead.Scenario2_Retirement_Age__c == null || Lead.Scenario2_Retirement_Age__c <= 0 ){
            Lead.Scenario2_Retirement_Age__c = 0;
        }
        if(Lead.ROTH_Contributions__c == null || Lead.ROTH_Contributions__c <= 0 ){
            Lead.ROTH_Contributions__c = 0;
        }
        if(Lead.High_3_Salary__c == null || Lead.High_3_Salary__c <= 0 ){
            Lead.High_3_Salary__c = 0;
        }
        if(Lead.Total_Health__c == null || Lead.Total_Health__c <= 0 ){
            Lead.Total_Health__c = 0;
        }
        if(Lead.Additional_Insurance__c == null || Lead.Additional_Insurance__c <= 0 ){
            Lead.Additional_Insurance__c = 0;
        }
        
        if(Lead.Military_Retirement__c == null || Lead.Military_Retirement__c <= 0 ){
            Lead.Military_Retirement__c = 0;
        }
        if(Lead.Disability_in_Retirement__c == null || Lead.Disability_in_Retirement__c <= 0 ){
            Lead.Disability_in_Retirement__c = 0;
        }
        if(Lead.Scenario1_YOS__c == null || Lead.Scenario1_YOS__c <= 0 ){
            Lead.Scenario1_YOS__c = 0;
        }
        if(Lead.High_3_Salary2__c == null || Lead.High_3_Salary2__c <= 0 ){
            Lead.High_3_Salary2__c = 0;
        }
        if(Lead.Scenario2_YOS__c == null || Lead.Scenario2_YOS__c <= 0 ){
            Lead.Scenario2_YOS__c = 0;
        }
        
        if(Lead.Starting_Age__c == null || Lead.Starting_Age__c <= 0 ){
            Lead.Starting_Age__c = 0;
        }
        if(Lead.Standard_Monthly__c == null || Lead.Standard_Monthly__c <= 0 ){
            Lead.Standard_Monthly__c = 0;
        }
        if(Lead.Standard_Amount__c == null || Lead.Standard_Amount__c <= 0 ){
            Lead.Standard_Amount__c = 0;
        }
        if(Lead.AnnualRevenue == null || Lead.AnnualRevenue <= 0 ){
            Lead.AnnualRevenue = 0;
        }
        if(Lead.NumberOfEmployees == null || Lead.NumberOfEmployees <= 0 ){
            Lead.NumberOfEmployees = 0;
        }
        if(Lead.X401K_TaxFree__c == null || Lead.X401K_TaxFree__c <= 0 ){
            Lead.X401K_TaxFree__c = 0;
        }
        if(Lead.X401K_Tax__c == null || Lead.X401K_Tax__c <= 0 ){
            Lead.X401K_Tax__c = 0;
        }
        if(Lead.totalExpenses_Spouse__c == null || Lead.totalExpenses_Spouse__c <= 0 ){
            Lead.totalExpenses_Spouse__c = 0;
        }
        if(Lead.totalExpenses__c == null || Lead.totalExpenses__c <= 0 ){
            Lead.totalExpenses__c = 0;
        }
        if(Lead.totalTaxes_Currency__c == null || Lead.totalTaxes_Currency__c <= 0 ){
            Lead.totalTaxes_Currency__c = 0;
        }
        
        if(Lead.Age__c == null || Lead.Age__c <= 0 ){
            Lead.Age__c = 0;
        }
        if(Lead.Years_of_Service__c == null || Lead.Years_of_Service__c <= 0 ){
            Lead.Years_of_Service__c = 0;
        }
        if(Lead.AgeFactorformula_OptionB_Text__c == null || Lead.AgeFactorformula_OptionB_Text__c <= 0 ){
            Lead.AgeFactorformula_OptionB_Text__c = 0;
        }
        if(Lead.AgeFactorformula_OptionC_Text__c == null || Lead.AgeFactorformula_OptionC_Text__c <= 0 ){
            Lead.AgeFactorformula_OptionC_Text__c = 0;
        }
        if(Lead.CSRS_Annuity_Retirement__c == null || Lead.CSRS_Annuity_Retirement__c <= 0 ){
            Lead.CSRS_Annuity_Retirement__c = 0;
        }
        if(Lead.Catchup_Contribution__c == null || Lead.Catchup_Contribution__c <= 0 ){
            Lead.Catchup_Contribution__c = 0;
        }
        if(Lead.Monthly_Contribution__c == null || Lead.Monthly_Contribution__c <= 0 ){
            Lead.Monthly_Contribution__c = 0;
        }
        if(Lead.Monthly_ROTH_Contribution__c == null || Lead.Monthly_ROTH_Contribution__c <= 0 ){
            Lead.Monthly_ROTH_Contribution__c = 0;
        }
        if(Lead.ROTH_TSP_Contribution__c == null || Lead.ROTH_TSP_Contribution__c <= 0 ){
            Lead.ROTH_TSP_Contribution__c = 0;
        }
        if(Lead.Regular_Contribution__c == null || Lead.Regular_Contribution__c <= 0 ){
            Lead.Regular_Contribution__c = 0;
        }
        if(Lead.Remaining_Years__c == null || Lead.Remaining_Years__c <= 0 ){
            Lead.Remaining_Years__c = 0;
        }
        if(Lead.YOS_Special_Supplement__c == null || Lead.YOS_Special_Supplement__c <= 0 ){
            Lead.YOS_Special_Supplement__c = 0;
        }
        if(Lead.total_Years__c == null || Lead.total_Years__c <= 0 ){
            Lead.total_Years__c = 0;
        }
        
        TSP_Const_Balance_Value = this.lead.TSP_Balance_No_Match__c;

        FERSValue = this.lead.FERS__c;
        SpecialCheck = this.lead.Special_Group_Member__c;

        List < TSP_Contribution__mdt > allRecords = [SELECT MasterLabel, Regular_Contribution__c, Catch_Up_Contribution__c FROM TSP_Contribution__mdt ORDER BY MasterLabel ASC];
        if (allRecords.size() >= 2) {
            previousYear = allRecords[0];
            currentYear = allRecords[1];
        }

        // SM Starts
        // if (lead.Scenario1_Retirement_Age__c != null && lead.Date_of_Birth__c != null && lead.Date_of_Hire__c != null) {
        //     Integer yearsOfService = (Integer)Math.floor((lead.Date_of_Birth__c.daysBetween(lead.Date_of_Hire__c)) / 365.25);
        //     timesXYOS = lead.Scenario1_Retirement_Age__c - Math.abs(yearsOfService);
        // }
        if (lead.Scenario1_Retirement_Age__c != null && lead.Scenario1_Retirement_Age__c != 0 && lead.Date_of_Birth__c != null && lead.Date_of_Hire__c != null) {
            Integer yearsOfService = (Integer) Math.floor((lead.Date_of_Birth__c.daysBetween(lead.Date_of_Hire__c)) / 365.25);
            scenario1XYOS = lead.Scenario1_Retirement_Age__c - Math.abs(yearsOfService);
        }

        if (lead.Scenario2_Retirement_Age__c != null && lead.Scenario2_Retirement_Age__c != 0 && lead.Date_of_Birth__c != null && lead.Date_of_Hire__c != null) {
            Integer yearsOfService = (Integer) Math.floor((lead.Date_of_Birth__c.daysBetween(lead.Date_of_Hire__c)) / 365.25);
            scenario2XYOS = lead.Scenario2_Retirement_Age__c - Math.abs(yearsOfService);
        }

        if (
            (Lead.Scenario1_Primary__c == true && Lead.Scenario1_Retirement_Age__c < 62) ||
            (Lead.Scenario2_Primary__c == true && Lead.Scenario2_Retirement_Age__c < 62) ||
            (Lead.Scenario1_Primary__c == false && Lead.Scenario2_Primary__c == false && Lead.Expected_Retirement_Age__c < 62)
        ) {
            fERSSpecialSupplementValue = (Decimal)Math.floor(Lead.Predicted_Social_Security__c * (Lead.YOS_Special_Supplement__c / 40)
            );
        }
        // Not eligible (age > 62 conditions)
        else {
            fERSSpecialSupplementValue = 0;
        }



        if (
            (lead.Scenario1_Primary__c == true && lead.Scenario1_Retirement_Age__c < 62) ||
            (lead.Scenario2_Primary__c == true && lead.Scenario2_Retirement_Age__c < 62) ||
            (lead.Scenario1_Primary__c == false && lead.Scenario2_Primary__c == false && lead.Expected_Retirement_Age__c < 62)
        ) {
            SocialSecurityValue = 0;
        }
        else{
            SocialSecurityValue = Lead.Predicted_Social_Security__c;
        }
        
        if((lead.Scenario1_Primary__c == true && lead.Scenario1_Retirement_Age__c < 62) ||(lead.Scenario2_Primary__c == true && lead.Scenario2_Retirement_Age__c < 62) ){
            SpecialAndSupplementVal = fERSSpecialSupplementValue;
        }
        else{
            SpecialAndSupplementVal = SocialSecurityValue;
        }

        if(Lead.High_3_Salary__c == null || Lead.High_3_Salary__c < 0){
            Lead.High_3_Salary__c = 0;
        }
         if(Lead.Remaining_Years__c == null || Lead.Remaining_Years__c < 0){
            Lead.Remaining_Years__c = 0;
        }
        pensionMinValue = (((((Lead.High_3_Salary__c * 0.017) * 20) + ((Lead.High_3_Salary__c * 0.01) * Lead.Remaining_Years__c)) / 12)) - (((((Lead.High_3_Salary__c * 0.017) * 20) + ((Lead.High_3_Salary__c * 0.01) * Lead.Remaining_Years__c)) / 12) * 0.05);

        pensionMaxValue = (((((Lead.High_3_Salary__c * 0.017) * 20) + ((Lead.High_3_Salary__c * 0.01) * Lead.Remaining_Years__c)) / 12)) - (((((Lead.High_3_Salary__c * 0.017) * 20) + ((Lead.High_3_Salary__c * 0.01) * Lead.Remaining_Years__c)) / 12) * 0.10);

        // if(((Lead.TSP_Balance_No_Match__c == 0 || Lead.TSP_Balance_No_Match__c == null) && (Lead.ROTH_Contributions__c == 0 ||  Lead.ROTH_Contributions__c == null)) || (Lead.AnnualWithdraw1__c == '' && Lead.AnnualWithdraw2__c == '')){
        //     TspCalculateValue=112;
        // }

        // if(((Lead.TSP_Balance_No_Match__c == 0  || Lead.TSP_Balance_No_Match__c == null) && (Lead.ROTH_Contributions__c == 0 ||  Lead.ROTH_Contributions__c == null)) || (Lead.AnnualWithdraw1__c == '' && Lead.AnnualWithdraw2__c == '') || (Lead.AnnualWithdraw1__c == null && Lead.AnnualWithdraw2__c == null)  ){
        //      TspCalculateValue=0;
        // }

        Decimal AnnualWithdraw1 = 0;
        if(String.isNotBlank(Lead.AnnualWithdraw1__c)){
            String withdrawStr = Lead.AnnualWithdraw1__c.replace('%','').trim();
            AnnualWithdraw1 = Decimal.valueOf(withdrawStr) / 100;
        }
        // TspCalculateValue=AnnualWithdraw1;

        Decimal AnnualWithdraw2 = 0;
        if(String.isNotBlank(Lead.AnnualWithdraw2__c)){
            String withdrawStr = Lead.AnnualWithdraw2__c.replace('%','').trim();
            AnnualWithdraw2 = Decimal.valueOf(withdrawStr) / 100;
        }
        // TspCalculateValue=AnnualWithdraw2;

        Decimal taxRate5_Picklist = 0;
        if(String.isNotBlank(Lead.taxRate5_Picklist__c)){
            String withdrawStr = Lead.taxRate5_Picklist__c.replace('%','').trim();
            taxRate5_Picklist = Decimal.valueOf(withdrawStr) / 100;
        }
        // TspCalculateValue=taxRate5_Picklist;

        if(Lead.TSP_Balance_No_Match__c != 0 &&  AnnualWithdraw1 != 0 && (Lead.ROTH_Contributions__c == 0 || Lead.ROTH_Contributions__c == NULL || AnnualWithdraw2 == 0)){
            TspCalculateValue =  ((Lead.TSP_Balance_No_Match__c * AnnualWithdraw1) / 12) - (taxRate5_Picklist * ((Lead.TSP_Balance_No_Match__c * AnnualWithdraw1) / 12));
        }

        if((Lead.ROTH_Contributions__c != 0 && AnnualWithdraw2 !=0 && (Lead.TSP_Balance_No_Match__c == 0 || Lead.TSP_Balance_No_Match__c == NULL || AnnualWithdraw1 == 0))){
            TspCalculateValue = (Lead.ROTH_Contributions__c * AnnualWithdraw2 / 12);
        }

        if( Lead.TSP_Balance_No_Match__c != 0 && AnnualWithdraw1 != 0 && Lead.ROTH_Contributions__c != 0 && AnnualWithdraw2 != 0 ) {
            TspCalculateValue = ( ((Lead.TSP_Balance_No_Match__c * AnnualWithdraw1) / 12) - (taxRate5_Picklist * ((Lead.TSP_Balance_No_Match__c * AnnualWithdraw1) / 12)) + ((Lead.ROTH_Contributions__c * AnnualWithdraw2) / 12));
        }

        if(( (Lead.TSP_Balance_No_Match__c == 0 || Lead.TSP_Balance_No_Match__c == NULL) && (Lead.ROTH_Contributions__c == 0 || Lead.ROTH_Contributions__c == NULL) || (AnnualWithdraw1 == 0 && AnnualWithdraw2 == 0)) ){
            TspCalculateValue=0;
        }



        // SM Ends

        /*     
            lead= [SELECT Id, FirstName, LastName, MiddleName, Name, Street, City, State, PostalCode, Phone, LeadPhone_Formatted__c, MobilePhone, MobilePhone_Formatted__c, Best_Day_of_the_Week_to_Contact__c, Best_Time_to_Contact__c, 
                    Prefer_Text__c, Email, Employment_Status__c, Company, Title, Date_of_Birth__c, Contact_Age__c, Date_of_Hire__c, Years_of_Employment__c, Expected_Retirement_Date__c, Expected_Retirement_Age__c,
                    Base_Salary__c, Salary_Interval__c, Spouse_Name__r.Name, Marital_Status__c, Spouse_Name__r.Date_of_Birth__c, Spouse_Name__r.Contact_Age__c, Spouse_Name__r.ContactPhone_Formatted__c, Spouse_Name__r.Phone, Description,
                    Snapshot_Flow_Completed__c, Federal_Employee__c, TSP_Contribution__c, TSP_Balance__c, FEGLI_Code__c, AgeFactorformula_Basic__c, AgeFactorformula_FEGLI__c, FEGLI_Plan__c,
                    Option_B_Choice_Selection__c, Option_C_Choice_Selection__c, OptionC__c, OptionB__c, OptionA__c, Basic__c, FERS__c, CSRS_Offset__c, CSRS__c,  hiddenExtraBenefitformula__c, hiddenTotalBenefitformula__c, 
                    formula_basePay__c, MultiplesFactorformula_OptionC__c, MultiplesFactorformula_OptionB__c, AgeFactorformula_OptionC__c, AgeFactorformula_OptionB__c, OptionB_Insurance_Cover__c,
                    numberYears__c, Affiliation__c, Years_35_39__c, formula_Years_35_39__c, Years_40_44__c, Years_45_49__c, Years_50_54__c, Years_55_59__c, Years_60_64__c, 
                    Years_65_69__c, Years_70_74__c, Years_75_79__c, Years_80__c, Years_34__c, formula_Years_45_49__c, formula_Years_50_54__c, formula_Years_55_59__c, formula_Years_40_44__c, formula_Years_60_64__c, 
                    formula_Years_65_69__c, formula_Years_70_74__c, formula_Years_75_79__c, formula_Years_80__c, formula_Years_34__c, X34__c, X35_39__c, X40_44__c, X45_49__c, X50_54__c, X55_59__c, X60_64__c, X65_69__c, 
                    X70_74__c, X75_79__c, X80__c, Standard_Amount__c, Standard_Monthly__c, Standard_BiWeekly__c, CSRS_Annuity_Retirement__c, High_3_Salary__c, Federal_Indicator__c FROM Lead WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
                
        */

    }

    public Lead getLead() {
        return lead;
    }

    public PageReference RerenderPage() {
        PageReference Calculate = new PageReference('/apex/GPIS_Federal_Workbook?id=' + lead.id);
        Calculate.setRedirect(true);
        lead.Snapshot_Flow_Completed__c = true;
        update lead;

        return null;
    }

    public Date Today {
        get {
            return Date.today();
        }
    }

    public PageReference states() {
        return null;
    }

    public PageReference fegliValues() {
        return null;
    }

    public PageReference displayPage() {
        update lead;
        return null;
    }


    public PageReference getPage() {
        PageReference Page = NEW PageReference('/apex/GPIS_Federal_Workbook?id=' + lead.id);
        return Page;

    }

    public PageReference startingAgeSet() {
        PageReference startingAge = new PageReference('/apex/GPIS_Federal_Workbook?id=' + lead.id);
        startingAge.setRedirect(true);
        lead.Starting_Age_Set__c = true;
        update lead;

        return null;

    }

    public PageReference SpouseUpdate() {
        PageReference updateSpouse = new PageReference('/flow/contact_create_update_spouse?recordId=' + lead.id);
        updateSpouse.setRedirect(TRUE);
        RETURN updateSpouse;
    }


    public String defaultState {
        get {
            return lead.State;
        }
    }


    public String fegliPicklist {
        get {
            return lead.FEGLI_Code_Picklist__c;
        }
    }



    public List < SelectOption > getItems() {
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption(defaultState, defaultState));
        options.add(new SelectOption('AL', 'AL'));
        options.add(new SelectOption('AK', 'AK'));
        options.add(new SelectOption('AZ', 'AZ'));
        options.add(new SelectOption('AR', 'AR'));
        options.add(new SelectOption('CA', 'CA'));
        options.add(new SelectOption('CZ', 'CZ'));
        options.add(new SelectOption('CO', 'CO'));
        options.add(new SelectOption('CT', 'CT'));
        options.add(new SelectOption('DE', 'DE'));
        options.add(new SelectOption('DC', 'DC'));
        options.add(new SelectOption('FL', 'FL'));
        options.add(new SelectOption('GA', 'GA'));
        options.add(new SelectOption('GU', 'GU'));
        options.add(new SelectOption('HI', 'HI'));
        options.add(new SelectOption('ID', 'ID'));
        options.add(new SelectOption('IL', 'IL'));
        options.add(new SelectOption('IN', 'IN'));
        options.add(new SelectOption('IA', 'IA'));
        options.add(new SelectOption('KS', 'KS'));
        options.add(new SelectOption('KY', 'KY'));
        options.add(new SelectOption('LA', 'LA'));
        options.add(new SelectOption('ME', 'ME'));
        options.add(new SelectOption('MD', 'MD'));
        options.add(new SelectOption('MA', 'MA'));
        options.add(new SelectOption('MI', 'MI'));
        options.add(new SelectOption('MN', 'MN'));
        options.add(new SelectOption('MS', 'MS'));
        options.add(new SelectOption('MO', 'MO'));
        options.add(new SelectOption('MT', 'MT'));
        options.add(new SelectOption('NE', 'NE'));
        options.add(new SelectOption('NV', 'NV'));
        options.add(new SelectOption('NH', 'NH'));
        options.add(new SelectOption('NJ', 'NJ'));
        options.add(new SelectOption('NM', 'NM'));
        options.add(new SelectOption('NY', 'NY'));
        options.add(new SelectOption('NC', 'NC'));
        options.add(new SelectOption('ND', 'ND'));
        options.add(new SelectOption('OH', 'OH'));
        options.add(new SelectOption('OK', 'OK'));
        options.add(new SelectOption('OR', 'OR'));
        options.add(new SelectOption('PA', 'PA'));
        options.add(new SelectOption('PR', 'PR'));
        options.add(new SelectOption('RI', 'RI'));
        options.add(new SelectOption('SC', 'SC'));
        options.add(new SelectOption('SD', 'SD'));
        options.add(new SelectOption('TN', 'TN'));
        options.add(new SelectOption('TX', 'TX'));
        options.add(new SelectOption('UT', 'UT'));
        options.add(new SelectOption('VT', 'VT'));
        options.add(new SelectOption('VI', 'VI'));
        options.add(new SelectOption('VA', 'VA'));
        options.add(new SelectOption('WA', 'WA'));
        options.add(new SelectOption('WV', 'WV'));
        options.add(new SelectOption('WI', 'WI'));
        options.add(new SelectOption('WY', 'WY'));

        return options;

    }
    public String[] getStates() {
        return states;
    }

    public void setStates(String[] states) {
        this.states = states;
    }

    public Boolean getmin() {
        return lead.min__c;
    }

    public Boolean getmax() {
        return lead.max__c;
    }

    public PageReference setmin() {
        if (lead.min__c == true) {
            lead.max__c = false;
            lead.Snapshot_Flow_Completed__c = false;
            update lead;
        }
        return null;
    }

    public PageReference setmax() {
        if (lead.max__c == true) {
            lead.min__c = false;
            lead.Snapshot_Flow_Completed__c = false;
            update lead;
        }
        return null;
    }


    public Boolean getprimary1() {
        return lead.Scenario1_Primary__c;
    }

    public Boolean getprimary2() {
        return lead.Scenario2_Primary__c;
    }

    public PageReference setprimary1() {
        PageReference Primary1 = new PageReference('/apex/GPIS_Federal_Workbook?id=' + lead.id);
        Primary1.setRedirect(true);
        if (lead.Scenario1_Primary__c == true) {
            lead.Scenario2_Primary__c = false;
            update lead;
        }
        return null;
    }

    public PageReference setprimary2() {
        PageReference Primary2 = new PageReference('/apex/GPIS_Federal_Workbook?id=' + lead.id);
        Primary2.setRedirect(true);
        if (lead.Scenario2_Primary__c == true) {
            lead.Scenario1_Primary__c = false;
            update lead;
        }
        return null;
    }


    public PageReference setcheckBoxes() {
        PageReference checkboxes = new PageReference('/apex/GPIS_Federal_Workbook?id=' + lead.id);
        checkboxes.setRedirect(true);
        if (lead.OptionA__c == false || (lead.FEGLI_Code_Picklist__c != 'Co' && (!lead.FEGLI_Code_Picklist__c.contains('E')) || (!lead.FEGLI_Code_Picklist__c.contains('F')) && lead.FEGLI_Code_Picklist__c != 'Go' && (!lead.FEGLI_Code_Picklist__c.contains('I')) && lead.FEGLI_Code_Picklist__c != 'Ko' && lead.FEGLI_Code_Picklist__c != 'Lo' && (!lead.FEGLI_Code_Picklist__c.contains('M')) && (!lead.FEGLI_Code_Picklist__c.contains('Q')) && lead.FEGLI_Code_Picklist__c != 'So' && (!lead.FEGLI_Code_Picklist__c.contains('U')) && lead.FEGLI_Code_Picklist__c != 'Wo' && lead.FEGLI_Code_Picklist__c != 'Xo' && (!lead.FEGLI_Code_Picklist__c.contains('Y')))) {
            lead.OptionA__c = false;
            update lead;
        } else if (lead.Basic__c == false || (lead.FEGLI_Code_Picklist__c == 'Ao' || lead.FEGLI_Code_Picklist__c == 'Bo')) {
            lead.Basic__c = false;
            update lead;
        } else if (lead.OptionB__c || (lead.FEGLI_Code_Picklist__c == 'Ao' || lead.FEGLI_Code_Picklist__c == 'Bo' || lead.FEGLI_Code_Picklist__c == 'Co' || lead.FEGLI_Code_Picklist__c == 'Do' || lead.FEGLI_Code_Picklist__c.contains('E') || lead.FEGLI_Code_Picklist__c.contains('F'))) {
            lead.OptionB__c = false;
            update lead;
        } else if (lead.OptionC__c == false || (!lead.FEGLI_Code_Picklist__c.contains('1')) && (!lead.FEGLI_Code_Picklist__c.contains('2')) && (!lead.FEGLI_Code_Picklist__c.contains('3')) && (!lead.FEGLI_Code_Picklist__c.contains('4')) && (!lead.FEGLI_Code_Picklist__c.contains('5'))) {
            lead.OptionC__c = false;
            update lead;
        } else {
            update lead;
        }
        return checkboxes;
    }


    public PageReference resetCodes() {
        PageReference resetCode = NEW PageReference('/apex/GPIS_Federal_Workbook?id=' + lead.id);
        lead.Basic__c = false;
        lead.OptionA__c = false;
        lead.OptionB__c = false;
        lead.OptionC__c = false;
        lead.FEGLI_Code_Picklist__c = '--';
        lead.Option_B_Choice_Selection__c = null;
        lead.Option_C_Choice_Selection__c = null;
        lead.Multiples_C_Manual__c = null;
        lead.Multiples_B_Manual__c = null;
        update lead;
        return null;
    }





    public String[] getfegliValues() {
        return fegliValues;

    }

    public void setfegliValues(String[] fegliValues) {
        this.fegliValues = fegliValues;
    }

    public PageReference pdfAction() {
        Lead currentClient = [SELECT Id, Workbook_Version__c FROM Lead WHERE Id = :lead.Id];

        if(currentClient.Workbook_Version__c==null){
            currentClient.Workbook_Version__c = 1.0;
        }

        string pdfTitle = 'GPIS Federal Retirement Planning Workbook_v'+currentClient.Workbook_Version__c+'_'+ string.valueOf(System.Today());
        System.debug('Workbook pdfTitle: '+pdfTitle);
        currentClient.Workbook_Version__c++;
        UPDATE currentClient;

        PageReference savepage;
        savepage = Page.Federal_Workbook_PDF;
        savepage.getParameters().put('id', lead.id);
        savepage.setRedirect(true);

        Blob pdfBlob;
        if (!Test.IsRunningTest()) {
            pdfBlob = savepage.getContent();
        } else {
            pdfBlob = BLOB.valueOf('UNIT.TEST');
        }

        ContentVersion pdf = new ContentVersion();
        pdf.Title = pdfTitle;
        pdf.VersionData = pdfBlob;
        pdf.ContentLocation = 'S';
        pdf.Origin = 'C';
        pdf.PathOnClient = pdfTitle + '.pdf';

        INSERT pdf;

        ContentVersion pdf2 = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: pdf.Id];

        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = lead.id;
        cdl.ContentDocumentId = pdf2.ContentDocumentId;
        cdl.shareType = 'V';
        cdl.Visibility = 'AllUsers';

        INSERT cdl;

        UPDATE lead;

        PageReference pageRef = new PageReference('/' + lead.id);

        pageRef.setRedirect(TRUE);

        RETURN pageRef;

    }


    public PageReference pdfActionEmail() {
        string title = 'GPIS Federal Retirement Planning Workbook ' + string.valueOf(System.Today());

        PageReference savepage;
        savepage = Page.Federal_Workbook_PDF;
        savepage.getParameters().put('id', lead.id);
        savepage.setRedirect(true);

        Blob pdfBlob;
        if (!Test.IsRunningTest()) {
            pdfBlob = savepage.getContent();
        } else {
            pdfBlob = BLOB.valueOf('UNIT.TEST');
        }

        ContentVersion pdf = new ContentVersion();
        pdf.Title = 'GPIS Federal Retirement Planning Workbook ' + string.valueOf(System.Today());
        pdf.VersionData = pdfBlob;
        pdf.ContentLocation = 'S';
        pdf.Origin = 'C';
        pdf.PathOnClient = Title + '.pdf';

        INSERT pdf;

        ContentVersion pdf2 = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: pdf.Id];

        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = lead.id;
        cdl.ContentDocumentId = pdf2.ContentDocumentId;
        cdl.shareType = 'V';
        cdl.Visibility = 'AllUsers';

        INSERT cdl;
        UPDATE lead;

        PageReference pageRef = new PageReference('/flow/Send_Client_Email?recordId=' + lead.id + '&retURL=' + lead.id);

        pageRef.setRedirect(TRUE);

        RETURN pageRef;

    }


    public PageReference downloadFile() {
        Lead currentClient = [SELECT Id, OBEF_Version__c FROM Lead WHERE Id = :lead.Id];

        if(currentClient.OBEF_Version__c==null){
            currentClient.OBEF_Version__c = 1.0;
        }
        string pdfTitle = 'OBEF Form_v' + currentClient.OBEF_Version__c+'_' + string.valueOf(System.Today());

        System.debug('OBEF pdfTitle: '+pdfTitle);
        currentClient.OBEF_Version__c++;
        UPDATE currentClient;


        PageReference savepage;
        savepage = Page.OBEF_Locked_PDF;
        savepage.getParameters().put('id', lead.id);
        savepage.setRedirect(true);

        Blob pdfBlob;
        if (!Test.IsRunningTest()) {
            pdfBlob = savepage.getContent();
        } else {
            pdfBlob = BLOB.valueOf('UNIT.TEST');
        }

        ContentVersion pdf = new ContentVersion();
        pdf.Title = pdfTitle;
        pdf.VersionData = pdfBlob;
        pdf.ContentLocation = 'S';
        pdf.Origin = 'C';
        pdf.PathOnClient = pdfTitle + '.pdf';

        INSERT pdf;

        ContentVersion pdf2 = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: pdf.Id];

        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = lead.id;
        cdl.ContentDocumentId = pdf2.ContentDocumentId;
        cdl.shareType = 'V';
        cdl.Visibility = 'AllUsers';

        INSERT cdl;

        UPDATE lead;

        PageReference fileDL = new PageReference('/sfc/servlet.shepherd/version/download/' + pdf.Id + '?asPdf=false&operationContext=CHATTER');

        fileDL.setRedirect(TRUE);

        RETURN fileDL;

    }

    public PageReference Unlock() {
        PageReference resetPage = NEW PageReference('/apex/GPIS_Federal_Workbook?id=' + lead.id);
        lead.Starting_Age_Set__c = false;
        update lead;

        return null;
    }



    public PageReference Reset() {
        PageReference resetPage = NEW PageReference('/apex/GPIS_Federal_Workbook?id=' + lead.id);
        lead.Starting_Age__c = 0;
        //   lead.Total_of_Years__c = '0';
        lead.Years_34__c = '0';
        lead.Years_35_39__c = '0';
        lead.Years_40_44__c = '0';
        lead.Years_45_49__c = '0';
        lead.Years_50_54__c = '0';
        lead.Years_55_59__c = '0';
        lead.Years_60_64__c = '0';
        lead.Years_65_69__c = '0';
        lead.Years_70_74__c = '0';
        lead.Years_75_79__c = '0';
        lead.Years_80__c = '0';
        lead.Standard_Amount__c = 0;
        lead.Standard_Monthly__c = 0;
        lead.Starting_Age_Set__c = false;

        update lead;

        return null;

    }



    public PageReference save() {

        System.debug('Before scenario2XYOS the Save'+ scenario2XYOS);
        System.debug('Before scenario1XYOS the Save'+ scenario1XYOS);

        lead.Snapshot_Flow_Completed__c = false;
        this.lead.FERS__c = FERSValue;
        this.lead.Special_Group_Member__c = SpecialCheck;

        // old value logic (from previous message)
        Lead oldLead = [SELECT Id, FERS__c, Special_Group_Member__c, Scenario1_Primary__c, Scenario2_Primary__c, Min__c, Max__c FROM Lead WHERE Id = :lead.Id];

        if (this.lead.FERS__c != oldLead.FERS__c) {
            this.lead.Special_Group_Member__c = !this.lead.FERS__c;
        } else if (this.lead.Special_Group_Member__c != oldLead.Special_Group_Member__c) {
            this.lead.FERS__c = !this.lead.Special_Group_Member__c;
        }

        if (this.lead.Scenario1_Primary__c != oldLead.Scenario1_Primary__c) {
            this.lead.Scenario2_Primary__c = !this.lead.Scenario1_Primary__c;
        } else if (this.lead.Scenario2_Primary__c != oldLead.Scenario2_Primary__c) {
            this.lead.Scenario1_Primary__c = !this.lead.Scenario2_Primary__c;
        }

        if (this.lead.Min__c != oldLead.Min__c) {
            this.lead.Max__c = !this.lead.Min__c;
        } else if (this.lead.Max__c != oldLead.Max__c) {
            this.lead.Min__c = !this.lead.Max__c;
        }

        update lead;

        FERSValue = lead.FERS__c;
        SpecialCheck = lead.Special_Group_Member__c;

        Lead newLead = [
            SELECT FEGLI_Code_Picklist__c, OptionA__c, Age_Option_A_Manual__c, Contact_Age__c, OptionC__c, Age_Option_C_Manual__c, Multiples_C_Manual__c, AgeFactorformula_OptionC__c, FirstName, LastName, MiddleName, Street, City, PostalCode, MobilePhone_Formatted__c, LeadPhone_Formatted__c, Best_Day_of_the_Week_to_Contact__c, Best_Time_to_Contact__c, Prefer_Text__c, Email, Employment_Status__c, Company, Title, Date_of_Birth__c, Date_of_Hire__c, Years_of_Employment__c, Expected_Retirement_Date__c, Expected_Retirement_Age__c, Base_Salary__c, Salary_Interval__c, Marital_Status__c, Spouse_Name__r.Name, Spouse_Name__r.Date_of_Birth__c, Spouse_Name__r.Phone, Description, Predicted_Social_Security__c, Spouse_Social_Security__c, Predicted_Pension__c, Spouse_Pension__c, Pg7Rw3__c, Pg7Rw3_Spouse__c, Pg7Rw4__c, Pg7Rw4_Spouse__c, Pg7Rw5__c, Pg7Rw5_Spouse__c, Pg7Rw6__c, Pg7Rw6_Spouse__c, Pg7Rw7__c, Pg7Rw7_Spouse__c, Pg7Rw8__c, Pg7Rw8_Spouse__c, Pg7Rw9__c, Pg7Rw9_Spouse__c, Pg7Rw10__c, Pg7Rw10_Spouse__c, Pg8Rw1__c, Pg8Rw1_Spouse__c, Pg8Rw2__c, Pg8Rw2_Spouse__c, Pg8Rw3__c, Pg8Rw3_Spouse__c, Pg8Rw4__c, Pg8Rw4_Spouse__c, Pg8Rw5__c, Pg8Rw5_Spouse__c, Pg8Rw6__c, Pg8Rw6_Spouse__c, Pg8Rw7__c, Pg8Rw7_Spouse__c, Pg8Rw8__c, Pg8Rw8_Spouse__c, Pg8Rw9__c, Pg8Rw9_Spouse__c, Pg8Rw10__c, Pg8Rw10_Spouse__c, Pg8Rw11__c, Pg8Rw11_Spouse__c, Pg9Rw01__c, Pg9Rw02__c, Pg9Rw03__c, Pg9Rw04__c, Pg9Rw05__c, Pg9Rw06__c, Pg9Rw01_Spouse__c, Pg9Rw02_Spouse__c, Pg9Rw03_Spouse__c, Pg9Rw04_Spouse__c, Pg9Rw05_Spouse__c, Pg9Rw06_Spouse__c, Pg9Rw07__c, Pg9Rw08__c, Pg9Rw09__c, Pg9Rw10__c, Pg9Rw11__c, Pg9Rw07_Spouse__c, Pg9Rw08_Spouse__c, Pg9Rw09_Spouse__c, Pg9Rw10_Spouse__c, Pg9Rw11_Spouse__c, Pg9Rw12__c, Pg9Rw13__c, Pg9Rw14__c, Pg9Rw15__c, Pg9Rw16__c, Pg9Rw17__c, Pg9Rw12_Spouse__c, Pg9Rw13_Spouse__c, Pg9Rw14_Spouse__c, Pg9Rw15_Spouse__c, Pg9Rw16_Spouse__c, Pg9Rw17_Spouse__c, Pg9Rw18__c, Pg9Rw19__c, Pg9Rw20__c, Pg9Rw21__c, Pg9Rw18_Spouse__c, Pg9Rw19_Spouse__c, Pg9Rw20_Spouse__c, Pg9Rw21_Spouse__c, Pg10Rw01__c, Pg10Rw02__c, Pg10Rw03__c, Pg10Rw04__c, Pg10Rw01_Spouse__c, Pg10Rw02_Spouse__c, Pg10Rw03_Spouse__c, Pg10Rw04_Spouse__c, Pg10Rw05__c, Pg10Rw06__c, Pg10Rw07__c, Pg10Rw08__c, Pg10Rw05_Spouse__c, Pg10Rw06_Spouse__c, Pg10Rw07_Spouse__c, Pg10Rw08_Spouse__c, Pg10Rw09__c, Pg10Rw10__c, Pg10Rw11__c, Pg10Rw12__c, Pg10Rw13__c, Pg10Rw14__c, Pg10Rw09_Spouse__c, Pg10Rw10_Spouse__c, Pg10Rw11_Spouse__c, Pg10Rw12_Spouse__c, Pg10Rw13_Spouse__c, Pg10Rw14_Spouse__c, Pg10Rw15__c, Pg10Rw16__c, Pg10Rw17__c, Pg10Rw18__c, Pg10Rw15_Spouse__c, Pg10Rw16_Spouse__c, Pg10Rw17_Spouse__c, Pg10Rw18_Spouse__c, Pg10Rw19__c, Pg10Rw19_Spouse__c, Pg10Rw20__c, Pg10Rw20_Spouse__c, Pg10Rw21__c, Pg10Rw21_Spouse__c, Pg10Rw22__c, Pg10Rw22_Spouse__c, Pg10Rw23__c, Pg10Rw23_Spouse__c, Snapshot_Flow_Completed__c, Investment_Risk_Question_1__c, Investment_Risk_Question_2__c, Investment_Risk_Question_3__c, Investment_Risk_Question_4__c, Name, Spouse_Name__r.Contact_Age__c, taxRate1_Picklist__c, taxRate2_Picklist__c, taxRate3_Picklist__c, taxRate4_Picklist__c, totalTaxes__c, formula_totalHealth__c, formula_addlInsurance__c, combined_Expenses__c, Additional_Income1__c, BottomLine__c, Additional_Income2__c, Additional_Income3__c, subTotal__c, currentNET__c, formula_401k_Tax__c, AnnualWithdraw1__c, taxRate5_Picklist__c, GAP_Difference__c, formula_401k_TaxFREE__c, AnnualWithdraw2__c, IRA_401_k__c, pre_tax_Total__c, Appointment_Time__c, Referral__c, Referred_By__c, Federal_Employee__c, Spouse_Name__r.Account.Name, Spouse_Name__r.Title, State, Spouse_Name__r.Date_of_Hire__c, FERS__c, Special_Group_Member__c, Basic__c, OptionB__c, FEGLI_Code__c, TSP_Contribution__c, TSP_Balance__c, TSP_Total__c, ROTH_Total__c, TSP_Balance_No_Match__c, Scenario1_Primary__c, Scenario1_Retirement_Age__c, Scenario2_Primary__c, Scenario2_Retirement_Age__c, ShowTotal__c, ROTH_Contributions__c, Opt_Out__c, High_3_Salary__c, Total_Health__c, Additional_Insurance__c, FERS_Special_Supplement__c, Military_Retirement__c, Disability_in_Retirement__c, Scenario1_YOS__c, High_3_Salary2__c, Scenario2_YOS__c, Min__c, Max__c, How_Did_You_Hear__c, Union_Association__c, Local__c, Chapter__c, Branch__c, Branch_No__c, President__c, President_Phone__c, President_Email__c, Union_Website__c, Appointment_Results__c, Reset_Date__c, Reset_Time__c, Office__c, Specialist__c, Call_Back_Date__c, Call_Back_Time__c, OBEF_Notes__c, Age_Option_B_Manual__c, formula_basePay__c, Multiples_B_Manual__c, AgeFactorformula_OptionB__c, Age_Option_Basic_Manual__c, Affiliation__c, AgeFactorFormula_OptionA__c, AgeFactorformula_Basic__c, BasicBiWeekly__c, OptionABiWeekly__c, Option_B_Choice_Selection__c, Option_C_Choice_Selection__c, Starting_Age__c, Starting_Age_Set__c, Years_34__c, Years_35_39__c, Years_40_44__c, Years_45_49__c, Years_50_54__c, Years_55_59__c, Years_60_64__c, Years_65_69__c, Years_70_74__c, Years_75_79__c, Years_80__c, Standard_Monthly__c, Standard_Amount__c, Id, IsDeleted, MasterRecordId, Callback_Time__c, Salutation, Suffix, RecordTypeId, Country, Latitude, Longitude, GeocodeAccuracy, Address, Phone, MobilePhone, Fax, Website, PhotoUrl, LeadSource, Status, Industry, Rating, AnnualRevenue, NumberOfEmployees, OwnerId, HasOptedOutOfEmail, GenderIdentity, IsPriorityRecord, Carrier__c, Policy_Issue_Date__c, Policy__c, X401K_TaxFree__c, X401K_Tax__c, totalExpenses_Spouse__c, totalExpenses__c, totalTaxes_Currency__c, formula_totalExpenses_Spouse__c, formula_totalExpenses__c, hiddenTaxFormula1__c, hiddenTaxFormula2__c, hiddenTaxFormula3__c, hiddenTaxFormula4__c, hiddenTaxFormula_IRAFree__c, hiddenTaxFormula_IRA_Tax__c, hiddenTaxFormula_IRA__c, Age__c, Years_of_Service__c, LeadId__c, CSRS_Offset__c, CSRS__c, FEGLI_Plan__c, Federal_Indicator__c, Birth_Month__c, Birth_Month_Formula__c, Date_Turning_59_formula__c, Annuity_Task_Generated__c, Owner_Full_Name__c, Today__c, Date_Turning_59__c, Rollover_Task_Generated__c, Primary_Scenario__c, Spouse_Option__c, Date_Turning_65_formula__c, AgeFactorformula_OptionB_Text__c, AgeFactorformula_OptionC_Text__c, CSRS_Annuity_Retirement__c, Catchup_Contribution__c, Monthly_Contribution__c, Monthly_ROTH_Contribution__c, Notes__c, ROTH_TSP_Contribution__c, Regular_Contribution__c, Remaining_Years__c, YOS_Special_Supplement__c, dollarROTH__c, dollarTSP__c, percROTH__c, percTSP__c, total_Years__c, OptedOut_Annuity__c, OptionB_Insurance_Cover__c, formula_SurvivingSpouse__c, formula_annuityNotMarried__c, formula_monthlyAnnuity__c, hiddenExtraBenefitformula__c, hiddenTotalBenefitformula__c, hiddentaxFormula_TSP_Tax__c, hiddentaxFormula_TSP__c, hiddentaxformula_ROTHTSP__c
            FROM Lead
            WHERE Id = :lead.Id
            LIMIT 1
        ];

        Decimal supplement = 0;
        if(newLead.Base_Salary__c == null || newLead.Base_Salary__c <= 0 ){
            newLead.Base_Salary__c = 0;
        }
        if(newLead.Predicted_Social_Security__c == null || newLead.Predicted_Social_Security__c <= 0 ){
            newLead.Predicted_Social_Security__c = 0;
        }
        if(newLead.Spouse_Social_Security__c == null || newLead.Spouse_Social_Security__c <= 0 ){
            newLead.Spouse_Social_Security__c = 0;
        }
        if(newLead.Predicted_Pension__c == null || newLead.Predicted_Pension__c <= 0 ){
            newLead.Predicted_Pension__c = 0;
        }
        if(newLead.Spouse_Pension__c == null || newLead.Spouse_Pension__c <= 0 ){
            newLead.Spouse_Pension__c = 0;
        }
        if(newLead.Pg7Rw3__c == null || newLead.Pg7Rw3__c <= 0 ){
            newLead.Pg7Rw3__c = 0;
        }
        if(newLead.Pg7Rw3_Spouse__c == null || newLead.Pg7Rw3_Spouse__c <= 0 ){
            newLead.Pg7Rw3_Spouse__c = 0;
        }
        if(newLead.Pg7Rw4__c == null || newLead.Pg7Rw4__c <= 0 ){
            newLead.Pg7Rw4__c = 0;
        }
        if(newLead.Pg7Rw4_Spouse__c == null || newLead.Pg7Rw4_Spouse__c <= 0 ){
            newLead.Pg7Rw4_Spouse__c = 0;
        }
        if(newLead.Pg7Rw5__c == null || newLead.Pg7Rw5__c <= 0 ){
            newLead.Pg7Rw5__c = 0;
        }
        if(newLead.Pg7Rw5_Spouse__c == null || newLead.Pg7Rw5_Spouse__c <= 0 ){
            newLead.Pg7Rw5_Spouse__c = 0;
        }
        if(newLead.Pg7Rw6__c == null || newLead.Pg7Rw6__c <= 0 ){
            newLead.Pg7Rw6__c = 0;
        }
        if(newLead.Pg7Rw6_Spouse__c == null || newLead.Pg7Rw6_Spouse__c <= 0 ){
            newLead.Pg7Rw6_Spouse__c = 0;
        }
        if(newLead.Pg7Rw7__c == null || newLead.Pg7Rw7__c <= 0 ){
            newLead.Pg7Rw7__c = 0;
        }
        if(newLead.Pg7Rw7_Spouse__c == null || newLead.Pg7Rw7_Spouse__c <= 0 ){
            newLead.Pg7Rw7_Spouse__c = 0;
        }
        if(newLead.Pg7Rw8__c == null || newLead.Pg7Rw8__c <= 0 ){
            newLead.Pg7Rw8__c = 0;
        }
        if(newLead.Pg7Rw8_Spouse__c == null || newLead.Pg7Rw8_Spouse__c <= 0 ){
            newLead.Pg7Rw8_Spouse__c = 0;
        }
        if(newLead.Pg7Rw9__c == null || newLead.Pg7Rw9__c <= 0 ){
            newLead.Pg7Rw9__c = 0;
        }
        if(newLead.Pg7Rw9_Spouse__c == null || newLead.Pg7Rw9_Spouse__c <= 0 ){
            newLead.Pg7Rw9_Spouse__c = 0;
        }
        if(newLead.Pg7Rw10__c == null || newLead.Pg7Rw10__c <= 0 ){
            newLead.Pg7Rw10__c = 0;
        }
        if(newLead.Pg7Rw10_Spouse__c == null || newLead.Pg7Rw10_Spouse__c <= 0 ){
            newLead.Pg7Rw10_Spouse__c = 0;
        }
        if(newLead.Pg8Rw1__c == null || newLead.Pg8Rw1__c <= 0 ){
            newLead.Pg8Rw1__c = 0;
        }
        if(newLead.Pg8Rw1_Spouse__c == null || newLead.Pg8Rw1_Spouse__c <= 0 ){
            newLead.Pg8Rw1_Spouse__c = 0;
        }
        if(newLead.Pg8Rw2__c == null || newLead.Pg8Rw2__c <= 0 ){
            newLead.Pg8Rw2__c = 0;
        }
        if(newLead.Pg8Rw2_Spouse__c == null || newLead.Pg8Rw2_Spouse__c <= 0 ){
            newLead.Pg8Rw2_Spouse__c = 0;
        }
        if(newLead.Pg8Rw3__c == null || newLead.Pg8Rw3__c <= 0 ){
            newLead.Pg8Rw3__c = 0;
        }
        if(newLead.Pg8Rw3_Spouse__c == null || newLead.Pg8Rw3_Spouse__c <= 0 ){
            newLead.Pg8Rw3_Spouse__c = 0;
        }
        if(newLead.Pg8Rw4__c == null || newLead.Pg8Rw4__c <= 0 ){
            newLead.Pg8Rw4__c = 0;
        }
        if(newLead.Pg8Rw4_Spouse__c == null || newLead.Pg8Rw4_Spouse__c <= 0 ){
            newLead.Pg8Rw4_Spouse__c = 0;
        }
        if(newLead.Pg8Rw5__c == null || newLead.Pg8Rw5__c <= 0 ){
            newLead.Pg8Rw5__c = 0;
        }
        if(newLead.Pg8Rw5_Spouse__c == null || newLead.Pg8Rw5_Spouse__c <= 0 ){
            newLead.Pg8Rw5_Spouse__c = 0;
        }
        if(newLead.Pg8Rw6__c == null || newLead.Pg8Rw6__c <= 0 ){
            newLead.Pg8Rw6__c = 0;
        }
        if(newLead.Pg8Rw6_Spouse__c == null || newLead.Pg8Rw6_Spouse__c <= 0 ){
            newLead.Pg8Rw6_Spouse__c = 0;
        }
        if(newLead.Pg8Rw7__c == null || newLead.Pg8Rw7__c <= 0 ){
            newLead.Pg8Rw7__c = 0;
        }
        if(newLead.Pg8Rw7_Spouse__c == null || newLead.Pg8Rw7_Spouse__c <= 0 ){
            newLead.Pg8Rw7_Spouse__c = 0;
        }
        if(newLead.Pg8Rw8__c == null || newLead.Pg8Rw8__c <= 0 ){
            newLead.Pg8Rw8__c = 0;
        }
        if(newLead.Pg8Rw8_Spouse__c == null || newLead.Pg8Rw8_Spouse__c <= 0 ){
            newLead.Pg8Rw8_Spouse__c = 0;
        }
        if(newLead.Pg8Rw9__c == null || newLead.Pg8Rw9__c <= 0 ){
            newLead.Pg8Rw9__c = 0;
        }
        if(newLead.Pg8Rw9_Spouse__c == null || newLead.Pg8Rw9_Spouse__c <= 0 ){
            newLead.Pg8Rw9_Spouse__c = 0;
        }
        if(newLead.Pg8Rw10__c == null || newLead.Pg8Rw10__c <= 0 ){
            newLead.Pg8Rw10__c = 0;
        }
        if(newLead.Pg8Rw10_Spouse__c == null || newLead.Pg8Rw10_Spouse__c <= 0 ){
            newLead.Pg8Rw10_Spouse__c = 0;
        }
        if(newLead.Pg8Rw11__c == null || newLead.Pg8Rw11__c <= 0 ){
            newLead.Pg8Rw11__c = 0;
        }
        if(newLead.Pg8Rw11_Spouse__c == null || newLead.Pg8Rw11_Spouse__c <= 0 ){
            newLead.Pg8Rw11_Spouse__c = 0;
        }
        if(newLead.Pg9Rw01__c == null || newLead.Pg9Rw01__c <= 0 ){
            newLead.Pg9Rw01__c = 0;
        }
        if(newLead.Pg9Rw02__c == null || newLead.Pg9Rw02__c <= 0 ){
            newLead.Pg9Rw02__c = 0;
        }
        if(newLead.Pg9Rw03__c == null || newLead.Pg9Rw03__c <= 0 ){
            newLead.Pg9Rw03__c = 0;
        }
        if(newLead.Pg9Rw04__c == null || newLead.Pg9Rw04__c <= 0 ){
            newLead.Pg9Rw04__c = 0;
        }
        if(newLead.Pg9Rw05__c == null || newLead.Pg9Rw05__c <= 0 ){
            newLead.Pg9Rw05__c = 0;
        }
        if(newLead.Pg9Rw06__c == null || newLead.Pg9Rw06__c <= 0 ){
            newLead.Pg9Rw06__c = 0;
        }
        if(newLead.Pg9Rw01_Spouse__c == null || newLead.Pg9Rw01_Spouse__c <= 0 ){
            newLead.Pg9Rw01_Spouse__c = 0;
        }
        if(newLead.Pg9Rw02_Spouse__c == null || newLead.Pg9Rw02_Spouse__c <= 0 ){
            newLead.Pg9Rw02_Spouse__c = 0;
        }
        if(newLead.Pg9Rw03_Spouse__c == null || newLead.Pg9Rw03_Spouse__c <= 0 ){
            newLead.Pg9Rw03_Spouse__c = 0;
        }
        if(newLead.Pg9Rw04_Spouse__c == null || newLead.Pg9Rw04_Spouse__c <= 0 ){
            newLead.Pg9Rw04_Spouse__c = 0;
        }
        if(newLead.Pg9Rw05_Spouse__c == null || newLead.Pg9Rw05_Spouse__c <= 0 ){
            newLead.Pg9Rw05_Spouse__c = 0;
        }
        if(newLead.Pg9Rw06_Spouse__c == null || newLead.Pg9Rw06_Spouse__c <= 0 ){
            newLead.Pg9Rw06_Spouse__c = 0;
        }
        if(newLead.Pg9Rw07__c == null || newLead.Pg9Rw07__c <= 0 ){
            newLead.Pg9Rw07__c = 0;
        }
        if(newLead.Pg9Rw08__c == null || newLead.Pg9Rw08__c <= 0 ){
            newLead.Pg9Rw08__c = 0;
        }
        if(newLead.Pg9Rw09__c == null || newLead.Pg9Rw09__c <= 0 ){
            newLead.Pg9Rw09__c = 0;
        }
        if(newLead.Pg9Rw10__c == null || newLead.Pg9Rw10__c <= 0 ){
            newLead.Pg9Rw10__c = 0;
        }
        if(newLead.Pg9Rw11__c == null || newLead.Pg9Rw11__c <= 0 ){
            newLead.Pg9Rw11__c = 0;
        }
        if(newLead.Pg9Rw07_Spouse__c == null || newLead.Pg9Rw07_Spouse__c <= 0 ){
            newLead.Pg9Rw07_Spouse__c = 0;
        }
        if(newLead.Pg9Rw08_Spouse__c == null || newLead.Pg9Rw08_Spouse__c <= 0 ){
            newLead.Pg9Rw08_Spouse__c = 0;
        }
        if(newLead.Pg9Rw09_Spouse__c == null || newLead.Pg9Rw09_Spouse__c <= 0 ){
            newLead.Pg9Rw09_Spouse__c = 0;
        }
        if(newLead.Pg9Rw10_Spouse__c == null || newLead.Pg9Rw10_Spouse__c <= 0 ){
            newLead.Pg9Rw10_Spouse__c = 0;
        }
        if(newLead.Pg9Rw11_Spouse__c == null || newLead.Pg9Rw11_Spouse__c <= 0 ){
            newLead.Pg9Rw11_Spouse__c = 0;
        }
        if(newLead.Pg9Rw12__c == null || newLead.Pg9Rw12__c <= 0 ){
            newLead.Pg9Rw12__c = 0;
        }
        if(newLead.Pg9Rw13__c == null || newLead.Pg9Rw13__c <= 0 ){
            newLead.Pg9Rw13__c = 0;
        }
        if(newLead.Pg9Rw14__c == null || newLead.Pg9Rw14__c <= 0 ){
            newLead.Pg9Rw14__c = 0;
        }
        if(newLead.Pg9Rw15__c == null || newLead.Pg9Rw15__c <= 0 ){
            newLead.Pg9Rw15__c = 0;
        }
        if(newLead.Pg9Rw16__c == null || newLead.Pg9Rw16__c <= 0 ){
            newLead.Pg9Rw16__c = 0;
        }
        if(newLead.Pg9Rw17__c == null || newLead.Pg9Rw17__c <= 0 ){
            newLead.Pg9Rw17__c = 0;
        }
        if(newLead.Pg9Rw12_Spouse__c == null || newLead.Pg9Rw12_Spouse__c <= 0 ){
            newLead.Pg9Rw12_Spouse__c = 0;
        }
        if(newLead.Pg9Rw13_Spouse__c == null || newLead.Pg9Rw13_Spouse__c <= 0 ){
            newLead.Pg9Rw13_Spouse__c = 0;
        }
        if(newLead.Pg9Rw14_Spouse__c == null || newLead.Pg9Rw14_Spouse__c <= 0 ){
            newLead.Pg9Rw14_Spouse__c = 0;
        }
        if(newLead.Pg9Rw15_Spouse__c == null || newLead.Pg9Rw15_Spouse__c <= 0 ){
            newLead.Pg9Rw15_Spouse__c = 0;
        }
        if(newLead.Pg9Rw16_Spouse__c == null || newLead.Pg9Rw16_Spouse__c <= 0 ){
            newLead.Pg9Rw16_Spouse__c = 0;
        }
        if(newLead.Pg9Rw17_Spouse__c == null || newLead.Pg9Rw17_Spouse__c <= 0 ){
            newLead.Pg9Rw17_Spouse__c = 0;
        }
        if(newLead.Pg9Rw18__c == null || newLead.Pg9Rw18__c <= 0 ){
            newLead.Pg9Rw18__c = 0;
        }
        if(newLead.Pg9Rw19__c == null || newLead.Pg9Rw19__c <= 0 ){
            newLead.Pg9Rw19__c = 0;
        }
        if(newLead.Pg9Rw20__c == null || newLead.Pg9Rw20__c <= 0 ){
            newLead.Pg9Rw20__c = 0;
        }
        if(newLead.Pg9Rw21__c == null || newLead.Pg9Rw21__c <= 0 ){
            newLead.Pg9Rw21__c = 0;
        }
        if(newLead.Pg9Rw18_Spouse__c == null || newLead.Pg9Rw18_Spouse__c <= 0 ){
            newLead.Pg9Rw18_Spouse__c = 0;
        }
        if(newLead.Pg9Rw19_Spouse__c == null || newLead.Pg9Rw19_Spouse__c <= 0 ){
            newLead.Pg9Rw19_Spouse__c = 0;
        }
        if(newLead.Pg9Rw20_Spouse__c == null || newLead.Pg9Rw20_Spouse__c <= 0 ){
            newLead.Pg9Rw20_Spouse__c = 0;
        }
        if(newLead.Pg9Rw21_Spouse__c == null || newLead.Pg9Rw21_Spouse__c <= 0 ){
            newLead.Pg9Rw21_Spouse__c = 0;
        }
        if(newLead.Pg10Rw01__c == null || newLead.Pg10Rw01__c <= 0 ){
            newLead.Pg10Rw01__c = 0;
        }
        if(newLead.Pg10Rw02__c == null || newLead.Pg10Rw02__c <= 0 ){
            newLead.Pg10Rw02__c = 0;
        }
        if(newLead.Pg10Rw03__c == null || newLead.Pg10Rw03__c <= 0 ){
            newLead.Pg10Rw03__c = 0;
        }
        if(newLead.Pg10Rw04__c == null || newLead.Pg10Rw04__c <= 0 ){
            newLead.Pg10Rw04__c = 0;
        }
        if(newLead.Pg10Rw01_Spouse__c == null || newLead.Pg10Rw01_Spouse__c <= 0 ){
            newLead.Pg10Rw01_Spouse__c = 0;
        }
        if(newLead.Pg10Rw02_Spouse__c == null || newLead.Pg10Rw02_Spouse__c <= 0 ){
            newLead.Pg10Rw02_Spouse__c = 0;
        }
        if(newLead.Pg10Rw03_Spouse__c == null || newLead.Pg10Rw03_Spouse__c <= 0 ){
            newLead.Pg10Rw03_Spouse__c = 0;
        }
        if(newLead.Pg10Rw04_Spouse__c == null || newLead.Pg10Rw04_Spouse__c <= 0 ){
            newLead.Pg10Rw04_Spouse__c = 0;
        }
        if(newLead.Pg10Rw05__c == null || newLead.Pg10Rw05__c <= 0 ){
            newLead.Pg10Rw05__c = 0;
        }
        if(newLead.Pg10Rw06__c == null || newLead.Pg10Rw06__c <= 0 ){
            newLead.Pg10Rw06__c = 0;
        }
        if(newLead.Pg10Rw07__c == null || newLead.Pg10Rw07__c <= 0 ){
            newLead.Pg10Rw07__c = 0;
        }
        if(newLead.Pg10Rw08__c == null || newLead.Pg10Rw08__c <= 0 ){
            newLead.Pg10Rw08__c = 0;
        }
        if(newLead.Pg10Rw05_Spouse__c == null || newLead.Pg10Rw05_Spouse__c <= 0 ){
            newLead.Pg10Rw05_Spouse__c = 0;
        }
        if(newLead.Pg10Rw06_Spouse__c == null || newLead.Pg10Rw06_Spouse__c <= 0 ){
            newLead.Pg10Rw06_Spouse__c = 0;
        }
        if(newLead.Pg10Rw07_Spouse__c == null || newLead.Pg10Rw07_Spouse__c <= 0 ){
            newLead.Pg10Rw07_Spouse__c = 0;
        }
        if(newLead.Pg10Rw08_Spouse__c == null || newLead.Pg10Rw08_Spouse__c <= 0 ){
            newLead.Pg10Rw08_Spouse__c = 0;
        }
        if(newLead.Pg10Rw09__c == null || newLead.Pg10Rw09__c <= 0 ){
            newLead.Pg10Rw09__c = 0;
        }
        if(newLead.Pg10Rw10__c == null || newLead.Pg10Rw10__c <= 0 ){
            newLead.Pg10Rw10__c = 0;
        }
        if(newLead.Pg10Rw11__c == null || newLead.Pg10Rw11__c <= 0 ){
            newLead.Pg10Rw11__c = 0;
        }
        if(newLead.Pg10Rw12__c == null || newLead.Pg10Rw12__c <= 0 ){
            newLead.Pg10Rw12__c = 0;
        }
        if(newLead.Pg10Rw13__c == null || newLead.Pg10Rw13__c <= 0 ){
            newLead.Pg10Rw13__c = 0;
        }
        if(newLead.Pg10Rw14__c == null || newLead.Pg10Rw14__c <= 0 ){
            newLead.Pg10Rw14__c = 0;
        }
        if(newLead.Pg10Rw09_Spouse__c == null || newLead.Pg10Rw09_Spouse__c <= 0 ){
            newLead.Pg10Rw09_Spouse__c = 0;
        }
        if(newLead.Pg10Rw10_Spouse__c == null || newLead.Pg10Rw10_Spouse__c <= 0 ){
            newLead.Pg10Rw10_Spouse__c = 0;
        }
        if(newLead.Pg10Rw11_Spouse__c == null || newLead.Pg10Rw11_Spouse__c <= 0 ){
            newLead.Pg10Rw11_Spouse__c = 0;
        }
        if(newLead.Pg10Rw12_Spouse__c == null || newLead.Pg10Rw12_Spouse__c <= 0 ){
            newLead.Pg10Rw12_Spouse__c = 0;
        }
        if(newLead.Pg10Rw13_Spouse__c == null || newLead.Pg10Rw13_Spouse__c <= 0 ){
            newLead.Pg10Rw13_Spouse__c = 0;
        }
        if(newLead.Pg10Rw14_Spouse__c == null || newLead.Pg10Rw14_Spouse__c <= 0 ){
            newLead.Pg10Rw14_Spouse__c = 0;
        }
        if(newLead.Pg10Rw15__c == null || newLead.Pg10Rw15__c <= 0 ){
            newLead.Pg10Rw15__c = 0;
        }
        if(newLead.Pg10Rw16__c == null || newLead.Pg10Rw16__c <= 0 ){
            newLead.Pg10Rw16__c = 0;
        }
        if(newLead.Pg10Rw17__c == null || newLead.Pg10Rw17__c <= 0 ){
            newLead.Pg10Rw17__c = 0;
        }
        if(newLead.Pg10Rw18__c == null || newLead.Pg10Rw18__c <= 0 ){
            newLead.Pg10Rw18__c = 0;
        }
        if(newLead.Pg10Rw15_Spouse__c == null || newLead.Pg10Rw15_Spouse__c <= 0 ){
            newLead.Pg10Rw15_Spouse__c = 0;
        }
        if(newLead.Pg10Rw16_Spouse__c == null || newLead.Pg10Rw16_Spouse__c <= 0 ){
            newLead.Pg10Rw16_Spouse__c = 0;
        }
        if(newLead.Pg10Rw17_Spouse__c == null || newLead.Pg10Rw17_Spouse__c <= 0 ){
            newLead.Pg10Rw17_Spouse__c = 0;
        }
        if(newLead.Pg10Rw18_Spouse__c == null || newLead.Pg10Rw18_Spouse__c <= 0 ){
            newLead.Pg10Rw18_Spouse__c = 0;
        }
        if(newLead.Pg10Rw19__c == null || newLead.Pg10Rw19__c <= 0 ){
            newLead.Pg10Rw19__c = 0;
        }
        if(newLead.Pg10Rw19_Spouse__c == null || newLead.Pg10Rw19_Spouse__c <= 0 ){
            newLead.Pg10Rw19_Spouse__c = 0;
        }
        if(newLead.Pg10Rw20__c == null || newLead.Pg10Rw20__c <= 0 ){
            newLead.Pg10Rw20__c = 0;
        }
        if(newLead.Pg10Rw20_Spouse__c == null || newLead.Pg10Rw20_Spouse__c <= 0 ){
            newLead.Pg10Rw20_Spouse__c = 0;
        }
        if(newLead.Pg10Rw21__c == null || newLead.Pg10Rw21__c <= 0 ){
            newLead.Pg10Rw21__c = 0;
        }
        if(newLead.Pg10Rw21_Spouse__c == null || newLead.Pg10Rw21_Spouse__c <= 0 ){
            newLead.Pg10Rw21_Spouse__c = 0;
        }
        if(newLead.Pg10Rw22__c == null || newLead.Pg10Rw22__c <= 0 ){
            newLead.Pg10Rw22__c = 0;
        }
        if(newLead.Pg10Rw22_Spouse__c == null || newLead.Pg10Rw22_Spouse__c <= 0 ){
            newLead.Pg10Rw22_Spouse__c = 0;
        }
        if(newLead.Pg10Rw23__c == null || newLead.Pg10Rw23__c <= 0 ){
            newLead.Pg10Rw23__c = 0;
        }
        if(newLead.Pg10Rw23_Spouse__c == null || newLead.Pg10Rw23_Spouse__c <= 0 ){
            newLead.Pg10Rw23_Spouse__c = 0;
        }
        if(newLead.Additional_Income1__c == null || newLead.Additional_Income1__c <= 0 ){
            newLead.Additional_Income1__c = 0;
        }
        if(newLead.Additional_Income2__c == null || newLead.Additional_Income2__c <= 0 ){
            newLead.Additional_Income2__c = 0;
        }
        if(newLead.Additional_Income3__c == null || newLead.Additional_Income3__c <= 0 ){
            newLead.Additional_Income3__c = 0;
        }
        if(newLead.currentNET__c == null || newLead.currentNET__c <= 0 ){
            newLead.currentNET__c = 0;
        }
        if(newLead.TSP_Contribution__c == null || newLead.TSP_Contribution__c <= 0 ){
            newLead.TSP_Contribution__c = 0;
        }
        if(newLead.TSP_Balance__c == null || newLead.TSP_Balance__c <= 0 ){
            newLead.TSP_Balance__c = 0;
        }
        if(newLead.TSP_Total__c == null || newLead.TSP_Total__c <= 0 ){
            newLead.TSP_Total__c = 0;
        }
        if(newLead.ROTH_Total__c == null || newLead.ROTH_Total__c <= 0 ){
            newLead.ROTH_Total__c = 0;
        }
        if(newLead.TSP_Balance_No_Match__c == null || newLead.TSP_Balance_No_Match__c <= 0 ){
            newLead.TSP_Balance_No_Match__c = 0;
        }
        if(newLead.Scenario1_Retirement_Age__c == null || newLead.Scenario1_Retirement_Age__c <= 0 ){
            newLead.Scenario1_Retirement_Age__c = 0;
        }
        if(newLead.Scenario2_Retirement_Age__c == null || newLead.Scenario2_Retirement_Age__c <= 0 ){
            newLead.Scenario2_Retirement_Age__c = 0;
        }
        if(newLead.ROTH_Contributions__c == null || newLead.ROTH_Contributions__c <= 0 ){
            newLead.ROTH_Contributions__c = 0;
        }
        if(newLead.High_3_Salary__c == null || newLead.High_3_Salary__c <= 0 ){
            newLead.High_3_Salary__c = 0;
        }
        if(newLead.Total_Health__c == null || newLead.Total_Health__c <= 0 ){
            newLead.Total_Health__c = 0;
        }
        if(newLead.Additional_Insurance__c == null || newLead.Additional_Insurance__c <= 0 ){
            newLead.Additional_Insurance__c = 0;
        }
        
        if(newLead.Military_Retirement__c == null || newLead.Military_Retirement__c <= 0 ){
            newLead.Military_Retirement__c = 0;
        }
        if(newLead.Disability_in_Retirement__c == null || newLead.Disability_in_Retirement__c <= 0 ){
            newLead.Disability_in_Retirement__c = 0;
        }
        if(newLead.Scenario1_YOS__c == null || newLead.Scenario1_YOS__c <= 0 ){
            newLead.Scenario1_YOS__c = 0;
        }
        if(newLead.High_3_Salary2__c == null || newLead.High_3_Salary2__c <= 0 ){
            newLead.High_3_Salary2__c = 0;
        }
        if(newLead.Scenario2_YOS__c == null || newLead.Scenario2_YOS__c <= 0 ){
            newLead.Scenario2_YOS__c = 0;
        }
        
        if(newLead.Starting_Age__c == null || newLead.Starting_Age__c <= 0 ){
            newLead.Starting_Age__c = 0;
        }
        if(newLead.Standard_Monthly__c == null || newLead.Standard_Monthly__c <= 0 ){
            newLead.Standard_Monthly__c = 0;
        }
        if(newLead.Standard_Amount__c == null || newLead.Standard_Amount__c <= 0 ){
            newLead.Standard_Amount__c = 0;
        }
        if(newLead.AnnualRevenue == null || newLead.AnnualRevenue <= 0 ){
            newLead.AnnualRevenue = 0;
        }
        if(newLead.NumberOfEmployees == null || newLead.NumberOfEmployees <= 0 ){
            newLead.NumberOfEmployees = 0;
        }
        if(newLead.X401K_TaxFree__c == null || newLead.X401K_TaxFree__c <= 0 ){
            newLead.X401K_TaxFree__c = 0;
        }
        if(newLead.X401K_Tax__c == null || newLead.X401K_Tax__c <= 0 ){
            newLead.X401K_Tax__c = 0;
        }
        if(newLead.totalExpenses_Spouse__c == null || newLead.totalExpenses_Spouse__c <= 0 ){
            newLead.totalExpenses_Spouse__c = 0;
        }
        if(newLead.totalExpenses__c == null || newLead.totalExpenses__c <= 0 ){
            newLead.totalExpenses__c = 0;
        }
        if(newLead.totalTaxes_Currency__c == null || newLead.totalTaxes_Currency__c <= 0 ){
            newLead.totalTaxes_Currency__c = 0;
        }
        
        if(newLead.Age__c == null || newLead.Age__c <= 0 ){
            newLead.Age__c = 0;
        }
        if(newLead.Years_of_Service__c == null || newLead.Years_of_Service__c <= 0 ){
            newLead.Years_of_Service__c = 0;
        }
        if(newLead.AgeFactorformula_OptionB_Text__c == null || newLead.AgeFactorformula_OptionB_Text__c <= 0 ){
            newLead.AgeFactorformula_OptionB_Text__c = 0;
        }
        if(newLead.AgeFactorformula_OptionC_Text__c == null || newLead.AgeFactorformula_OptionC_Text__c <= 0 ){
            newLead.AgeFactorformula_OptionC_Text__c = 0;
        }
        if(newLead.CSRS_Annuity_Retirement__c == null || newLead.CSRS_Annuity_Retirement__c <= 0 ){
            newLead.CSRS_Annuity_Retirement__c = 0;
        }
        if(newLead.Catchup_Contribution__c == null || newLead.Catchup_Contribution__c <= 0 ){
            newLead.Catchup_Contribution__c = 0;
        }
        if(newLead.Monthly_Contribution__c == null || newLead.Monthly_Contribution__c <= 0 ){
            newLead.Monthly_Contribution__c = 0;
        }
        if(newLead.Monthly_ROTH_Contribution__c == null || newLead.Monthly_ROTH_Contribution__c <= 0 ){
            newLead.Monthly_ROTH_Contribution__c = 0;
        }
        if(newLead.ROTH_TSP_Contribution__c == null || newLead.ROTH_TSP_Contribution__c <= 0 ){
            newLead.ROTH_TSP_Contribution__c = 0;
        }
        if(newLead.Regular_Contribution__c == null || newLead.Regular_Contribution__c <= 0 ){
            newLead.Regular_Contribution__c = 0;
        }
        if(newLead.Remaining_Years__c == null || newLead.Remaining_Years__c <= 0 ){
            newLead.Remaining_Years__c = 0;
        }
        if(newLead.YOS_Special_Supplement__c == null || newLead.YOS_Special_Supplement__c <= 0 ){
            newLead.YOS_Special_Supplement__c = 0;
        }
        if(newLead.total_Years__c == null || newLead.total_Years__c <= 0 ){
            newLead.total_Years__c = 0;
        }
        // Eligibility check
        if(Lead.High_3_Salary__c == null || Lead.High_3_Salary__c < 0){
            Lead.High_3_Salary__c = 0;
        }
         if(Lead.Remaining_Years__c == null || Lead.Remaining_Years__c < 0){
            Lead.Remaining_Years__c = 0;
        }
        if (
            (newLead.Scenario1_Primary__c == true && newLead.Scenario1_Retirement_Age__c <= 62) ||
            (newLead.Scenario2_Primary__c == true && newLead.Scenario2_Retirement_Age__c <= 62) ||
            (newLead.Scenario1_Primary__c == false && newLead.Scenario2_Primary__c == false && newLead.Expected_Retirement_Age__c <= 62)
        ) {
            fERSSpecialSupplementValue = (Decimal)Math.floor(
                newLead.Predicted_Social_Security__c * (newLead.YOS_Special_Supplement__c / 40)
            );
        } else {
            fERSSpecialSupplementValue = 0;
        }
        if (
            (newLead.Scenario1_Primary__c == true && newLead.Scenario1_Retirement_Age__c < 62) ||
            (newLead.Scenario2_Primary__c == true && newLead.Scenario2_Retirement_Age__c < 62) ||
            (newLead.Scenario1_Primary__c == false && newLead.Scenario2_Primary__c == false && newLead.Expected_Retirement_Age__c < 62)
        ) {
            SocialSecurityValue = 0;
        }
        else{
            SocialSecurityValue = newLead.Predicted_Social_Security__c;
        }

        // Update controller variable for page display
        // fERSSpecialSupplementValue = supplement;


        if((lead.Scenario1_Primary__c == true && lead.Scenario1_Retirement_Age__c < 62) ||(lead.Scenario2_Primary__c == true && lead.Scenario2_Retirement_Age__c < 62) ){
            SpecialAndSupplementVal = fERSSpecialSupplementValue;
        }
        else{
            SpecialAndSupplementVal = SocialSecurityValue;
        }
  
        pensionMinValue = (((((newLead.High_3_Salary__c * 0.017) * 20) + ((newLead.High_3_Salary__c * 0.01) * newLead.Remaining_Years__c)) / 12)) - (((((newLead.High_3_Salary__c * 0.017) * 20) + ((newLead.High_3_Salary__c * 0.01) * newLead.Remaining_Years__c)) / 12) * 0.05);

        pensionMaxValue = (((((newLead.High_3_Salary__c * 0.017) * 20) + ((newLead.High_3_Salary__c * 0.01) * newLead.Remaining_Years__c)) / 12)) - (((((newLead.High_3_Salary__c * 0.017) * 20) + ((newLead.High_3_Salary__c * 0.01) * newLead.Remaining_Years__c)) / 12) * 0.10);


        //  if (newLead.Scenario1_Retirement_Age__c != null && newLead.Scenario1_Retirement_Age__c != 0 && newLead.Date_of_Birth__c != null && newLead.Date_of_Hire__c != null) {
        //     Integer yearsOfService = (Integer) Math.floor((newLead.Date_of_Birth__c.daysBetween(newLead.Date_of_Hire__c)) / 365.25);
        //     scenario1XYOS = newLead.Scenario1_Retirement_Age__c - Math.abs(yearsOfService);
        // }

        // if (newLead.Scenario2_Retirement_Age__c != null && newLead.Scenario2_Retirement_Age__c != 0 && newLead.Date_of_Birth__c != null && newLead.Date_of_Hire__c != null) {
        //     Integer yearsOfService = (Integer) Math.floor((newLead.Date_of_Birth__c.daysBetween(newLead.Date_of_Hire__c)) / 365.25);
        //     scenario2XYOS = newLead.Scenario2_Retirement_Age__c - Math.abs(yearsOfService);
        // }

        System.debug('After set function scenario2XYOS the Save'+ scenario2XYOS);
        System.debug('After set function scenario1XYOS the Save'+ scenario1XYOS);

        Decimal AnnualWithdraw1 = 0;
        if(String.isNotBlank(newLead.AnnualWithdraw1__c)){
            String withdrawStr = newLead.AnnualWithdraw1__c.replace('%','').trim();
            AnnualWithdraw1 = Decimal.valueOf(withdrawStr) / 100;
        }
        // TspCalculateValue=AnnualWithdraw1;

        Decimal AnnualWithdraw2 = 0;
        if(String.isNotBlank(newLead.AnnualWithdraw2__c)){
            String withdrawStr = newLead.AnnualWithdraw2__c.replace('%','').trim();
            AnnualWithdraw2 = Decimal.valueOf(withdrawStr) / 100;
        }
        // TspCalculateValue=AnnualWithdraw2;

        Decimal taxRate5_Picklist = 0;
        if(String.isNotBlank(newLead.taxRate5_Picklist__c)){
            String withdrawStr = newLead.taxRate5_Picklist__c.replace('%','').trim();
            taxRate5_Picklist = Decimal.valueOf(withdrawStr) / 100;
        }
        // TspCalculateValue=taxRate5_Picklist;

        if(newLead.TSP_Balance_No_Match__c != 0 &&  AnnualWithdraw1 != 0 && (newLead.ROTH_Contributions__c == 0 || newLead.ROTH_Contributions__c == NULL || AnnualWithdraw2 == 0)){
            TspCalculateValue =  ((newLead.TSP_Balance_No_Match__c * AnnualWithdraw1) / 12) - (taxRate5_Picklist * ((newLead.TSP_Balance_No_Match__c * AnnualWithdraw1) / 12));
        }


        if((newLead.ROTH_Contributions__c != 0 && AnnualWithdraw2 !=0 && (newLead.TSP_Balance_No_Match__c == 0 || newLead.TSP_Balance_No_Match__c == NULL || AnnualWithdraw1 == 0))){
            TspCalculateValue = (newLead.ROTH_Contributions__c * AnnualWithdraw2 / 12);
        }

        if( newLead.TSP_Balance_No_Match__c != 0 && AnnualWithdraw1 != 0 && newLead.ROTH_Contributions__c != 0 && AnnualWithdraw2 != 0 ) {
            TspCalculateValue = ( ((newLead.TSP_Balance_No_Match__c * AnnualWithdraw1) / 12) - (taxRate5_Picklist * ((newLead.TSP_Balance_No_Match__c * AnnualWithdraw1) / 12)) + ((newLead.ROTH_Contributions__c * AnnualWithdraw2) / 12));
        }

        if(((newLead.TSP_Balance_No_Match__c == 0 || newLead.TSP_Balance_No_Match__c == NULL) && (newLead.ROTH_Contributions__c == 0 || newLead.ROTH_Contributions__c == NULL) || (AnnualWithdraw1 == 0 && AnnualWithdraw2 == 0))){
            TspCalculateValue=0;
        }
        System.debug('scenario2XYOS And of the Save'+ scenario2XYOS);
        System.debug('scenario1XYOS And of the Save'+ scenario1XYOS);
        return null;
    }



    public PageReference Cancel() {
        PageReference Pdf = NEW PageReference('/' + lead.id);
        pdf.setredirect(TRUE);
        RETURN Pdf;
    }

    // Calculates and updates FERS Special Supplement
    
}