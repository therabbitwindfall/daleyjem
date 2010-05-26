function getNextElementsByTagName(theElement, siblingTagName, limit, groupFilter)
{
	var elements = document.getElementsByTagName("*");
	var elementCount = elements.length;
	var elementCounter = 0;
	var returnElements = [];
	var passedTheElement = false;
	var filterAttribute = groupFilter.split("=")[0];
	var filterValue = groupFilter.split("=")[1];
	var groupName = "";
	for (var elementIndex = 0; elementIndex < elementCount; elementIndex++)
	{
		var currElement = elements[elementIndex];
		if (passedTheElement == false)
		{
			if (currElement == theElement) passedTheElement = true;
			continue;
		}
		if (currElement.nodeName.toLowerCase() == siblingTagName.toLowerCase())
		{
			if (limit > 0 && elementCounter == limit) break;
			if (groupFilter != "")
			{
				if (currElement[filterAttribute] == filterValue)
				{
					if (groupName == "") groupName = currElement.name;
					if (currElement.name == groupName) returnElements.push(currElement);
				}
			}
			else
			{
				returnElements.push(currElement);
			}
			elementCounter++;
		}
	}
	return returnElements;
}