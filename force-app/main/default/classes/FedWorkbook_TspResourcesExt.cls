public with sharing class FedWorkbook_TspResourcesExt {

    // Current-year IRS statutory limits, sourced from custom metadata
    // (matches the legacy Federal_LeadControllerExtension pattern, lines 16-17 + 570-573).
    public TSP_Contribution__mdt currentYear { get; private set; }

    public FedWorkbook_TspResourcesExt(ApexPages.StandardController stdController) {
        List<TSP_Contribution__mdt> allRecords = [
            SELECT MasterLabel, Regular_Contribution__c, Catch_Up_Contribution__c
            FROM TSP_Contribution__mdt
            ORDER BY MasterLabel ASC
        ];
        if (!allRecords.isEmpty()) {
            // Legacy takes index [1] (the second/newer record); if only one record exists
            // we still want to show it.
            currentYear = allRecords.size() >= 2 ? allRecords[1] : allRecords[0];
        }
    }

    public Decimal getTotalContribution() {
        if (currentYear == null) { return 0; }
        Decimal reg     = currentYear.Regular_Contribution__c  == null ? 0 : currentYear.Regular_Contribution__c;
        Decimal catchUp = currentYear.Catch_Up_Contribution__c == null ? 0 : currentYear.Catch_Up_Contribution__c;
        return reg + catchUp;
    }
}
