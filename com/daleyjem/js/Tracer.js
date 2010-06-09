function Tracer(_width, _height)
{
	var bod = document.getElementsByTagName("body")[0];
	this.container = document.createElement("div");
	this.container.style.width = _width + "px";
	this.container.style.height = _height + "px";
	this.container.style.position = "absolute";
	this.container.style.right = "0";
	this.container.style.top = "0";
	this.container.style.overflow = "auto";
	this.container.style.border = "solid 1px #ccc";
	this.container.style.fontFamily = "Courier";
	this.container.style.fontSize = "14px";
	this.container.style.color = "#333";
	bod.appendChild(this.container);
	
	this.trace = function(str)
	{
		this.container.innerHTML = this.container.innerHTML + str + "<br />";
	}
}