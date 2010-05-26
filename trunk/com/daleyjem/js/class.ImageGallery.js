function ImageGallery(containerID, containerWidth, containerHeight)
{
	var images = new Array();
	var moveInterval = .1;
	var timerInterval = 50;
		
	var container = document.getElementById(containerID);
	var imageGallery = document.createElement("div");
	var imageContainer = document.createElement("div");
	var currDestX;
	var timer;
	
	imageGallery.onmousemove = onMouseMove;
	imageGallery.appendChild(imageContainer);
	imageGallery.style.width = containerWidth + "px";
	imageGallery.style.height = containerHeight + "px";
	imageGallery.style.overflow = "hidden";
	imageGallery.style.position = "relative";
	imageContainer.style.position = "absolute";
	imageContainer.style.width = "0px";
	container.appendChild(imageGallery);
	
	function addImage(imagePath)
	{
		var img = new Image();
		img.src = imagePath;
		img.style.cssFloat = "left";
		img.style.styleFloat = "left";
		img.style.display = "block";
		var newWidth = (imageContainer.offsetWidth + img.width);
		imageContainer.style.width = newWidth + "px";
		imageContainer.appendChild(img);
		images.push(img);
	}

	function onMouseMove(e)
	{
		var posx = 0;

		if (!e) var e = window.event;
		
		if (e.pageX || e.pageY)
		{
			posx = e.pageX;
		}
		else if (e.clientX || e.clientY)
		{
			posx = e.clientX + document.body.scrollLeft + document.documentElement.scrollLeft;
		}
		
		var baseX = posx - imageGallery.offsetLeft;
		var percX = baseX / imageGallery.offsetWidth;
		
		currDestX = Math.ceil((percX * imageGallery.offsetWidth) - (percX * imageContainer.offsetWidth));
		
		if (timer == null) timer = setInterval(moveGallery, timerInterval);
	}
	
	function moveGallery()
	{
		var changeX = (currDestX - imageContainer.offsetLeft) * moveInterval;
		if (changeX < 0) changeX = Math.floor(changeX);
		if (changeX > 0) changeX = Math.ceil(changeX);
		if (changeX == 0)
		{
			clearInterval(timer);
			timer = null;
		}
		
		var posx = imageContainer.offsetLeft + changeX;
		
		if (!isNaN(posx))
		{
			imageContainer.style.left = posx + "px";
		}
	}
	
	this.addImage = addImage;
	this.images = images;
}