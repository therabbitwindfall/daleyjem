package com.daleyjem.as3
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Reflection extends Sprite
	{
		import flash.display.DisplayObject;
		import flash.display.Bitmap;
		import flash.display.BitmapData;
		import flash.geom.Rectangle;
		import flash.geom.Matrix;
		import flash.display.Graphics;
		import flash.display.GradientType;
		import flash.display.SpreadMethod;
		
		private var rObj:DisplayObject;
		private var rOpacity:Number;
		private var rGradientSpread:Number;
		private var rRectangle:Rectangle;
		private var rUpdate:Boolean;
		private var updateInterval:Number = 100;
		private var rScaleY:Number;
		
		/**
		 * Creates a visual, updatable reflection based on the specified DisplayObject.
		 * 
		 * @param	_obj			<DisplayObject> The object to make a reflection of
		 * @param	_update			<Boolean> Speficy if the reflection should update what it displays (for video or animations)
		 * @param	_opacity		<Number> 0-1 ... Total opacity of the reflection
		 * @param	_gradientSpread	<Number> 0-255 ... Gradient spread of the reflections fade to zero opacity
		 * @param	_scaleY			<Number> 0-1 ... Vertical "perspective" scale
		 */
		public function Reflection(_obj:DisplayObject, _update:Boolean = false, _opacity:Number = .4, _gradientSpread:Number = 255, _scaleY:Number = 1):void
		{
			rObj = _obj;
			rOpacity = _opacity;
			rGradientSpread = _gradientSpread;
			rRectangle = new Rectangle(0, 0, rObj.width, rObj.height);
			rScaleY = _scaleY;
			
			CreateBitmapReflection();
			updatable = _update;
		}
		
		/**
		 * Read/Write: Value of 0-255. Spread of the opacity gradient.
		 */
		public function get gradientSpread():Number
		{
			return rGradientSpread;
		}
		 public function set gradientSpread(newGradientSpread:Number):void
		{
			rGradientSpread = newGradientSpread;
			if (rUpdate == false) CreateBitmapReflection();
		}
		
		/**
		 * Read/Write: Value of 0-1. Total opacity of the reflection object.
		 */
		public function get opacity():Number
		{
			return rOpacity;
		}
		 public function set opacity(newOpacity:Number):void
		{
			rOpacity = newOpacity;
			if (rUpdate == false) CreateBitmapReflection();
		}
		
		/**
		 * Read/Write: Determines if reflection should update (video/animations).
		 */
		public function get updatable():Boolean
		{
			return rUpdate;
		}
		public function set updatable(value:Boolean):void
		{
			rUpdate = value;
			if (value)
			{
				if (!hasEventListener(Event.ENTER_FRAME)) addEventListener(Event.ENTER_FRAME, UpdateReflection);
			}
			else
			{
				if (hasEventListener(Event.ENTER_FRAME)) removeEventListener(Event.ENTER_FRAME, UpdateReflection);
			}
		}
		
		private function UpdateReflection(e:Event):void
		{
			CreateBitmapReflection();
		}
		
		private function CreateBitmapReflection():void
		{
			if (numChildren > 0)
			{
				removeChild(getChildByName("rBitmap"));
				removeChild(getChildByName("rMask"));
			}

			var objRect:Rectangle = rRectangle;
			
			var bmp:BitmapData = new BitmapData(objRect.width, objRect.height, true, 0x00000000);
			var mat:Matrix = new Matrix();
			mat.scale(rObj.scaleX, rObj.scaleY);
			bmp.draw(rObj, mat);

			var newBmp:Bitmap = new Bitmap(bmp);
			newBmp.name = "rBitmap";
			newBmp.scaleY = -1 * rScaleY;
			newBmp.y = newBmp.height;

			var fType:String = GradientType.LINEAR;
			var colors:Array = [0x00ff00, 0x00ff00];
			var alphas:Array = [1, 0];
			var ratios:Array = [0, rGradientSpread];
			var matr:Matrix = new Matrix();
			matr.createGradientBox(newBmp.width, newBmp.height, 90 * (Math.PI / 180), 0, 0);
			var sprMethod:String = SpreadMethod.PAD;
			var objMask:Sprite = new Sprite();
			objMask.name = "rMask";
			
			var g:Graphics = objMask.graphics;
			g.beginGradientFill(fType, colors, alphas, ratios, matr, sprMethod);
			g.drawRect(0, 0, newBmp.width, newBmp.height);
			
			newBmp.cacheAsBitmap = true;
			objMask.cacheAsBitmap = true;
			newBmp.mask = objMask;
			
			addChild(objMask);
			addChild(newBmp);
			alpha = rOpacity;
		}
		
	}
}