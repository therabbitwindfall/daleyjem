package com.daleyjem.as3.ui
{
	import com.daleyjem.as3.ExternalImage;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Scale9Vertical extends Sprite
	{
		private var topImage:ExternalImage;
		private var middleImage:ExternalImage;
		private var middleImagePath:String;
		private var bottomImage:ExternalImage;
		private var bottomImagePath:String;
		
		public function Scale9Vertical(topPath:String, middlePath:String, bottomPath:String):void
		{
			middleImagePath = middlePath;
			bottomImagePath = bottomPath;
			
			topImage = new ExternalImage(topPath, true)
			topImage.addEventListener(Event.COMPLETE, onTopImageLoaded);
		}	
		
		public function setHeight(newHeight:Number):void
		{
			middleImage.height = newHeight - topImage.height - bottomImage.height;
			bottomImage.y = middleImage.y + middleImage.height;
		}
		
		private function onTopImageLoaded(e:Event):void 
		{
			addChild(topImage);
			middleImage = new ExternalImage(middleImagePath, true);
			middleImage.addEventListener(Event.COMPLETE, onMiddleImageLoaded);
		}
		
		private function onMiddleImageLoaded(e:Event):void 
		{
			middleImage.y = topImage.height;
			addChild(middleImage);
			bottomImage = new ExternalImage(bottomImagePath, true);
			bottomImage.addEventListener(Event.COMPLETE, onBottomImageLoaded);
		}
		
		private function onBottomImageLoaded(e:Event):void 
		{
			bottomImage.y = middleImage.y + middleImage.height;
			addChild(bottomImage);
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}