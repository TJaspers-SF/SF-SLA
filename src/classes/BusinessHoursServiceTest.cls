/**
 * Created by Tom Jaspers on 19/02/2020.
 */

@IsTest
private class BusinessHoursServiceTest {
    @IsTest
    static void testGetBusinessHoursById() {
        BusinessHours businessHours = [SELECT Id FROM BusinessHours LIMIT 1];
        System.assert(BusinessHoursService.getBusinessHoursById(businessHours.Id) != null);
        System.assert(BusinessHoursService.getBusinessHoursById(null) != null);
    }

    @IsTest
    static void testGetBusinessHoursByName() {
        BusinessHours businessHours = [SELECT Name FROM BusinessHours LIMIT 1];
        System.assert(BusinessHoursService.getBusinessHoursByName(businessHours.Name) != null);
        System.assert(BusinessHoursService.getBusinessHoursByName('') != null);
    }

    @IsTest
    static void testCalculateTimeRemaining_WithBusinessHours() {
        BusinessHours businessHoursSObject = [SELECT Name FROM BusinessHours LIMIT 1];
        Decimal duration = 20;
        Integer timeSpent = 5;
        Decimal timeLeft = 15;
        Datetime start = Datetime.now();
        // FIXME We need to check if we run this in Business Hours (Workaround)
        Boolean isWithinBusinessHours= BusinessHours.isWithin(businessHoursSObject.Id, start);
        if (isWithinBusinessHours) {
            timeLeft = 15;
        } else {
            timeLeft = 20;
        }

        System.assertEquals(timeLeft, BusinessHoursService.calculateTimeRemaining(businessHoursSObject.Id, start, duration, start.addMinutes(timeSpent)));
    }

    @IsTest
    static void testCalculateTimeRemaining_WithoutBusinessHours() {
        Decimal duration = 20;
        Integer timeSpent = 5;
        Datetime start = Datetime.now();
        System.assertEquals(15, BusinessHoursService.calculateTimeRemaining(null, start, duration, start.addMinutes(timeSpent)));
    }

    @IsTest
    static void testCalculateEndTime_WithBusinessHours() {
        BusinessHours businessHoursSObject = [SELECT Id FROM BusinessHours LIMIT 1];
        Decimal duration = 20;
        Datetime start = Datetime.now();
        Long millisecondsDuration = (duration * DatetimeUtils.MINUTE_TO_MILLISECONDS).longValue();
        Datetime expected = BusinessHours.add(businessHoursSObject.Id, start, millisecondsDuration);
        System.assertEquals(expected.getTime(), BusinessHoursService.calculateEndTime(businessHoursSObject, start, duration).getTime());
    }

    @IsTest
    static void testCalculateEndTime_WithoutBusinessHours() {
        Datetime start = Datetime.now();
        Decimal duration = 20;
        System.assertEquals(start.addMinutes(duration.intValue()), BusinessHoursService.calculateEndTime(null, start, duration));
    }
}