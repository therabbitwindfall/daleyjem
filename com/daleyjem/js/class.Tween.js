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
	
	this.fadeIn = function(duration)
	{
		if (this.isIE)
		{
			this.obj.style.filter = "progid:DXImageTransform.Microsoft.Alpha(opacity=0)";
			this.obj.filters.item("DXImageTransform.Microsoft.Alpha").opacity = 0;
		}
		this.obj.style.opacity = 0;
		this.obj.style.visibility = "visible";
		this.counter = 0;
		this.destCount = Math.floor((duration * 1000) / this.incVal);
		this.incrementFadeIn(this);
	}
	
	this.incrementFadeIn = function(thisParent)
	{
		if (thisParent.counter > thisParent.destCount) return;
		var perc = thisParent.counter / thisParent.destCount;
		thisParent.obj.style.opacity = +perc;
		if (thisParent.isIE)
		{
			thisParent.obj.filters.item("DXImageTransform.Microsoft.Alpha").opacity = Math.ceil(perc * 100);
		}
		thisParent.counter++;
		var timer = setTimeout(function(){thisParent.incrementFadeIn(thisParent);}, thisParent.incVal);
	}
}