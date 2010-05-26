package com.daleyjem.as3
{
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import com.daleyjem.as3.KeyFocusObject;
	import flash.ui.Keyboard;
	
	public class KeyFocusManager extends EventDispatcher
	{
		public var items:Array = new Array();
		public var currentFocusObject:InteractiveObject;
		//public var currentFocusObject:KeyFocusObject;
		
		public function KeyFocusManager():void
		{
			
		}
		
		public function addItem(focusObject:InteractiveObject):void
		{
			focusObject.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			items.push(focusObject);
		}
		
		public function setFocusTo(focusObject:InteractiveObject):void
		{
			if (focusObject.stage != null)
			{
				focusObject.stage.focus = focusObject;
				currentFocusObject = focusObject;
			}
		}
		
		private function onKeyUp(e:KeyboardEvent):void 
		{
			//var focusObject:KeyFocusObject = e.target as KeyFocusObject;
			//var nextFocusObject:KeyFocusObject;
			var focusObject:InteractiveObject = e.target as InteractiveObject;
			var nextFocusObject:InteractiveObject;
			trace(e.keyCode);
			switch (e.keyCode)
			{
				case Keyboard.LEFT:
					nextFocusObject = getLeftObject(focusObject);
					break;
				case Keyboard.RIGHT:
					nextFocusObject = getRightObject(focusObject);
					break;
				case Keyboard.UP:
					nextFocusObject = getUpObject(focusObject);
					break;
				case Keyboard.DOWN:
					nextFocusObject = getDownObject(focusObject);
					break;
				case Keyboard.ENTER:
					focusObject.dispatchEvent(new Event(Event.SELECT));
					break;
			}
			if (nextFocusObject != null) setFocusTo(nextFocusObject);
		}
		
		private function getLeftObject(focusObject:InteractiveObject):InteractiveObject
		{
			var foundObject:InteractiveObject;
			var currDistance:Number;
			for each (var tempObject:InteractiveObject in items)
			{
				if (getCenterX(tempObject) < focusObject.x)
				{
					var distance:Number = getCenterDistance(tempObject, focusObject);
					if (isNaN(currDistance) || distance < currDistance)
					{
						foundObject = tempObject;
						currDistance = distance;
					}
				}
			}
			return foundObject;
		}
		
		private function getRightObject(focusObject:InteractiveObject):InteractiveObject
		{
			var foundObject:InteractiveObject;
			var currDistance:Number;
			for each (var tempObject:InteractiveObject in items)
			{
				if (getCenterX(tempObject) > focusObject.x + focusObject.width)
				{
					var distance:Number = getCenterDistance(tempObject, focusObject);
					if (isNaN(currDistance) || distance < currDistance)
					{
						foundObject = tempObject;
						currDistance = distance;
					}
				}
			}
			return foundObject;
		}
		
		private function getUpObject(focusObject:InteractiveObject):InteractiveObject
		{
			var foundObject:InteractiveObject;
			var currDistance:Number;
			for each (var tempObject:InteractiveObject in items)
			{
				if (getCenterY(tempObject) < focusObject.y)
				{
					var distance:Number = getCenterDistance(tempObject, focusObject);
					if (isNaN(currDistance) || distance < currDistance)
					{
						foundObject = tempObject;
						currDistance = distance;
					}
				}
			}
			return foundObject;
		}
		
		private function getDownObject(focusObject:InteractiveObject):InteractiveObject
		{
			var foundObject:InteractiveObject;
			var currDistance:Number;
			for each (var tempObject:InteractiveObject in items)
			{
				if (getCenterY(tempObject) > focusObject.y + focusObject.height)
				{
					var distance:Number = getCenterDistance(tempObject, focusObject);
					if (isNaN(currDistance) || distance < currDistance)
					{
						foundObject = tempObject;
						currDistance = distance;
					}
				}
			}
			return foundObject;
		}
		
		private function getCenterX(iObject:InteractiveObject):Number
		{
			return iObject.x + (iObject.width / 2);
		}
		
		private function getCenterY(iObject:InteractiveObject):Number
		{
			return iObject.y + (iObject.height / 2);
		}
		
		private function getCenterDistance(obj1:InteractiveObject, obj2:InteractiveObject):Number
		{
			return Math.sqrt(Math.pow((getCenterX(obj2) - getCenterX(obj1)), 2) + Math.pow((getCenterY(obj2) - getCenterY(obj1)), 2));
		}
	}
}