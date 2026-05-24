/**
 * FedWorkbook_CsrsOffsetExt
 *
 * Extension for page 6 (FedWorkbook_CsrsOffset). Computes the CSRS
 * Offset retirement annuity formula:
 *
 *   Offset %             = Years_of_CSRS_Offset__c / 40
 *   Offset $             = Predicted_Social_Security__c x Offset %
 *   Adjusted CSRS        = CSRS_Annuity_Retirement__c - Offset $
 *   Total Annual Annuity = Adjusted CSRS + Predicted_Social_Security__c
 *   Monthly Annuity      = Total Annual Annuity / 12
 *
 * Self-contained SOQL (matches the pattern used by the other page
 * extensions in the rebrand).
 */
public with sharing class FedWorkbook_CsrsOffsetExt {

    private final Lead lead;

    public FedWorkbook_CsrsOffsetExt(ApexPages.StandardController stdController) {
        Id leadId = stdController.getId();
        if (leadId != null) {
            this.lead = [
                SELECT CSRS_Offset__c,
                       Years_of_CSRS_Offset__c,
                       Predicted_Social_Security__c,
                       CSRS_Annuity_Retirement__c
                FROM Lead
                WHERE Id = :leadId
                LIMIT 1
            ];
        } else {
            this.lead = new Lead();
        }
    }

    public Decimal getYearsOfOffset() {
        return lead.Years_of_CSRS_Offset__c == null ? 0 : lead.Years_of_CSRS_Offset__c;
    }

    /** Offset percentage = years / 40, expressed 0..100. */
    public Decimal getOffsetPercentage() {
        return (getYearsOfOffset() / 40) * 100;
    }

    public Decimal getAnnualSocialSecurity() {
        return lead.Predicted_Social_Security__c == null ? 0 : lead.Predicted_Social_Security__c;
    }

    /** Offset dollar amount = Social Security x offset %. */
    public Decimal getOffsetAmount() {
        return getAnnualSocialSecurity() * (getOffsetPercentage() / 100);
    }

    public Decimal getCsrsAnnuity() {
        return lead.CSRS_Annuity_Retirement__c == null ? 0 : lead.CSRS_Annuity_Retirement__c;
    }

    /** Adjusted CSRS annuity after subtracting the offset. */
    public Decimal getAdjustedCsrsAnnuity() {
        return getCsrsAnnuity() - getOffsetAmount();
    }

    /** Total annual annuity = adjusted CSRS + Social Security. */
    public Decimal getTotalAnnualAnnuity() {
        return getAdjustedCsrsAnnuity() + getAnnualSocialSecurity();
    }

    public Decimal getMonthlyAnnuity() {
        return getTotalAnnualAnnuity() / 12;
    }
}
