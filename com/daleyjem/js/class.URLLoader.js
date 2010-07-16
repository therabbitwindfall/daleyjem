function URLLoader()
{
	this.onLoad = null;
	this.xmlHttp = null;
	this.data = null;
	this.addEventListener = function(evt, callback)
	{
		switch (evt)
		{
			case "complete":
				this.onLoad = callback;
				break;
		}
	}
	this.load = function(request)
	{
		this.xmlHttp = new XMLHttpRequest();
		this.xmlHttp.__this__ = this;
		this.xmlHttp.open("GET", request.url, true);
		this.xmlHttp.onreadystatechange = function()
		{
			if (this.readyState == 4)
			{
				this.__this__.data = this.responseText;
				this.__this__.onLoad(this.__this__);
			}
		}
		if (request.method == "GET")
		{
			this.xmlHttp.send(null);
		}	
	}
}