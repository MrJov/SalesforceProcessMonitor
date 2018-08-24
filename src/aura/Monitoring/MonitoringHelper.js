({
  getRecords: function(component){
    var action = component.get('c.getProcesses')
    action.setCallback(this, function(response){
      if(response.getState() == "SUCCESS"){
        component.set('v.processes', response.getReturnValue())
      }
    })
    $A.enqueueAction(action)
  },

  toggleSettings: function(component, showSettings){
    if(showSettings){
      $A.util.addClass(component.find('iconRight'), 'slds-hide')
      $A.util.removeClass(component.find('iconDown'), 'slds-hide')
      $A.util.removeClass(component.find('settings'), 'slds-hide')
    } else {
      $A.util.addClass(component.find('iconDown'), 'slds-hide')
      $A.util.addClass(component.find('settings'), 'slds-hide')
      $A.util.removeClass(component.find('iconRight'), 'slds-hide')
    }
  }
})