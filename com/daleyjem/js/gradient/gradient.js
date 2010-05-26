/**
	@author		Jeremy M. Daley
	@company	HSR Business to Business
	@title		Web Application Developer
	@email		daleyjem@yahoo.com
*/

/**
	Apply a Top-Bottom or Left-Right gradient (with or without alpha transparency)
	by attaching a "gradient" class to any HTML element. Does not interfere with existing classes
	on element.
	
	Usage:
		<div class="some_existing_class gradient(#rrggbb[aa], #rrggbb[aa][, gradient_direction])">Some Text</div>
		
		@param	color1				= hex rgba color value (alpha hex value optional)
		@param	color2				= hex rgba color value (alpha hex value optional)
		@param	gradient_direction	= (optional) linear direction of gradient transition ("tb" or "lr"). 
									  defaults to "tb" if not specified
		
	Example: 
		gradient(#ffffffff, #00000000, tb)
			
		->	Applies a Top-Bottom gradient with the first color value
			a full-opacity white, and the second color value
			a full-transparency black
		
*/

/* eliminates need for <body onload> */
if (window.addEventListener)
{
	window.addEventListener("load", InitGradient, false);
}
else
{
	window.attachEvent("onload", InitGradient);
}

/* current z-index for layering gradient elements and applied-to elements */
var currZ = 1;

/* runs through DOM and applies gradient to all objects with "gradient" in the classname */
function InitGradient()
{
	var DOM = document.getElementsByTagName("*");
	var elementArray = [];
	
	var DOMCount = DOM.length;
	for (var elementIndex = 0; elementIndex < DOMCount; elementIndex++)
	{
		var theElement		= DOM[elementIndex];
		var elementClass	= theElement.className;
		
		if (elementClass.toLowerCase().indexOf("gradient(") != -1)
		{
			elementArray.push(theElement);
		}
	}
	
	var elementCount = elementArray.length;
	for (var elementIndex = 0; elementIndex < elementCount; elementIndex++)
	{
		CreateGradient(elementArray[elementIndex]);	
	}
}

/**
	@param	string gradElement //element to apply gradient to
	@return	void
*/
function CreateGradient(gradElement)
{
	/* extract gradient class in case other classes on element already exist */
	var divClass	= gradElement.className;
	var pos			= divClass.toLowerCase().indexOf("gradient(");
	var tempStr		= divClass.substr(pos);
	var pos1		= tempStr.indexOf("(");
	var pos2		= tempStr.indexOf(")");
	tempStr			= tempStr.substr(pos1 + 1, pos2 - pos1 - 1);
	
	/* parse parameters supplied by user to apply to gradient */
	var paramArray	= tempStr.split(",");
	var gradStyle	= (paramArray.length > 2) ? paramArray[2].toUpperCase().replace(/ /g, "") : "TB";
	var startHex	= paramArray[0].replace("#", "").replace(" ", "");
	var endHex		= paramArray[1].replace("#", "").replace(" ", "");
	var startAlpha	= (startHex.length > 6) ? startHex.substr(6, 2) : "FF";
	var endAlpha	= (endHex.length > 6) ? endHex.substr(6, 2) : "FF";
	var startR		= parseInt(startHex.substr(0, 2), 16);
	var startG		= parseInt(startHex.substr(2, 2), 16);
	var startB		= parseInt(startHex.substr(4, 2), 16);
	var startA		= Math.round((parseInt(startAlpha, 16) * 100) / 255);
	var endR		= parseInt(endHex.substr(0, 2), 16);
	var endG		= parseInt(endHex.substr(2, 2), 16);
	var endB		= parseInt(endHex.substr(4, 2), 16);
	var endA		= Math.round((parseInt(endAlpha, 16) * 100) / 255);
	
	/* get element's current innerHTML for modification and re-insertion */
	var pullHTML = gradElement.innerHTML;
	
	/* apply relative positioning so that contained gradient container can be absolutely positioned */
	if (gradElement.style.position.toLowerCase() != "absolute")
	{
		gradElement.style.position = "relative";
	}
	
	//gradElement.style.backgroundImage = "diag.gif";
	
	/* extract element's border widths for proper width/height placement on gradient-behind element */
	var borderWidth		= parseInt(gradElement.style.borderRightWidth) + parseInt(gradElement.style.borderLeftWidth);
	var borderHeight	= parseInt(gradElement.style.borderTopWidth) + parseInt(gradElement.style.borderBottomWidth);
	var theWidth		= gradElement.offsetWidth - ((isNaN(borderWidth)) ? 0 : borderWidth);
	var theHeight		= gradElement.offsetHeight - ((isNaN(borderHeight)) ? 0 : borderHeight);

	/* array to contain html for re-insertion */
	var stringArray = [];
	
	/* create an element behind the applied-to element to contain the gradient */
	stringArray.push('<span style="display:block; position:absolute; left:0px; top:0px; z-index:' + currZ + '">');
	var gradIndex = (gradStyle == "TB") ? theHeight : theWidth;

	/* calculate gradual color change, making a 1-pixel wide/high element to fill expanse */
	for (var divIndex = 0; divIndex < gradIndex; divIndex++)
	{
		var valPerc = divIndex / gradIndex;
		var newR 		= startR - (Math.ceil((startR - endR) * valPerc));
		var newG		= startG - (Math.ceil((startG - endG) * valPerc));
		var newB		= startB - (Math.ceil((startB - endB) * valPerc));
		var newA		= startA - (Math.ceil((startA - endA) * valPerc));
		var newWidth	= (gradStyle == "TB") ? theWidth : 1;
		var newHeight	= (gradStyle == "TB") ? 1 : theHeight;
		var newTop		= (gradStyle == "TB") ? divIndex : 0;
		var newLeft		= (gradStyle == "TB") ? 0 : divIndex;
		
		/* using span inside span method */
		if (newA != 100)
		{
			stringArray.push('<span style="display:block; position:absolute; top:' + newTop + 'px; left:' + newLeft + 'px; opacity:' + (newA / 100) + '; -moz-opacity:' + (newA / 100) + '; filter:alpha(opacity=' + newA + '); width:' + newWidth + 'px; height:' + newHeight + 'px; background-color:rgb(' + newR + ',' + newG + ',' + newB + '); "></span>');
		}
		else
		{
			stringArray.push('<span style="display:block; position:absolute; top:' + newTop + 'px; left:' + newLeft + 'px; width:' + newWidth + 'px; height:' + newHeight + 'px; background-color:rgb(' + newR + ',' + newG + ',' + newB + '); "></span>');
		}
	}
	
	stringArray.push('</span>');
	stringArray.push('<span style="display:block; height:100%; position:relative; z-index:' + (currZ + 1) + '; ">' + pullHTML + '</span>');
	
	/* combine all array elements and re-insert into applied-to element */
	var writeStr = stringArray.join("");
	gradElement.innerHTML = writeStr;
	
	/* increment current z-index to use for proper layering */
	currZ += 2;
}