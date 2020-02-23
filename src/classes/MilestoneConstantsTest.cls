/**
 * Created by Tom Jaspers on 19/02/2020.
 */
@IsTest
private class MilestoneConstantsTest {
    @IsTest
    static void testVariables() {
        System.assertEquals('New', MilestoneConstants.STATUS_NEW);
        System.assertEquals('In Progress', MilestoneConstants.STATUS_IN_PROGRESS);
        System.assertEquals('Paused', MilestoneConstants.STATUS_PAUSED);
        System.assertEquals('Done', MilestoneConstants.STATUS_DONE);
        System.assertEquals('Dismissed', MilestoneConstants.STATUS_DISMISSED);
        System.assert(MilestoneConstants.CLOSED_STATUSES.containsAll(new List<String> {
                'Done', 'Dismissed'
        }));
        System.assert(MilestoneConstants.PAUSED_STATUSES.contains('Paused'));
    }
}