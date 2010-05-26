var promptVal = prompt("Enter a compression value:", "80");
/*
var xui = fl.getDocumentDOM().xmlPanel(fl.configURI + "Commands/symbol_type.xml");
if(xui){
	fl.outputPanel.trace(xui.type.value);
}
*/

var theLibrary = fl.getDocumentDOM().library;
var selectedItems = theLibrary.getSelectedItems();
fl.outputPanel.clear();
for(var itemIndex=0; itemIndex < selectedItems.length; itemIndex++){
	var theItem = selectedItems[itemIndex];
	theItem.quality = Number(promptVal);
	var itemName = theItem.name;
	/*
	var itemDirectoryArray = itemName.split("/");
	var itemNameNoDir = itemDirectoryArray[itemDirectoryArray.length-1];
	var newItemName = itemName.split(".")[0];
	var newItemNameNoDir = itemNameNoDir.split(".")[0];
	var newItem = theLibrary.addNewItem(SymbolType, newItemName);
	theLibrary.editItem(newItemName);
	fl.getDocumentDOM().addItem({x:0,y:0}, theItem);
	*/
	var outputString = "Compress \"" + itemName + "\" to \"" + promptVal + "%\"";
	fl.outputPanel.trace(outputString);
}
fl.outputPanel.trace("Compression Complete!");
//fl.getDocumentDOM().currentTimeline = 0;