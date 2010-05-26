function array_like(theArray, needle)
{
	needle = needle.toLowerCase();
	var indexCount = theArray.length;
	for (var arrayIndex = 0; arrayIndex < indexCount; arrayIndex++)
	{
		var theValue = theArray[arrayIndex].toLowerCase();
		if (theValue.indexOf(needle) > -1) return arrayIndex;
	}
	return null;
}