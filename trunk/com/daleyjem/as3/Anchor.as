package com.daleyjem.as3
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import com.daleyjem.as3.Margin;
	import flash.filters.DropShadowFilter;
	import flash.geom.Transform;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	import flash.utils.setTimeout;
	
	public class Anchor extends EventDispatcher
	{
		private var _margin:Margin;
		private var _horizontalAlignment:String = HorizontalAlignment.STRETCH;
		private var _verticalAlignment:String = VerticalAlignment.STRETCH;
		private var _ref:DisplayObject;
		private var _obj:DisplayObject;
		private var refWidth:Number;
		private var refHeight:Number;
		private var refX:Number;
		private var refY:Number;
		private var isRefParent:Boolean = false;
		private var isRefStage:Boolean = false;
		
		/**
		 * Anchors a DisplayObject to a position controlled by margins and resizing of a reference DisplayObject.
		 * 
		 * @param	obj						<DisplayObject> The DisplayObject to anchor to the reference DisplayObject.
		 * @param	ref						<DisplayObject> The reference DisplayObject that determines the anchored DisplayObject's position and size.
		 * @param	objHorizontalAlignment	<String> [com.daleyjem.as3.HorizontalAlignment]
		 * @param	objVerticalAlignment	<String> [com.daleyjem.as3.VerticalAlignment]
		 */
		public function Anchor(obj:DisplayObject, ref:DisplayObject, objMargin:Margin = null, objHorizontalAlignment:String = "", objVerticalAlignment:String = ""):void
		{
			_margin = (objMargin != null) ? (objMargin) : (new Margin());
			_horizontalAlignment = (objHorizontalAlignment != "") ? (objHorizontalAlignment) : (HorizontalAlignment.CENTER);
			_verticalAlignment = (objVerticalAlignment != "") ? (objVerticalAlignment) : (VerticalAlignment.CENTER);
			_ref = ref;
			_obj = obj;
			
			if (getQualifiedSuperclassName(ref).indexOf("DisplayObjectContainer") > -1) isRefParent = checkIsRefParent();
			if (getQualifiedClassName(ref).indexOf("Stage") > -1) isRefStage = true;
			
			/*
			updateLayout();
			
			if (isRefStage)
			{
				refWidth = (ref as Stage).stageWidth;
				refHeight = (ref as Stage).stageHeight;
			}
			else
			{
				refWidth = ref.width;
				refHeight = ref.height;
				refX = ref.x;
				refY = ref.y;
			}
			*/
			
			ref.addEventListener(Event.ENTER_FRAME, updateLayout);
		}
		
		/**
		 * Gets or sets the margin of the anchored DisplayObject in relation to the reference DisplayObject.
		 */
		public function get margin():Margin
		{
			return _margin;
		}
		public function set margin(value:Margin):void
		{
			_margin = value;
			updateLayout();
		}
		
		/**
		 * Gets or sets the method of horizontally repositioning and resizing the anchored object in relation to the reference DisplayObject.
		 */
		public function get horizontalAlignment():String
		{
			return _horizontalAlignment;
		}
		public function set horizontalAlignment(value:String):void
		{
			_horizontalAlignment = value;
			updateLayout();
		}
		
		/**
		 * Gets or sets the method of vertically repositioning and resizing the anchored object in relation to the reference DisplayObject.
		 */
		public function get verticalAlignment():String
		{
			return _verticalAlignment;
		}
		public function set verticalAlignment(value:String):void
		{
			_verticalAlignment = value;
			updateLayout();
		}
		
		private function updateLayout(e:Event = null):void
		{
			if (isRefStage)
			{
				if ((_ref as Stage).stageWidth == refWidth && (_ref as Stage).stageHeight == refHeight) return;
				refWidth = (_ref as Stage).stageWidth;
				refHeight = (_ref as Stage).stageHeight;
			}
			else
			{
				if (_ref.width == refWidth && _ref.height == refHeight && _ref.x == refX && _ref.y == refY) return;
				refX = _ref.x;
				refY = _ref.y;
				refWidth =  _ref.width;
				refHeight = _ref.height;
			}

			var baseX:Number = 0;
			var baseY:Number = 0;
			
			if (!isRefParent)
			{
				baseX = _ref.x;
				baseY = _ref.y;
			}
			
			var newX:Number = _obj.x;
			var newY:Number = _obj.y;
			var newWidth:Number = _obj.width;
			var newHeight:Number = _obj.height;
			
			switch (horizontalAlignment)
			{
				case HorizontalAlignment.CENTER:
					newX = (refWidth / 2) - (_obj.width / 2);
					break;
				case HorizontalAlignment.LEFT:
					newX = margin.left;
					break;
				case HorizontalAlignment.RIGHT:
					newX = refWidth - _obj.width - margin.right;
					break;
				case HorizontalAlignment.STRETCH:
					newX = margin.left;
					newWidth = refWidth - margin.right - margin.left;
					break;
			}
			
			switch (verticalAlignment)
			{
				case VerticalAlignment.CENTER:
					newY = (refHeight / 2) - (_obj.height / 2);
					break;
				case VerticalAlignment.TOP:
					newY = margin.top;
					break;
				case VerticalAlignment.BOTTOM:
					newY = refHeight - _obj.height - margin.bottom;
					break;
				case VerticalAlignment.STRETCH:
					newY = margin.top;
					newHeight = refHeight - margin.bottom - margin.top;
					break;
			}
			
			_obj.x = baseX + newX;
			_obj.y = baseY + newY;
			_obj.width = newWidth;
			_obj.height = newHeight;
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function checkIsRefParent():Boolean
		{
			var tempRef:DisplayObjectContainer = _ref as DisplayObjectContainer;
			try
			{
				var tempIndex:Number = tempRef.getChildIndex(_obj);
			}
			catch (e:Error)
			{
				return false;
			}
			return true;
		}
	}
}