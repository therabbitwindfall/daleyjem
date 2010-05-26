package com.daleyjem.as3.utils
{
	public class Misc
	{
		public static function stringToAscii(string:String):String
		{
			var returnVal:String = "";
			var count:uint = string.length;
			for (var i:uint = 0; i < count; i++)
			{
				var charCode:Number = string.charCodeAt(i);
				returnVal += charCode.toString(16);
			}
			return returnVal;
		}
	}
	
}