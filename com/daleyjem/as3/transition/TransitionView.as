package com.daleyjem.as3.transition
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	public class TransitionView extends Sprite
	{
		private var __activeObject:DisplayObject;
		private var __targetObject:DisplayObject;
		private var _mask:Sprite;
		
		public function TransitionView(_width:Number, _height:Number):void
		{
			
		}
		
		public function prepare(_activeObject:DisplayObject, _targetObject:DisplayObject):void
		{
			activeObject = _activeObject;
			targetObject = _targetObject;
		}
		
		public function get activeObject():DisplayObject
		{
			return _activeObject;
		}
		public function set activeObject(value:DisplayObject):void
		{
			_activeObject = value;
		}
		
		public function get targetObject():DisplayObject
		{
			return _targetObject;
		}
		public function set targetObject(value:DisplayObject):void
		{
			_targetObject = value;
		}
	}
}