public with sharing class Log {

    /**
     * @description private instance of this log class that backs the
     * singleton get() method.
     */
    private static Log currentInstance;

    /**
     * @description Singleton pattern get method.
     * @returns Log
     */
    public static Log get() {
        if (currentInstance == null) {
            currentInstance = new Log();
        }
        return currentInstance;
    }
    
    //Populate message
    private List<LogMessage> logs;

    private Log(){
        logs = new List<LogMessage>();
    }

    /**
     * @description Add a log including a string message to logs list without publishing it.
     * @param messageTLog The string message to add to the buffer.
     */
    public void addLog(String messageToLog){
        this.addLog(messageToLog, null);        
    }

    /**
     * @description Add a log including a string message to logs list including severity without publishing it.
     * @param messageTLog The string message to add to the buffer.
     * @param severity     LogSeverity enum
     */
    public void addLog(String messageToLog, LogSeverity severity){
        
        LogMessage log = new LogMessage(messageToLog);
        if(severity != null){
            log.severity = severity;              
        }

        logs.add(log);
        
    }

    /**
     * @description Add a log including a Exception message to logs list including severity without publishing it.
     * @param messageTLog The string message to add to the buffer
     */
    public void addLog(Exception exceptionToLog){
        this.addLog(exceptionToLog, null);
    }

    /**
     * @description Add a log including a Exception message to logs list including severity without publishing it.
     * @param messageTLog The string message to add to the buffer.
     * @param severity     LogSeverity enum
     */
    public void addLog(Exception exceptionToLog, LogSeverity severity){
        LogMessage log = new LogMessage(exceptionToLog);
        if(severity != null){
            log.severity = severity;
        }

        logs.add(log);
    }


    public void publishEvents(){
        //For each of the LogMessage we create, we publish an event
        List<sObject> events = new List<sObject>();

        for(LogMessage log : this.logs){

            events.add(log.generateLogEvent());

        }

        System.debug(events);

        EventBus.publish(events);
        this.logs.clear();

    }
}