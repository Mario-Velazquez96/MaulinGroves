/**
 * FedWorkbook_FegliACExt
 *
 * Lightweight extension for page 4 (FedWorkbook_FegliAC). Exposes the
 * FEGLI Option A / Option C lookup tables as simple controller
 * properties so the Visualforce page can bind to them directly.
 *
 * Performs its own SOQL rather than calling stdController.addFields().
 * The page-level rendered attribute references Lead fields, which
 * causes the standard controller to load its record before this
 * extension's constructor runs - at which point addFields() throws
 * "You cannot call addFields after you've already loaded the data".
 * A direct query avoids that ordering problem entirely.
 *
 * Underlying Lead fields are the same as the original FEGLIAC.page.
 */
public with sharing class FedWorkbook_FegliACExt {

    private final Lead lead;

    public FedWorkbook_FegliACExt(ApexPages.StandardController stdController) {
        Id leadId = stdController.getId();
        if (leadId != null) {
            this.lead = [
                SELECT FEGLI_Code_Picklist__c,
                       Contact_Age__c,
                       Age_Option_A_Manual__c,
                       Age_Option_C_Manual__c,
                       Multiples_C_Manual__c
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

    /** Option A bi-weekly rate by age band. */
    public Decimal getOptionACost() {
        if (hasFegliCode()) {
            Decimal age = lead.Contact_Age__c;
            if (age == null || age == 0) { return 0; }
            if (age <= 39) { return 0.20; }
            if (age <= 44) { return 0.30; }
            if (age <= 49) { return 0.60; }
            if (age <= 54) { return 1.00; }
            if (age <= 59) { return 1.80; }
            return 6.00;
        }
        String band = lead.Age_Option_A_Manual__c;
        if (band == 'Under 35' || band == '35-39') { return 0.20; }
        if (band == '40-44') { return 0.30; }
        if (band == '45-49') { return 0.60; }
        if (band == '50-54') { return 1.00; }
        if (band == '55-59') { return 1.80; }
        if (band == '60+')   { return 6.00; }
        return 0;
    }

    /** Option C multiples (0-5), from FEGLI code digit or manual picklist. */
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

    /** Option C bi-weekly factor by age band. */
    public Decimal getOptionCBiWeeklyFactor() {
        if (hasFegliCode()) {
            Decimal age = lead.Contact_Age__c;
            if (age == null || age == 0) { return 0; }
            if (age <= 34) { return 0.20; }
            if (age <= 39) { return 0.24; }
            if (age <= 44) { return 0.37; }
            if (age <= 49) { return 0.53; }
            if (age <= 54) { return 0.83; }
            if (age <= 59) { return 1.33; }
            if (age <= 64) { return 2.43; }
            if (age <= 69) { return 2.83; }
            if (age <= 74) { return 3.83; }
            if (age <= 79) { return 5.76; }
            return 7.80;
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
}
