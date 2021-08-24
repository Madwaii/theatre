@isTest
public with sharing class RemindOldClientsCRONTest {
    @isTest
    public static void CRONTest() {
        //-------------------------------
        //I HAVE
        //-------------------------------
        String CRON_EXP = '0 0 0 21 5 ? *';
        //-------------------------------
        //I DO
        //-------------------------------
        Test.startTest();
        String jobId = System.schedule(
            'ScheduledApexTest',
            CRON_EXP,
            new RemindOldClientsCRON()
        );
        Test.stopTest();
        //-------------------------------
        //I TEST
        //-------------------------------
        system.assertEquals(1, [SELECT count() FROM CronTrigger WHERE Id =:jobId],
        'A job should be scheduled');

    }
}
