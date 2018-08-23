global class ProcessMonitorInboundEmail implements Messaging.InboundEmailHandler {
  /******************************************************************************************************************************
  * The email messages sent to the email service must contain the following text template in order to be properly parsed        *
  *                                                                                                                             *
  * PROCESS_TYPE:=[START/END]                                                                                                   *
  * OUTCOME:=[SUCCESS/ERROR]                                                                                                    *
  * SFDC_OBJECT:=[API Name of the salesforce object involved]                                                                   *
  * OPERATION_SOURCE:=[DB/SFDC/FILE]                                                                                            *
  * OPERATION_TARGET:=[DB/SFDC/FILE]                                                                                            *
  * OPERATION_TYPE:=[INSERT/UPSERT/UPDATE/DELETE]                                                                               *
  *                                                                                                                             *
  * Moreover, the subject of the email must be unique, as it is used as external key                                            *
  *                                                                                                                             *
  ******************************************************************************************************************************/
  global static final String PROCESS_TYPE = 'PROCESS_TYPE';
  global static final String OUTCOME = 'OUTCOME';
  global static final String SFDC_OBJECT = 'SFDC_OBJECT';
  global static final String OPERATION_SOURCE = 'OPERATION_SOURCE';
  global static final String OPERATION_TARGET = 'OPERATION_TARGET';
  global static final String OPERATION_TYPE = 'OPERATION_TYPE';
  global static final String START = 'START';
  global static final String STOP = 'END';
  global static final String SUCCESS = 'SUCCESS';
  global static final String ERROR = 'ERROR';
  global static final String UNDEFINED = 'N/A';
  global static final String[] SOURCES = new String[]{'DB', 'SFDC', 'FILE'};
  global static final String[] DB_OPERATIONS = new String[]{'INSERT', 'UPDATE', 'UPSERT', 'DELETE'};
    
  global Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email, Messaging.InboundEnvelope env){
        
    // Create an InboundEmailResult object for returning the result of the Apex Email Service
    Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();

    Map<String, String> mapText = new Map<String, String>();
    for(String line : email.plainTextBody.split('\n')){
      if(!String.isBlank(line) && line.contains(':=')){
        String token = (line.split(':=')[0]).trim();
        String value = (line.split(':=')[1]).trim();
        mapText.put(token, value);
      }
    }
    
    ProcessMonitor__c monitor = new ProcessMonitor__c(LastMessage__c = email.plainTextBody, EmailSubject__c = email.subject);
    if(mapText.get(PROCESS_TYPE) != null && mapText.get(PROCESS_TYPE).equalsIgnoreCase(START)){
      monitor.Start__c = System.now();
    }
    if(mapText.get(PROCESS_TYPE) != null && mapText.get(PROCESS_TYPE).equalsIgnoreCase(STOP)){
      monitor.End__c = System.now();
    }
    monitor.Outcome__c = mapText.get(OUTCOME) != null && (mapText.get(OUTCOME).equalsIgnoreCase(SUCCESS) || mapText.get(OUTCOME).equalsIgnoreCase(ERROR)) ? mapText.get(OUTCOME) : UNDEFINED;
    monitor.SFDCObject__c = mapText.get(SFDC_OBJECT);
    monitor.OperationSource__c = mapText.get(OPERATION_SOURCE) != null && SOURCES.contains(mapText.get(OPERATION_SOURCE)) ? mapText.get(OPERATION_SOURCE) : UNDEFINED;
    monitor.OperationTarget__c = mapText.get(OPERATION_TARGET) != null && SOURCES.contains(mapText.get(OPERATION_TARGET)) ? mapText.get(OPERATION_TARGET) : UNDEFINED;
    monitor.OperationType__c = mapText.get(OPERATION_TYPE) != null && DB_OPERATIONS.contains(mapText.get(OPERATION_TYPE)) ? mapText.get(OPERATION_TYPE) : UNDEFINED;

    Database.upsert(monitor, ProcessMonitor__c.EmailSubject__c, false);
    
    // Return the result for the Apex Email Service
    result.success = true;
    return result;
  }
}