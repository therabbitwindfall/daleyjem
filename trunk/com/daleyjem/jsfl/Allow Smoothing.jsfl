var promptVal = prompt("Allow Smoothing? (1=Yes, 0=No)", "1");
var theLibrary = fl.getDocumentDOM().library;
var selectedItems = theLibrary.getSelectedItems();

fl.outputPanel.clear();

for(var itemIndex=0; itemIndex < selectedItems.length; itemIndex++){
	var theItem = selectedItems[itemIndex];
	theItem.allowSmoothing = (promptVal=="1") ? (true) : (false);
	var itemName = theItem.name;

	var enableDisable = (promptVal=="1") ? ("Enable") : ("Disable");
	var outputString = enableDisable + " smoothing on: " + itemName;
	fl.outputPanel.trace(outputString);
}

fl.outputPanel.trace("Smoothing Complete!");