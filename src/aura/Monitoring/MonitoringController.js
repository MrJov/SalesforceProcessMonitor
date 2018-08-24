({
  doInit: function(component, event, helper){
    helper.getRecords(component)
  },

  hideSettings: function(component, event, helper){
    helper.toggleSettings(component, false)
  },

  showSettings: function(component, event, helper){
    helper.toggleSettings(component, true)
  }
})