package com.daleyjem.as3.ui
{
	import com.daleyjem.as3.controls.FourFrameButton;
	import com.daleyjem.as3.ExternalImage;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class VerticalScrollbar extends Sprite
	{
		private var skinDir:String;
		private var btnScrollUp:FourFrameButton;
		private var btnScrollDown:FourFrameButton;
		private var btnScrollHandle:Scale9Vertical;
		private var scrollBG:ExternalImage;
		private var destHeight:Number;
		private var _value:Number = 0;
		private var scrollDirection:int = 0;
		
		public var isLoaded:Boolean = false;
		
		private static const SCROLL_RATE:Number = 5;
		
		public function VerticalScrollbar(_height:Number, skinDirectory:String):void
		{
			skinDir = skinDirectory;
			if (skinDir.substr(skinDir.length - 1, 1) != "/") skinDir += "/";
			destHeight = _height;
			
			btnScrollUp = new FourFrameButton(skinDir + "btnScrollUp_enabled_up.png",
												skinDir + "btnScrollUp_enabled_over.png",
												skinDir + "btnScrollUp_disabled_up.png",
												skinDir + "btnScrollUp_disabled_over.png");
			btnScrollUp.addEventListener(Event.COMPLETE, onButtonScrollUpLoaded);
		}
		
		public function get value():Number
		{
			return _value;
		}
		public function set value(__value:Number):void
		{
			_value = __value;
		}
		
		public function set percent(__value:Number):void
		{
			btnScrollHandle.setHeight(__value * scrollBG.height);
		}
		
		public function reset():void
		{
			btnScrollHandle.y = scrollBG.y;
			value = 0;
		}
		
		private function onButtonScrollUpLoaded(e:Event):void 
		{
			btnScrollUp.buttonMode = false;
			addChild(btnScrollUp);
			btnScrollDown = new FourFrameButton(skinDir + "btnScrollDown_enabled_up.png",
												skinDir + "btnScrollDown_enabled_over.png",
												skinDir + "btnScrollDown_disabled_up.png",
												skinDir + "btnScrollDown_disabled_over.png");
			btnScrollDown.addEventListener(Event.COMPLETE, onButtonScrollDownLoaded);
		}
		
		private function onButtonScrollDownLoaded(e:Event):void 
		{
			btnScrollDown.y = destHeight - btnScrollDown.height;
			btnScrollDown.buttonMode = false;
			addChild(btnScrollDown);
			
			scrollBG = new ExternalImage(skinDir + "scrollBG_vertical.png", true);
			scrollBG.addEventListener(Event.COMPLETE, onScrollBGLoaded);
		}
		
		private function onScrollBGLoaded(e:Event):void 
		{
			scrollBG.y = btnScrollUp.height;
			scrollBG.height = destHeight - btnScrollUp.height - btnScrollDown.height;
			addChild(scrollBG);
			
			btnScrollHandle = new Scale9Vertical(skinDir + "btnScrollHandle_vertical_top.png",
												skinDir + "btnScrollHandle_vertical_middle.png",
												skinDir + "btnScrollHandle_vertical_bottom.png");
			btnScrollHandle.addEventListener(Event.COMPLETE, onButtonScrollHandleLoaded);
			btnScrollHandle.addEventListener(MouseEvent.MOUSE_DOWN, onScrollHandleMouseDown);
		}
		
		private function onButtonScrollHandleLoaded(e:Event):void 
		{
			btnScrollHandle.y = scrollBG.y;
			addChild(btnScrollHandle);
			
			btnScrollUp.addEventListener(MouseEvent.MOUSE_DOWN, onScrollUpMouseDown);
			btnScrollDown.addEventListener(MouseEvent.MOUSE_DOWN, onScrollDownMouseDown);
			
			isLoaded = true;
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function onScrollDownMouseDown(e:MouseEvent):void 
		{
			scrollDirection = 1;
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onScrollUpMouseDown(e:MouseEvent):void 
		{
			scrollDirection = -1;
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onScrollHandleMouseDown(e:MouseEvent):void 
		{
			btnScrollHandle.startDrag(false, new Rectangle(btnScrollHandle.x, scrollBG.y, 0, scrollBG.height - btnScrollHandle.height));
			stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
		}
		
		private function onStageMouseMove(e:MouseEvent = null):void 
		{
			var actualHeight:Number = scrollBG.height - btnScrollHandle.height;
			var offsetY:Number = btnScrollHandle.y - scrollBG.y;
			value = offsetY / actualHeight;
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function onStageMouseUp(e:MouseEvent):void 
		{
			btnScrollHandle.stopDrag();
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
		}
		
		private function onEnterFrame(e:Event):void 
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			btnScrollHandle.y += (SCROLL_RATE * scrollDirection);
			if (btnScrollHandle.y > ((scrollBG.y + scrollBG.height) -  btnScrollHandle.height)) btnScrollHandle.y = (scrollBG.y + scrollBG.height) - btnScrollHandle.height;
			if (btnScrollHandle.y < scrollBG.y) btnScrollHandle.y = scrollBG.y;
			
			var actualHeight:Number = scrollBG.height - btnScrollHandle.height;
			var offsetY:Number = btnScrollHandle.y - scrollBG.y;
			value = offsetY / actualHeight;
			
			dispatchEvent(new Event(Event.CHANGE));
		}
	}
}