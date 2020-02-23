/**
 * Created by Tom Jaspers on 19/02/2020.
 */
@IsTest
public without sharing class DatetimeUtilsTest {
    @IsTest
    static void testVariables() {
        System.assertEquals(60000, DatetimeUtils.MINUTE_TO_MILLISECONDS);
    }
}