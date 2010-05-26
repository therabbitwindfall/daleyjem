package com.daleyjem.as3
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import fl.events.SliderEvent;
	
	public class Slider extends MovieClip
	{
		public var maximum:Number = 0;
		
		// getter/setter values
		private var _value:Number = 0;
		
		private var handle:MovieClip;
		private var bar:MovieClip;
		private var isDragging:Boolean = false;
		
		public function Slider():void
		{
			handle = handle_mc;
			handle.buttonMode = true;
			bar = bar_mc;
			handle.addEventListener(MouseEvent.MOUSE_DOWN, StartDrag);
			handle.addEventListener(MouseEvent.MOUSE_UP, StopDrag);
			this.addEventListener(Event.ADDED_TO_STAGE, StageAdd);
		}
		
		public function set value(__value:Number):void
		{
			_value = __value;
			handle.x = bar.width * (_value / maximum);
		}
		
		public function get value():Number
		{
			return _value;
		}
		
		private function StageAdd(e:Event):void
		{
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, CheckMove);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, StopDrag);
		}
		
		private function CheckMove(e:MouseEvent):void
		{
			if (!isDragging) return;
			value = (handle.x / bar.width) * maximum;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function StartDrag(e:MouseEvent):void
		{
			isDragging = true;
			handle.startDrag(false, new Rectangle(bar.x, handle.y, bar.width, 0));
		}
		
		private function StopDrag(e:MouseEvent):void
		{
			isDragging = false;
			handle.stopDrag();
		}
	}
}