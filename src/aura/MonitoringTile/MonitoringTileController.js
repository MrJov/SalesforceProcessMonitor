({
	handleRecordUpdated: function(component, event, helper) {
		var eventParams = event.getParams();
		if(eventParams.changeType === "LOADED" || eventParams.changeType === "CHANGED") {
			var status = component.get('v.simpleRecord').Status__c 
			if(status === 'SUCCESS' || status === 'UNA TANTUM - SUCCESS') {
				component.set('v.iconOutcome', 'action:approval')
			} else if(status === 'ERROR' || status === 'UNA TANTUM - ERROR' || 'NOT STARTED' || 'NOT ENDED') {
				component.set('v.iconOutcome', 'action:close')
			} else {
				component.set('v.iconOutcome', 'action:refresh')
			}

			var source = component.get('v.simpleRecord').OperationSource__c 
			if(source === 'DB') {
				component.set('v.iconSource', 'utility:database')
			} else if(source === 'FILE') {
				component.set('v.iconSource', 'utility:file')
			} else {
				component.set('v.iconSource', 'utility:salesforce1')
			}

			var target = component.get('v.simpleRecord').OperationTarget__c 
			if(target === 'DB') {
				component.set('v.iconTarget', 'utility:database')
			} else if(target === 'FILE') {
				component.set('v.iconTarget', 'utility:file')
			} else {
				component.set('v.iconTarget', 'utility:salesforce1')
			}
		} else if(eventParams.changeType === "REMOVED") {
			console.log('Record is deleted')
		} else if(eventParams.changeType === "ERROR") {
			console.log('There’s an error while loading, saving, or deleting the record')
		}
	}, 

	handleSaveRecord: function(component, event, helper) {
		component.find("recordEditor").saveRecord($A.getCallback(function(saveResult) {
			if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
				console.log("Save completed successfully.");
			} else if (saveResult.state === "INCOMPLETE") {
				console.log("User is offline, device doesn't support drafts.");
			} else if (saveResult.state === "ERROR") {
				console.log('Problem saving record, error: ' + JSON.stringify(saveResult.error));
			} else {
				console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
			}
		}));
	},

	handleShowModal : function(component, event, helper) {
		var modalBody;
		$A.createComponent("c:MonitoringTileModal", {
				recordId: component.get('v.recordId')
			},
			function(content, status){
				if (status === "SUCCESS"){
					modalBody = content;
					component.find('overlayLib').showCustomModal({
						header: "Process Monitor Details",
						body: modalBody, 
						showCloseButton: true,
						cssClass: "mymodal",
					});
				}                               
			}
		);
	}
})