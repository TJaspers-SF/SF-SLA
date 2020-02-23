/**
 * Created by Tom Jaspers on 18/02/2020.
 */

public without sharing class BusinessHoursService {
    public static Map<String, BusinessHours> businessHoursByName;
    public static Map<Id, BusinessHours> businessHoursById;
    public static BusinessHours defaultBusinessHour;

    /**
     * Fill all maps to use
     */
    private static void fillMaps() {
        if (businessHoursByName == null || businessHoursById == null) {
            businessHoursByName = new Map<String, BusinessHours>();
            businessHoursById = new Map<Id, BusinessHours>();
            for (BusinessHours hour : [
                    SELECT
                            Id,
                            IsDefault,
                            Name
                    FROM BusinessHours
                    WHERE IsActive = TRUE
            ]) {
                if (hour.IsDefault) defaultBusinessHour = hour;
                businessHoursByName.put(hour.Name, hour);
                businessHoursById.put(hour.Id, hour);
            }
        }
    }

    /**
     * Get Business Hours SObject by Id
     *
     * @param recordId Business Hour Id
     *
     * @return Business Hours SObject
     */
    public static BusinessHours getBusinessHoursById(Id recordId) {
        BusinessHours businessHours;
        fillMaps();

        if (businessHoursById.containsKey(recordId)) {
            businessHours = businessHoursById.get(recordId);
        } else if (defaultBusinessHour != null) {
            businessHours = defaultBusinessHour;
        }
        return businessHours;
    }

    /**
     * Get Business Hours SObject by Business Hour Name
     *
     * @param name Business Hour Name
     *
     * @return Business Hours SObject
     */
    public static BusinessHours getBusinessHoursByName(String name) {
        BusinessHours businessHours;
        fillMaps();

        if (businessHoursByName.containsKey(name)) {
            businessHours = businessHoursByName.get(name);
        } else if (defaultBusinessHour != null) {
            businessHours = defaultBusinessHour;
        }
        return businessHours;
    }

    /**
     * Calculate the remaining time based on business hours
     *
     * @param businessHourId business hour id
     * @param start time it was started
     * @param duration duration in minutes
     * @param pauseDatetime paused on
     *
     * @return Remaining time in minutes
     */
    public static Decimal calculateTimeRemaining(Id businessHourId, Datetime start, Decimal duration, Datetime pauseDatetime) {
        Decimal spent;
        if (String.isBlank(businessHourId)) {
            spent = (pauseDatetime.getTime() - start.getTime());
        } else {
            spent = BusinessHours.diff(businessHourId, start, pauseDatetime);
        }
        spent = spent / DatetimeUtils.MINUTE_TO_MILLISECONDS;
        return (duration - spent);
    }

    /**
     * Calculate the end time of business hours
     *
     * @param businessHourSObject Business Hour SObject
     * @param start Starting point of the calculation
     * @param durationInMinutes duration in minutes to add up on the starting time
     *
     * @return End date in comparison with Business Hours
     */
    public static Datetime calculateEndTime(BusinessHours businessHourSObject, Datetime start, Decimal durationInMinutes) {
        if (businessHourSObject == null) {
            return start.addMinutes(durationInMinutes.intValue());
        } else {
            Long milliseconds = DatetimeUtils.MINUTE_TO_MILLISECONDS * durationInMinutes.intValue();
            return BusinessHours.add(businessHourSObject.Id, start, milliseconds);
        }
    }

}