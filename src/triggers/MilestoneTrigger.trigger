/**
 * Created by Tom Jaspers on 19/02/2020.
 */

trigger MilestoneTrigger on Milestone__c (before update) {
    new MilestoneTriggerHandler().run();
}