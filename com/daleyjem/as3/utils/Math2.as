package com.daleyjem.as3.utils
{
	public class Math2
	{
		public static function convertDegreesToRadians(degree:Number):Number
		{
			return degree * (Math.PI / 180);
		}
		
		public static function float(value:Number, decimals:uint):Number
		{
			var multiplier:Number = Math.pow(10, decimals);
			var ret:Number = int(value * multiplier) / multiplier;
			return ret;
		}
		
		public static function random(from:Number, to:Number, round:Boolean = true):Number
		{
			var val:Number = (Math.random() * (to - from)) + from;
			return (round) ? (Math.round(val)) : (val);
		}
	}
}