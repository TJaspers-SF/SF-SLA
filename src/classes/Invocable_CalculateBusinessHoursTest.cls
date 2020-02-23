/**
 * Created by Tom Jaspers on 19/02/2020.
 */

@IsTest
private class Invocable_CalculateBusinessHoursTest {

    @TestSetup
    static void setup() {
        Account acc = new Account(Name='Brightfox');
        insert acc;

        Contact cont = new Contact(FirstName='Tom', LastName='Jaspers');
        insert cont;
    }

    @IsTest
    static void testCreationOfMilestone_WithLookup() {
        Invocable_CalculateBusinessHours.BusinessEndTimeParam param = new Invocable_CalculateBusinessHours.BusinessEndTimeParam();
        param.currentRecordId = [SELECT Id FROM Account LIMIT 1].Id;
        param.startDate = Datetime.now();
        param.milestoneRule = [SELECT Id FROM MilestoneRule__mdt LIMIT 1].Id;

        try {
            Invocable_CalculateBusinessHours.createMilestones(new List<Invocable_CalculateBusinessHours.BusinessEndTimeParam> {
                    param
            });
            System.assert(![SELECT Id FROM Milestone__c].isEmpty(), 'No milestones created!');
        } catch (DmlException e) {
            System.assert(false, e.getDmlMessage(0));
        }
    }

    @IsTest
    static void testCreationOfMilestone_WithoutLookup() {
        Invocable_CalculateBusinessHours.BusinessEndTimeParam param = new Invocable_CalculateBusinessHours.BusinessEndTimeParam();
        param.currentRecordId = [SELECT Id FROM Contact LIMIT 1].Id;
        param.startDate = Datetime.now();
        param.milestoneRule = [SELECT Id FROM MilestoneRule__mdt LIMIT 1].Id;

        try {
            Invocable_CalculateBusinessHours.createMilestones(new List<Invocable_CalculateBusinessHours.BusinessEndTimeParam> {
                    param
            });
            System.assert(false, 'There needs to be an error!');
        } catch (Invocable_CalculateBusinessHours.MilestoneCalculationException e) {
            String message = String.format(Label.NO_MILESTONE_LOOKUP_FIELD, new List<String> {
                    Contact.getSObjectType().getDescribe().getName(),
                    ''
            });
            System.assertEquals(message, e.getMessage());
        }
    }
}