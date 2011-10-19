function Tween(obj)
{
	this.isIE = navigator.userAgent.indexOf("MSIE") > -1;
	this.obj = obj;
	this.incVal = 30;
	this.counter = 0;
	this.destCount = 0;
	this.prop = null;
	this.startVal = 0;
	this.endVal = 0;
	this.origFilters = null;
	this.startOpacity;
	this.destOpacity;
	
	this.position = function(prop, startVal, endVal, duration)
	{
		this.startVal = startVal;
		this.endVal = endVal;
		this.prop = prop;
		this.obj.style[prop] = startVal + "px";
		this.counter = 0;
		this.destCount = Math.floor((duration * 1000) / this.incVal);
		this.incrementPosition(this);
	}
	
	this.incrementPosition = function(thisParent)
	{
		if (thisParent.counter > thisParent.destCount) return;
		var perc = thisParent.counter / thisParent.destCount;
		var newVal = this.startVal + ((this.endVal - this.startVal) * perc);
		if (this.endVal > this.startVal)
		{
			if (newVal > this.endVal) newVal = this.endVal;
		}
		else
		{
			if (newVal < this.startVal) newVal = this.startVal;
		}
		this.obj.style[this.prop] = newVal + "px";
		thisParent.counter++;
		var timer = setTimeout(function(){thisParent.incrementPosition(thisParent);}, thisParent.incVal);
	}
	
	this.fade = function(startOpacity, destOpacity, duration)
	{
		this.startOpacity = startOpacity;
		this.destOpacity = destOpacity;
		
		if (duration == 0)
		{
			this.setOpacity(destOpacity);
			return;
		}
		this.setOpacity(startOpacity);
		
		this.obj.style.visibility = "visible";
		this.counter = 0;
		this.destCount = Math.floor((duration * 1000) / this.incVal);
		
		this.incrementFade(this);
	}
	
	this.incrementFade = function(thisParent)
	{
		if (thisParent.counter > thisParent.destCount) return;
		var timerPerc = thisParent.counter / thisParent.destCount;
		var perc = thisParent.startOpacity + (timerPerc * (thisParent.destOpacity - thisParent.startOpacity));
		thisParent.setOpacity(perc);
		thisParent.counter++;
		
		var timer = setTimeout(function(){thisParent.incrementFade(thisParent);}, thisParent.incVal);
	}
	
	this.setOpacity = function(theOpacity)
	{
		this.obj.style.opacity = +theOpacity;
		if (this.isIE)
		{
			this.obj.style.filter = "progid:DXImageTransform.Microsoft.Alpha(opacity=" + (theOpacity * 100) + ")";
			this.obj.filters.item("DXImageTransform.Microsoft.Alpha").opacity = theOpacity * 100;
		}
	}
}