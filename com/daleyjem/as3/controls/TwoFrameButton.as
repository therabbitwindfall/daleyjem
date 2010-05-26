package com.daleyjem.as3.controls
{
	import com.daleyjem.as3.ExternalImage;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class TwoFrameButton extends Sprite
	{
		private var offImage:ExternalImage;
		private var overImage:ExternalImage;
		private var _overImagePath:String;
		
		public function TwoFrameButton(offImagePath:String, overImagePath:String):void
		{
			buttonMode = true;
			mouseChildren = false;
			
			_overImagePath = overImagePath;
			offImage = new ExternalImage(offImagePath, true);
			offImage.addEventListener(Event.COMPLETE, onOffImageComplete);
			
			addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			addEventListener(MouseEvent.ROLL_OUT, onRollOut);
		}
		
		private function onRollOut(e:MouseEvent):void 
		{
			overImage.alpha = 0;
			offImage.alpha = 1;
		}
		
		private function onRollOver(e:MouseEvent):void 
		{
			offImage.alpha = 0;
			overImage.alpha = 1;
		}
		
		private function onOffImageComplete(e:Event):void 
		{
			overImage = new ExternalImage(_overImagePath, true);
			overImage.alpha = 0;
			overImage.addEventListener(Event.COMPLETE, onOverImageComplete);
		}
		
		private function onOverImageComplete(e:Event):void 
		{
			if (offImage.width > overImage.width)
			{
				overImage.x = (offImage.width / 2) - (overImage.width / 2);
			}
			else
			{
				offImage.x = (overImage.width / 2) - (offImage.width / 2);
			}
			
			if (offImage.height > overImage.height)
			{
				overImage.y = (offImage.height / 2) - (overImage.height / 2);
			}
			else
			{
				offImage.y = (overImage.height / 2) - (offImage.height / 2);
			}
			
			addChild(offImage);
			addChild(overImage);
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
	
}