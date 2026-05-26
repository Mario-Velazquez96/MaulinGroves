public with sharing class FedWorkbook_SpecialGroupsExt {

    public Lead lead { get; set; }
    private Id leadId;

    public FedWorkbook_SpecialGroupsExt(ApexPages.StandardController stdController) {
        this.leadId = stdController.getId();
        this.lead = fetchLead();
    }

    private Lead fetchLead() {
        if (this.leadId == null) { return new Lead(); }
        return [
            SELECT Special_Group_Member__c,
                   High_3_Salary__c,
                   Remaining_Years__c
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

    private Decimal high3()     { return lead.High_3_Salary__c == null ? 0 : lead.High_3_Salary__c; }
    private Decimal remaining() { return lead.Remaining_Years__c == null ? 0 : lead.Remaining_Years__c; }

    public Decimal getFactor17xHigh3()            { return high3() * 0.017; }
    public Decimal getBlock20YearAnnuity()         { return getFactor17xHigh3() * 20; }
    public Decimal getFactor01xHigh3()             { return high3() * 0.01; }
    public Decimal getFactor01xRemainingAnnuity()  { return getFactor01xHigh3() * remaining(); }
    public Decimal getTotalAnnual()                { return getBlock20YearAnnuity() + getFactor01xRemainingAnnuity(); }
    public Decimal getTotalMonthly()               { return getTotalAnnual() / 12; }
}
