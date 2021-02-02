public with sharing class LogMessage {

    //For formatting the message when we log an exception
    private static final String EXCEPTION_STRING_FORMAT = 'Exception type: [{0}] {1} \n StackTrace: {2}';

    public String requestId {
        get {
            if(requestId == null){
                requestId = Request.getCurrent().getRequestId();
            }
            return requestId;
        }
        private set;
    }

    public Quiddity quiddity {
        get {
            if(quiddity == null){
                quiddity = Request.getCurrent().getQuiddity();
            }
            return quiddity;
        }
        private set;
    }

    //Initialize with constructor
    public String message { get; set; }

    public LogSeverity severity { get; set; }

    //Constructor for logging a message
    public LogMessage(String message) {
        this.message = message;
        this.severity = LogSeverity.INFO;
    }

    //Constructor for logging a exception
    public LogMessage(Exception e){
        this.message = String.format(EXCEPTION_STRING_FORMAT,
            new List<String>{
                e.getTypeName(),
                e.getMessage(),
                e.getStackTraceString()
            }
        );
        this.severity = severity;
    }

    public sObject generateLogEvent(){
        return new Log__e(
            Message__c = this.message,
            Quiddity__c = this.quiddity?.name(),
            RequestId__c = this.requestId,
            Severity__c = this.severity?.name()

        );
    }


}