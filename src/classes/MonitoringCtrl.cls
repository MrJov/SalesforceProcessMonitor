public with sharing class MonitoringCtrl {
  @AuraEnabled
  public static List<ProcessMonitor__c> getProcesses(){
    String soql = 'SELECT Id, Name FROM ProcessMonitor__c ORDER BY Name';
    return Database.query(soql);
  }
}