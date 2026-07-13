public with sharing class FedWorkbook_Util {

    // Expected retirement age = whole years between the date of birth and the
    // expected retirement date (Expected_Retirement_Date__c - Date_of_Birth__c).
    //
    // The stored Lead.Expected_Retirement_Age__c formula field was unreliable,
    // so every FedWorkbook consumer derives the value here instead, using the
    // same daysBetween/365.25 floor convention the calculators already use for
    // age-from-dates. Callers must query Date_of_Birth__c and
    // Expected_Retirement_Date__c on the Lead they pass in.
    //
    // Returns null when either date is missing so callers can apply their own
    // null handling (null -> 0, null -> 999 gate default, etc.).
    public static Decimal expectedRetirementAge(Lead l) {
        if (l == null || l.Date_of_Birth__c == null || l.Expected_Retirement_Date__c == null) {
            return null;
        }
        return (Decimal) Math.floor(Math.abs(
            l.Date_of_Birth__c.daysBetween(l.Expected_Retirement_Date__c) / 365.25));
    }
}
