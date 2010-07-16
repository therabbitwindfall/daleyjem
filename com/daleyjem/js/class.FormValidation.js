/*
    Set <label> class for required field to "required"
    If <select> instead of <input>, append class of "req_type_select"
    Use "req_type_[type]" for non-standard text:
        types = req_type_email, req_type_checkbox
    "callback" optional: calls function instead of standard alert box.
*/
function validateForm(formID, goodColor, badColor, callback)
{
	var theForm = document.getElementById(formID);
	var emailRegEx = new RegExp(/^(("[\w-\s]+")|([\w-]+(?:\.[\w-]+)*)|("[\w-\s]+")([\w-]+(?:\.[\w-]+)*))(@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$)|(@\[?((25[0-5]\.|2[0-4][0-9]\.|1[0-9]{2}\.|[0-9]{1,2}\.))((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\.){2}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\]?$)/i);
	var clean = true;
	var labels = theForm.getElementsByTagName("label");
	var labelCount = labels.length;
	
	for (var labelIndex = 0; labelIndex < labelCount; labelIndex++)
	{
		var theLabel = labels[labelIndex];
		var theClass = theLabel.className;
		var classArray = theClass.split(" ");
		var isRequired = array_like(classArray, "required");
		if (isRequired != null)
		{
			var childCount = 1;
			var reqType = "";
			var reqField = "input";
			var reqGroup = "";
			var hasChildren = array_like(classArray, "req_children");
			var hasType = array_like(classArray, "req_type");
			var hasField = array_like(classArray, "req_field");
			var hasGroup = array_like(classArray, "req_group");
			
			if (hasChildren != null) childCount = classArray[hasChildren].split("_")[2];
			if (hasType != null) reqType = classArray[hasType].split("_")[2];
			if (hasField != null) reqField = classArray[hasField].split("_")[2];
			if (hasGroup != null)
			{
				reqType = classArray[hasGroup].split("_")[2];
				childCount = 0;
				reqGroup = "type=" + reqType;
			}
			
			var formElements = getNextElementsByTagName(theLabel, reqField, childCount, reqGroup);
			var formElementCount = formElements.length;
			var hasError = false;
			var numChecked = 0;
			for (var formElementIndex = 0; formElementIndex < formElementCount; formElementIndex++)
			{
				var formElement = formElements[formElementIndex];
				switch (reqType)
				{
					case "email":
						if (!emailRegEx.test(formElement.value.split(" ").join(""))) hasError = true;
						break;
					case "checkbox":
						if (formElement.checked == true) numChecked++;
						break;
					default:
						if (formElement.value.split(" ").join("").length == 0) hasError = true;
						break;
				}
			}
			
			if (hasGroup != null && numChecked == 0) hasError = true;
			
			if (hasError)
			{
				theLabel.style.color = badColor;
				clean = false;
			}
			else
			{
				theLabel.style.color = goodColor;
			}
		}
	}

	if (clean == false) {
	    if (callback != null) {
	        callback();
	    }
	    else {
	        alert("Please fill in the highlighted fields before submitting and try again");
	    }
	}
	return clean;
}