/**
 * Created by Tom Jaspers on 18/02/2020.
 */
@IsTest
private class SObjectUtilsTest {

    @IsTest
    static void testGetSObjectType() {
        System.assertEquals(Account.getSObjectType(), SObjectUtils.getSObjectType('Account'));
    }

    @IsTest
    static void testLookupFields() {
        System.assert(SObjectUtils.getLookupsForSObjects(Account.getSObjectType(), Opportunity.getSObjectType()).isEmpty(), 'There is a lookup on account for opportunities');
        System.assert(!SObjectUtils.getLookupsForSObjects(Account.getSObjectType(), Account.getSObjectType()).isEmpty(), 'Salesforce has removed the hierarchy relationship. Salesforce pls?');
    }

    @IsTest
    static void testfieldsMatch() {
        Account leftAccount = new Account(Name = 'Name', Description = 'Description', Phone = '123123123');
        Account rightAccount = new Account(Name = 'Name', Description = 'Description', Phone = '1234');
        System.assertEquals(true, SObjectUtils.fieldsMatch(leftAccount, rightAccount, new Set<Schema.SObjectField>{
                Account.Name, Account.Description
        }), 'Should have been a match');
        System.assertEquals(false, SObjectUtils.fieldsMatch(leftAccount, rightAccount, new Set<Schema.SObjectField>{
                Account.Name, Account.Description, Account.Phone
        }), 'Should NOT have been a match');
    }

    @IsTest
    static void testfieldMatches() {
        Account leftAccount = new Account(Name = 'Name', Phone = '123123123');
        Account rightAccount = new Account(Name = 'Name', Phone = '321321321');
        System.assertEquals(true, SObjectUtils.fieldMatches(leftAccount, rightAccount, Account.Name), 'Account Name Should have been a match');
        System.assertEquals(false, SObjectUtils.fieldMatches(leftAccount, rightAccount, Account.Phone), 'Account Phone Should NOT have been a match');
    }
}