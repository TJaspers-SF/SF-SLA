/**
 * Created by Tom Jaspers on 19/02/2020.
 */

public without sharing class MilestoneConstants {
    public static final String STATUS_NEW = 'New';
    public static final String STATUS_PAUSED = 'Paused';
    public static final String STATUS_DONE = 'Done';
    public static final String STATUS_DISMISSED = 'Dismissed';
    public static final String STATUS_IN_PROGRESS = 'In Progress';
    public static final Set<String> CLOSED_STATUSES = new Set<String> {
            STATUS_DONE, STATUS_DISMISSED
    };
    public static final Set<String> PAUSED_STATUSES = new Set<String> {
            STATUS_PAUSED
    };
}