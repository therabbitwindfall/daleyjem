package com.daleyjem.as3.utils
{
	public class String2
	{
		public static function prependCharacter(originalString:String, destinationLength:uint, character:String):String
		{
			while (originalString.length < destinationLength)
			{
				originalString = character + originalString;
			}
			return originalString;
		}
		
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
		
		public static function insertAtIndex(target:String, insertText:String, index:int):String
		{
			return target.substr(0, index) + insertText + target.substr(index);
		}
		
		public static function trimParenthetic(raw:String):String
		{
			return raw.split(/\(\S*\)/).join("");
		}
	}
}