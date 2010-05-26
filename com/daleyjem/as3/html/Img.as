package com.daleyjem.as3.HTML
{
	import com.daleyjem.as3.ExternalImage;
	import flash.events.Event;
	
	public class Img extends HTMLElement
	{
		private var externalImage:ExternalImage;
		
		public function Img(_html):void
		{
			super(_html);
			externalImage = new ExternalImage(htmlNode.@src, true);
			externalImage.addEventListener(Event.COMPLETE, onImageLoaded);
		}
		
		private function onImageLoaded(e:Event):void 
		{
			if (width > 0) externalImage.width = width;
			if (height > 0) externalImage.height = height;
			addChild(externalImage);
		}
	}
	
}