/**
 * Created by Tom Jaspers on 19/02/2020.
 */

@IsTest
private class MilestoneTriggerTest {

    @TestSetup
    static void setup() {
        Account acc = new Account(Name='Brightfox');
        insert acc;

        Milestone__c milestone = new Milestone__c(
                Account__c=acc.Id, Name='MilestoneTest',
                Status__c=MilestoneConstants.STATUS_IN_PROGRESS,
                Start__c=Datetime.now(), TotalDuration__c=20, End__c=Datetime.now().addDays(10),
                BusinessHours__c=[SELECT Id FROM BusinessHours LIMIT 1].Id
        );
        insert milestone;
    }

    @IsTest
    static void testSetStatusToClosed() {
        Milestone__c milestone = [SELECT Id FROM Milestone__c LIMIT 1];
        milestone.Status__c = MilestoneConstants.STATUS_DONE;
        update milestone;
        System.assert([SELECT Id FROM Milestone__c WHERE Status__c = :MilestoneConstants.STATUS_DONE AND End__c = TODAY].isEmpty() == false);
    }

    @IsTest
    static void testSetStatusToPaused() {
        Milestone__c milestone = [SELECT Id FROM Milestone__c LIMIT 1];
        milestone.Status__c = MilestoneConstants.STATUS_PAUSED;
        update milestone;
        System.assert([SELECT Id FROM Milestone__c WHERE Status__c = :MilestoneConstants.STATUS_PAUSED AND RemainingTimeMinutes__c <> NULL].isEmpty() == false);
    }

    @IsTest
    static void testSetStatusToPausedAndBackInProgress() {
        Milestone__c milestone = [SELECT Id FROM Milestone__c LIMIT 1];
        milestone.Status__c = MilestoneConstants.STATUS_PAUSED;
        update milestone;
        System.assert([SELECT Id FROM Milestone__c WHERE Status__c = :MilestoneConstants.STATUS_PAUSED AND RemainingTimeMinutes__c <> NULL].isEmpty() == false);

        milestone.Status__c = MilestoneConstants.STATUS_IN_PROGRESS;
        update milestone;
        System.assert([SELECT Id FROM Milestone__c WHERE Status__c = :MilestoneConstants.STATUS_IN_PROGRESS AND RemainingTimeMinutes__c = NULL].isEmpty() == false);
    }
}