@isTest
private class FedWorkbook_EmployeeInfoExtTest {

    @isTest
    static void testDateGettersSettersAndPlan() {
        Lead l = FedWorkbook_TestData.fersBefore62();

        Test.startTest();
        FedWorkbook_EmployeeInfoExt ext =
            new FedWorkbook_EmployeeInfoExt(FedWorkbook_TestData.sc(l.Id));

        // Date pickers (getters load the queried record, setters mutate it)
        Date dob = Date.newInstance(1970, 1, 15);
        ext.setBirthDate(dob);
        ext.setHireDate(Date.newInstance(2000, 6, 1));
        ext.setRetireDate(Date.newInstance(2032, 6, 1));
        System.assertEquals(dob, ext.getBirthDate(), 'Birth date should round-trip');
        System.assertNotEquals(null, ext.getHireDate(), 'Hire date should be set');
        System.assertNotEquals(null, ext.getRetireDate(), 'Retire date should be set');

        // FEGLI plan checkbox <-> multi-select picklist
        ext.setPlanBasic(true);
        ext.setPlanOptionA(true);
        ext.setPlanOptionB(true);
        ext.setPlanOptionC(true);
        System.assert(ext.getPlanBasic(), 'Basic should be on');
        System.assert(ext.getPlanOptionA(), 'Option A should be on');
        System.assert(ext.getPlanOptionB(), 'Option B should be on');
        System.assert(ext.getPlanOptionC(), 'Option C should be on');

        // Toggle one back off to exercise the remove path
        ext.setPlanOptionA(false);
        System.assert(!ext.getPlanOptionA(), 'Option A should be off after removal');

        ext.saveLead();
        Test.stopTest();
    }

    @isTest
    static void testNullIdConstructorAndSaveError() {
        Test.startTest();
        // No Id: getRecord returns a blank Lead; save then fails and is caught.
        FedWorkbook_EmployeeInfoExt ext =
            new FedWorkbook_EmployeeInfoExt(new ApexPages.StandardController(new Lead()));
        ext.setPlanBasic(true);
        System.assert(ext.getPlanBasic(), 'Plan toggle works without an Id');
        ext.saveLead();
        Test.stopTest();
        System.assert(ApexPages.hasMessages(), 'Saving a Lead with no Id should add an error message');
    }
}
