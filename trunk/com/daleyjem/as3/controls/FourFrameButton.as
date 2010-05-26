package com.daleyjem.as3.controls
{
	import com.daleyjem.as3.ExternalImage;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class FourFrameButton extends Sprite
	{
		private var _state:String = "state1";
	
		private var _state1Over:String;
		private var _state2:String;
		private var _state2Over:String;
		
		private var state1Image:ExternalImage;
		private var state1OverImage:ExternalImage;
		private var state2Image:ExternalImage;
		private var state2OverImage:ExternalImage;
		
		private var images:Array = new Array();
		
		/**
		 * Creates a 4 frame button from a series of supplied image paths
		 * @param	state1		<String> Path to button's default starting state
		 * @param	state1Over	<String> Path to button's starting state when mouse rolled-over
		 * @param	state2		<String> Path to button's onState
		 * @param	state2Over	<String> Path to button's onState when mouse rolled-over
		 */
		public function FourFrameButton(state1:String, state1Over:String, state2:String, state2Over:String):void
		{
			buttonMode = true;
			mouseChildren = false;
			
			_state1Over = state1Over;
			_state2 = state2;
			_state2Over = state2Over;
			
			state1Image = new ExternalImage(state1, true);
			state1Image.addEventListener(Event.COMPLETE, onImage1Complete);
			images.push(state1Image);
			
			addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			addEventListener(MouseEvent.CLICK, onClick);
		}
		
		public function get state():String
		{
			return _state;
		}
		public function set state(val:String):void
		{
			_state = val;
			switch (state)
			{
				case "state1":
					state2Image.alpha = 0;
					state2OverImage.alpha = 0;
					state1OverImage.alpha = 1;
					break;
				case "state2":
					state1Image.alpha = 0;
					state1OverImage.alpha = 0;
					state2OverImage.alpha = 1;
					break;
			}
		}
		
		private function onClick(e:MouseEvent):void 
		{
			if (state == "state1")
			{
				state = "state2";
			}
			else
			{
				state = "state1";
			}
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function onRollOut(e:MouseEvent):void 
		{
			if (state == "state1")
			{
				state1OverImage.alpha = 0;
				state1Image.alpha = 1;
			}
			else
			{
				state2OverImage.alpha = 0;
				state2Image.alpha = 1;
			}
		}
		
		private function onRollOver(e:MouseEvent):void 
		{
			if (state == "state1")
			{
				state1OverImage.alpha = 1;
				state1Image.alpha = 0;
			}
			else
			{
				state2OverImage.alpha = 1;
				state2Image.alpha = 0;
			}
		}
		
		private function onImage1Complete(e:Event):void 
		{
			state1OverImage = new ExternalImage(_state1Over, true);
			state1OverImage.addEventListener(Event.COMPLETE, onImage1OverComplete);
			images.push(state1OverImage);
		}
		
		private function onImage1OverComplete(e:Event):void 
		{
			state2Image = new ExternalImage(_state2, true);
			state2Image.addEventListener(Event.COMPLETE, onImage2Complete);
			images.push(state2Image);
		}
		
		private function onImage2Complete(e:Event):void 
		{
			state2OverImage = new ExternalImage(_state2Over, true);
			images.push(state2OverImage);
			state2OverImage.addEventListener(Event.COMPLETE, onImage2OverComplete);
		}
		
		private function onImage2OverComplete(e:Event):void 
		{
			adjustX();
			adjustY();
			
			state1OverImage.alpha = 0;
			state2Image.alpha = 0;
			state2OverImage.alpha = 0;
			
			addChild(state1Image);
			addChild(state1OverImage);
			addChild(state2Image);
			addChild(state2OverImage);
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function adjustX():void
		{
			var greatestWidth:ExternalImage = (images[0] as ExternalImage);
			for each (var image:ExternalImage in images)
			{
				if (image.width > greatestWidth.width) greatestWidth = image;
			}
			for each (var imagePos:ExternalImage in images)
			{
				if (imagePos != greatestWidth)
				{
					imagePos.x = (greatestWidth.width / 2) - (imagePos.width / 2);
				}
			}
		}
		
		private function adjustY():void
		{
			var greatestHeight:ExternalImage = (images[0] as ExternalImage);
			for each (var image:ExternalImage in images)
			{
				if (image.height > greatestHeight.height) greatestHeight = image;
			}
			for each (var imagePos:ExternalImage in images)
			{
				if (imagePos != greatestHeight)
				{
					imagePos.y = (greatestHeight.height / 2) - (imagePos.height / 2);
				}
			}
		}
	}
	
}