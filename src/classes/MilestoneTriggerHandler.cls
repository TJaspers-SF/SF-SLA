/**
 * Created by Tom Jaspers on 19/02/2020.
 */

public without sharing class MilestoneTriggerHandler extends TriggerHandler {
    private List<Milestone__c> newList;
    private Map<Id, Milestone__c> oldMap;

    public MilestoneTriggerHandler() {
        this.newList = (List<Milestone__c>) Trigger.new;
        this.oldMap = (Map<Id, Milestone__c>) Trigger.oldMap;
    }

    public override void beforeUpdate() {
        Datetime now = Datetime.now();
        for (Milestone__c milestone : newList) {
            Milestone__c oldMilestone = oldMap.get(milestone.Id);

            // Closed
            if (MilestoneConstants.CLOSED_STATUSES.contains(milestone.Status__c)
                    && !SObjectUtils.fieldMatches(milestone, oldMilestone, Milestone__c.Status__c)) {
                milestone.End__c = now;
                milestone.UniqueKey__c = null;
                continue;
            }

            // Changed To Paused
            if (MilestoneConstants.PAUSED_STATUSES.contains(milestone.Status__c)
                    && !SObjectUtils.fieldMatches(milestone, oldMilestone, Milestone__c.Status__c)) {
                if (!milestone.IsViolated__c && milestone.End__c >= now) {
                    milestone.Paused__c = now;
                    milestone.RemainingTimeMinutes__c = BusinessHoursService.calculateTimeRemaining(
                            milestone.BusinessHours__c
                            , milestone.Start__c
                            , milestone.TotalDuration__c
                            , milestone.Paused__c
                    );
                } else {
                    milestone.Paused__c = now;
                }
            }

            // Changed To In Progress
            if (MilestoneConstants.STATUS_IN_PROGRESS.containsIgnoreCase(milestone.Status__c)
                    && MilestoneConstants.PAUSED_STATUSES.contains(oldMilestone.Status__c)) {
                milestone.End__c = BusinessHoursService.calculateEndTime(BusinessHoursService.getBusinessHoursById(milestone.BusinessHours__c), now, milestone.RemainingTimeMinutes__c);
                milestone.Paused__c = null;
                milestone.RemainingTimeMinutes__c = null;
            }

        }
    }
}