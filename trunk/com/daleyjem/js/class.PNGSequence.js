function PNGSequence(theSrc, theWidth, theHeight, frames)
{
	this.container;
	this.interval;
	this._width = theWidth;
	this._height = theHeight;
	this.totalFrames = frames;
	this.currentFrame = 0;
	this.speed = 50;
	
	this.container = document.createElement("div");
	this.container.style.backgroundRepeat = "no-repeat";
	this.container.style.backgroundImage = "url(" + theSrc + ")";
	this.container.style.width = theWidth + "px";
	this.container.style.height = theHeight + "px";
}

PNGSequence.prototype.runLoop = function()
{
	var superThis = this;
	this.interval = setTimeout(doLoop, this.speed);
	
	function doLoop()
	{
		superThis.currentFrame++;
		if (superThis.currentFrame == superThis.totalFrames) superThis.currentFrame = 0;
		var leftInc = -(superThis.currentFrame * superThis._width)
		var newPos = leftInc + "px 0px";
		superThis.container.style.backgroundPosition = newPos;
		this.interval = setTimeout(doLoop, superThis.speed);
	}
}

PNGSequence.prototype.runOnce = function()
{
	var superThis = this;
	this.interval = setTimeout(doLoop, this.speed);
	
	function doLoop()
	{
		superThis.currentFrame++;
		if (superThis.currentFrame == superThis.totalFrames)
		{
			return;
		}
		var leftInc = -(superThis.currentFrame * superThis._width)
		var newPos = leftInc + "px 0px";
		superThis.container.style.backgroundPosition = newPos;
		setTimeout(doLoop, superThis.speed);
	}
}

PNGSequence.prototype.addTo = function(parentContainer)
{
	parentContainer.appendChild(this.container);
}

PNGSequence.prototype.stop = function()
{
	clearInterval(this.interval);
}

PNGSequence.prototype.moveTo = function(leftPos, topPos)
{
	
}