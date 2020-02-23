/**
 * Created by Tom Jaspers on 19/02/2020.
 */

public without sharing class MilestoneRuleService {
    private static Map<Id, MilestoneRule__mdt> milestoneRuleMap;

    /**
     * Get Milestone Rules by Id
     *
     * @return Map<Id, Milestone Rule>
     */
    public static Map<Id, MilestoneRule__mdt> getMilestoneRulesByIds() {
        if (milestoneRuleMap == null) {
            milestoneRuleMap = new Map<Id, MilestoneRule__mdt>([
                    SELECT
                            BusinessHours__c,
                            DeveloperName,
                            Duration__c,
                            Id,
                            Label,
                            MasterLabel,
                            LookUpApiName__c
                    FROM MilestoneRule__mdt
            ]);
        }

        return milestoneRuleMap;
    }
}