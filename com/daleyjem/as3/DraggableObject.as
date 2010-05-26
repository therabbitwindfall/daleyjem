package com.daleyjem.as3
{
	import com.daleyjem.as3.Utils.DisplayTools;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import com.daleyjem.as3.DragEvent;
	
	[Event(name = "dropOutsideTarget", type = "com.daleyjem.as3.DragEvent")]
	[Event(name = "dropInsideTarget", type = "com.daleyjem.as3.DragEvent")]
	[Event(name = "dragPickup", type = "com.daleyjem.as3.DragEvent")]
	[Event(name = "dragDrop", type = "com.daleyjem.as3.DragEvent")]
	[Event(name = "drag", type = "com.daleyjem.as3.DragEvent")]
	public class DraggableObject extends EventDispatcher
	{
		private var _object:Sprite;
		private var _targetObjects:Array;
		private var _target:Sprite;
		private var _dimPercentage:Number;
		private var startAlpha:Number;
		private var startIndex:Number;
		private var _removeOnDrop:Boolean;
		
		public var props:Object = new Object();
		
		public function DraggableObject(dragObject:Sprite, dragTargets:Array = null, dimPercentage:Number = .5, removeOnDrop:Boolean = false):void
		{
			_removeOnDrop = removeOnDrop;
			_object = dragObject;
			_targetObjects = dragTargets;
			_dimPercentage = dimPercentage;
			startAlpha = _object.alpha;
			_object.stage != null ? init() : _object.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function get targets():Array
		{
			return _targetObjects;
		}
		public function set targets(value:Array):void
		{
			_targetObjects = value;
		}
		
		public function get object():Sprite
		{
			return _object;
		}
		
		public function get dropTarget():Sprite
		{
			return _target;
		}
		
		public function forceDown():void
		{
			_startDrag();
		}
		
		private function init(e:Event = null):void
		{
			startIndex = _object.parent.getChildIndex(_object as Sprite);
			_object.addEventListener(MouseEvent.MOUSE_DOWN, _startDrag);
		}
		
		private function _startDrag(e:MouseEvent = null):void
		{
			startAlpha = _object.alpha;
			_object.alpha = startAlpha - (_dimPercentage * startAlpha);
			if (startIndex < _object.parent.numChildren - 1) _object.parent.swapChildrenAt(startIndex, _object.parent.numChildren - 1);
			_object.startDrag(false, new Rectangle(0, 0, _object.stage.stageWidth - _object.width, _object.stage.stageHeight - _object.height));
			_object.stage.addEventListener(MouseEvent.MOUSE_UP, _stopDrag);
			_object.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			_object.mouseEnabled = false;
		}
		
		private function onMouseMove(e:MouseEvent):void 
		{
			dispatchEvent(new DragEvent(this, DragEvent.DRAG));
		}
		
		private function _stopDrag(e:MouseEvent = null):void
		{
			_object.alpha = startAlpha;
			if (startIndex < _object.parent.numChildren - 1) _object.parent.swapChildrenAt(startIndex, _object.parent.numChildren - 1);
			_object.stopDrag();
			_object.stage.removeEventListener(MouseEvent.MOUSE_UP, _stopDrag);
			_object.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
			if (targets != null && targets.length > 0)
			{
				var targetCount:Number = _targetObjects.length;
				var found:Boolean = false;
				for (var targetIndex:Number = 0; targetIndex < targetCount; targetIndex++)
				{
					var tempTarget:Sprite = targets[targetIndex] as Sprite;
					var stagePoint:Point = DisplayTools.getStagePoint(tempTarget);
					var stageRectangle:Rectangle = new Rectangle(stagePoint.x, stagePoint.y, tempTarget.width, tempTarget.height);
					var mousePoint:Point = new Point(_object.stage.mouseX, _object.stage.mouseY);
					
					if (stageRectangle.containsPoint(mousePoint))
					{
						found = true;
						_target = tempTarget;
						dispatchEvent(new DragEvent(this, DragEvent.DROP_INSIDE_TARGET, true));
						break;
					}
				}
				if (!found)
				{
					_target = null;
					dispatchEvent(new DragEvent(this, DragEvent.DROP_OUTSIDE_TARGET, true));
				}
			}
			
			_object.mouseEnabled = true;
			
			if (_removeOnDrop)
			{
				_object.parent.removeChild(_object);
				_object = null;
			}
			
			dispatchEvent(new DragEvent(this, DragEvent.DRAG_DROP, true));
		}
	}
}