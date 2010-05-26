package com.daleyjem.as3
{
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	
	public class GlassButton extends MovieClip
	{
		private var _color:Number;
		/**
		 * Get or set the underlying, overall color of the button.
		 *  Default color is 0x990000 (Maroon)
		 */
		public function get color():Number
		{
			return _color;
		}
		
		public function set color(value:Number):void
		{
			_color = value;
			var newColor:ColorTransform = new ColorTransform();
			newColor.color = color;
			bg_mc.transform.colorTransform = newColor;
		}
		
		public function GlassButton(__color:Number = 0x990000):void
		{
			color = __color;
		}
	}
}