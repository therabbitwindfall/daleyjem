package com.daleyjem.as3
{
	import com.daleyjem.as3.ExternalImage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	
	public class ExternalImageCollection extends EventDispatcher
	{
		public var images:Array;
		public var bytesTotal:Number = 0;
		public var bytesLoaded:Number = 0;
		
		private var numImagesInit:int = 0;
		
		public function ExternalImageCollection(externalImageArray:Array):void
		{
			images = externalImageArray;
			
			for each (var externalImage:ExternalImage in images)
			{
				externalImage.addEventListener(Event.INIT, onImageInit);
				externalImage.addEventListener(ProgressEvent.PROGRESS, onImageProgress);
			}
		}
		
		private function onImageProgress(e:ProgressEvent):void 
		{
			var tempBytesLoaded:Number = 0;
			for each (var externalImage:ExternalImage in images)
			{
				tempBytesLoaded += externalImage.bytesLoaded;
			}
			bytesLoaded = tempBytesLoaded;
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS));
			if (bytesLoaded == bytesTotal) dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function onImageInit(e:Event):void 
		{
			numImagesInit++;
			if (numImagesInit == images.length)
			{
				for each (var externalImage:ExternalImage in images)
				{
					bytesTotal += externalImage.bytesTotal;
				}
				dispatchEvent(new Event(Event.INIT));
			}
		}
	}
	
}