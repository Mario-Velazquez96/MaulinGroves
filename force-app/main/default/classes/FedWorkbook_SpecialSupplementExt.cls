public with sharing class FedWorkbook_SpecialSupplementExt {

    public Lead lead { get; set; }
    private Id leadId;

    public FedWorkbook_SpecialSupplementExt(ApexPages.StandardController stdController) {
        this.leadId = stdController.getId();
        this.lead = fetchLead();
    }

    private Lead fetchLead() {
        if (this.leadId == null) { return new Lead(); }
        return [
            SELECT Special_Group_Member__c,
                   FERS__c,
                   Expected_Retirement_Age__c,
                   Scenario1_Primary__c, Scenario1_Retirement_Age__c,
                   Scenario2_Primary__c, Scenario2_Retirement_Age__c,
                   YOS_Special_Supplement__c,
                   Predicted_Social_Security__c
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

    private Decimal yos()    { return lead.YOS_Special_Supplement__c == null ? 0 : lead.YOS_Special_Supplement__c; }
    private Decimal ssAt62() { return lead.Predicted_Social_Security__c == null ? 0 : lead.Predicted_Social_Security__c; }

    public Decimal getSupplementPct()     { return (yos() / 40) * 100; }
    public Decimal getSupplementDollars() { return ssAt62() * (yos() / 40); }

    // Four-branch render gate from legacy FERS_System.page line 2970.
    // Renders only when retirement age is under 62 via whichever scenario path applies.
    public Boolean getShowSpecialSupp() {
        Boolean isSpecial = lead.Special_Group_Member__c == true;
        Boolean isFers = lead.FERS__c == true;
        Decimal expected = lead.Expected_Retirement_Age__c == null ? 999 : lead.Expected_Retirement_Age__c;
        Decimal s1Age = lead.Scenario1_Retirement_Age__c == null ? 999 : lead.Scenario1_Retirement_Age__c;
        Decimal s2Age = lead.Scenario2_Retirement_Age__c == null ? 999 : lead.Scenario2_Retirement_Age__c;
        Boolean s1Primary = lead.Scenario1_Primary__c == true;
        Boolean s2Primary = lead.Scenario2_Primary__c == true;

        if (isSpecial) {
            return expected < 62;
        }
        if (isFers) {
            return (s1Primary && s1Age < 62) || (s2Primary && s2Age < 62);
        }
        return expected < 62;
    }
}
