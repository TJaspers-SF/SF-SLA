/**
 * Created by Tom Jaspers on 19/02/2020.
 */

@IsTest
private class MilestoneRuleServiceTest {
    @IsTest
    static void testToGetAllMilestoneRules() {
        System.assert(!MilestoneRuleService.getMilestoneRulesByIds().isEmpty(), 'There are no rules created!');
    }
}