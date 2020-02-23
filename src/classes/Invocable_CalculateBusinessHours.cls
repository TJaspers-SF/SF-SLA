/**
 * Created by Tom Jaspers on 19/02/2020.
 */

public without sharing class Invocable_CalculateBusinessHours {

    /**
     * Create Milestones by Flows
     *
     * @param params
     */
    @InvocableMethod(Label='Creates Milestones')
    public static void createMilestones(List<BusinessEndTimeParam> params) {
        List<Milestone__c> milestones = new List<Milestone__c>();
        for (BusinessEndTimeParam param : params) {
            Milestone__c milestone = new Milestone__c();
            SObjectField lookUpField;

            MilestoneRule__mdt milestoneRule = MilestoneRuleService.getMilestoneRulesByIds().get(param.milestoneRule);
            Map<String, SObjectField> lookUpFields = SObjectUtils.getLookupsForSObjects(Milestone__c.getSObjectType(), param.currentRecordId.getSobjectType());

            if (lookUpFields.size() == 1) {
                lookUpField = lookUpFields.values()[0];
            } else if (lookUpFields.containsKey(milestoneRule.LookUpApiName__c)) {
                lookUpField = lookUpFields.get(milestoneRule.LookUpApiName__c);
            } else {
                String message = String.format(Label.NO_MILESTONE_LOOKUP_FIELD, new List<String> {
                        param.currentRecordId.getSObjectType().getDescribe().getName(),
                        (String.isBlank(milestoneRule.LookUpApiName__c)) ? '' : milestoneRule.LookUpApiName__c
                });
                throw new MilestoneCalculationException(message);
            }

            BusinessHours businessHours = BusinessHoursService.getBusinessHoursByName(milestoneRule.BusinessHours__c);
            milestone.put(lookUpField, param.currentRecordId);
            milestone.Name = milestoneRule.Label;
            milestone.Start__c = param.startDate;
            milestone.End__c = BusinessHoursService.calculateEndTime(businessHours, param.startDate, milestoneRule.Duration__c);
            milestone.BusinessHours__c = businessHours.Id;
            milestone.TotalDuration__c = milestoneRule.Duration__c;
            milestones.add(milestone);
        }

        insert milestones;
    }

    public class BusinessEndTimeParam {
        @InvocableVariable(Label='Current Record Id' Required=true)
        public Id currentRecordId;

        @InvocableVariable(Label='Start date' Required=true)
        public Datetime startDate;

        @InvocableVariable(Label='Milestone Rule' Required=true)
        public Id milestoneRule;
    }

    public class MilestoneCalculationException extends Exception { }
}