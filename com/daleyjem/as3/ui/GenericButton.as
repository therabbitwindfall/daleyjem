package com.daleyjem.as3.ui
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class GenericButton extends MovieClip
	{
		private var horizontalPadding:Number = 20;
		private var verticalPadding:Number = 5;
		private var dropShadow:DropShadowFilter;
		
		public var label_txt:TextField;
		public var states_mc:MovieClip;
		
		public function GenericButton(_label:String = "Submit"):void
		{
			label_txt = getChildByName("label_txt") as TextField;
			states_mc = getChildByName("states_mc") as MovieClip;
			
			dropShadow = new DropShadowFilter(2, 45, 0, .2, 2, 2);
			buttonMode = true;
			mouseChildren = false;
			filters = [dropShadow];
			
			label_txt.autoSize = TextFieldAutoSize.LEFT;
			
			label = _label;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			gotoAndStop("off");
		}
		
		public function get label():String
		{
			return label_txt.htmlText;
		}
		public function set label(value:String):void
		{
			label_txt.htmlText = value;
			states_mc.width = label_txt.width + (horizontalPadding * 2);
			states_mc.height = label_txt.height + (verticalPadding * 2);
			label_txt.x = (states_mc.width / 2) - (label_txt.width / 2);
			label_txt.y = (states_mc.height / 2) - (label_txt.height / 2);
		}
		
		private function onMouseUp(e:MouseEvent):void 
		{
			states_mc.gotoAndStop("over");
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			states_mc.gotoAndStop("down");
		}
		
		private function onRollOut(e:MouseEvent):void 
		{
			states_mc.gotoAndStop("off");
		}
		
		private function onRollOver(e:MouseEvent):void 
		{
			states_mc.gotoAndStop("over");
		}
	}
}
/*
package com.daleyjem.as3.ui
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class GenericButton extends MovieClip
	{
		private var horizontalPadding:Number = 20;
		private var verticalPadding:Number = 5;
		private var dropShadow:DropShadowFilter;
		
		public var label_txt:TextField;
		public var states_mc:MovieClip;
		
		public function GenericButton(_label:String = "Submit"):void
		{
			label_txt = getChildByName("label_txt") as TextField;
			states_mc = getChildByName("states_mc") as MovieClip;
			
			dropShadow = new DropShadowFilter(2, 45, 0, .2, 2, 2);
			buttonMode = true;
			mouseChildren = false;
			filters = [dropShadow];
			
			label_txt.autoSize = TextFieldAutoSize.LEFT;
			
			label = _label;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			gotoAndStop("off");
		}
		
		public function get label():String
		{
			return label_txt.htmlText;
		}
		public function set label(value:String):void
		{
			label_txt.htmlText = value;
			states_mc.width = label_txt.width + (horizontalPadding * 2);
			states_mc.height = label_txt.height + (verticalPadding * 2);
			label_txt.x = (states_mc.width / 2) - (label_txt.width / 2);
			label_txt.y = (states_mc.height / 2) - (label_txt.height / 2);
		}
		
		private function onMouseUp(e:MouseEvent):void 
		{
			states_mc.gotoAndStop("over");
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			states_mc.gotoAndStop("down");
		}
		
		private function onRollOut(e:MouseEvent):void 
		{
			states_mc.gotoAndStop("off");
		}
		
		private function onRollOver(e:MouseEvent):void 
		{
			states_mc.gotoAndStop("over");
		}
	}
}
*/