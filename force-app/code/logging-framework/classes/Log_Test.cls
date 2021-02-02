@isTest
private class Log_Test {
    
    @isTest
    static void testLogMultipleItemPositive() {
        Log logger = Log.get();
        Test.startTest();
        logger.addLog('testing add string method');
        logger.addLog('Testing 123', LogSeverity.WARN);
        logger.addLog(new DMLException('hi from exception land'));
        logger.addLog(new DMLException('meh'), LogSeverity.DEBUG);
        logger.publishEvents();
        Test.stopTest();
        // Platform Events require this to push the event in a test env
        Test.getEventBus().deliver();

        String currentRequestId = Request.getCurrent().getRequestId();
        //this can't be hard-coded since apex test runs have multiple possible quiddity values
        Quiddity currentQuiddity = Request.getCurrent().getQuiddity();

        List<LogObject__c> events = [
            SELECT Id, RequestId__c, Quiddity__c, LogMessage__c, Severity__c
            FROM LogObject__c
            ORDER BY Severity__c
        ];

        System.assertEquals(4, events.size(), 'Expected to find 3 records');

        for (LogObject__c logEvt : events) {
            System.assertEquals(
                currentRequestId,
                logEvt.RequestId__c,
                'Expected the reuqest id to have been logged'
            );
            System.assertEquals(
                currentQuiddity.name(),
                logEvt.Quiddity__c,
                'Expected quiddity on log message to match apex test context'
            );
            System.assert(
                new Set<String>{
                        Quiddity.RUNTEST_ASYNC.name(),
                        Quiddity.RUNTEST_DEPLOY.name(),
                        Quiddity.RUNTEST_SYNC.name()
                    }
                    .contains(logEvt.Quiddity__c),
                'Expected quiddity to be one of the apex test types, found: ' +
                logEvt.Quiddity__c
            );

            //debug info warn error - proposed
        }

        system.debug('##### ' + events);

        System.debug('Excep '+ events[0].LogMessage__c.split('\n')[0]);

        System.assert(
            events[0].LogMessage__c.split('\n')[0]
                .containsIgnoreCase('Exception type: [System.DMLException] hi from exception land')
        );
        //System.AssertException: Assertion Failed: Expected: Exception: [System.DmlException] meh , Actual: Exception: [System.DMLException] meh
    }
}
