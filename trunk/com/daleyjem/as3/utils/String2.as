package com.daleyjem.as3.utils
{
	public class String2
	{
		public static function rTrim(raw:String):String
		{
			var charCount:uint = raw.length;
			for (var i:uint = 0; i < charCount; i++)
			{
				if (raw.substr(raw.length - 1, 1) == " ")
				{
					raw = raw.substr(0, raw.length - 1);
				}
				else
				{
					return raw;
				}
			}
			return raw;
		}
	}
}