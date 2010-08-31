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
		private var numImagesComplete:int = 0;
		private var hasDispatchedComplete:Boolean = false;
		
		public function ExternalImageCollection(externalImageArray:Array):void
		{
			images = externalImageArray;
			
			for each (var externalImage:ExternalImage in images)
			{
				externalImage.addEventListener(Event.COMPLETE, onImageComplete);
				externalImage.addEventListener(Event.INIT, onImageInit);
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
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, bytesLoaded, bytesTotal));
		}
		
		private function onImageInit(e:Event):void 
		{
			numImagesInit++;
			if (numImagesInit == images.length)
			{
				for each (var externalImage:ExternalImage in images)
				{
					externalImage.addEventListener(ProgressEvent.PROGRESS, onImageProgress);
					bytesTotal += externalImage.bytesTotal;
				}
				dispatchEvent(new Event(Event.INIT));
			}
		}
		
		private function onImageComplete(e:Event):void 
		{
			numImagesComplete++;
			if (numImagesComplete == images.length)
			{
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
	}
	
}