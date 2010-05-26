package com.daleyjem.as3.utils
{
	import flash.utils.ByteArray;
	
	public final class Arrays
	{
		public static function search(haystackArray:Array, needle:Object):Boolean
		{
			for each (var object:Object in haystackArray)
			{
				if (object == needle) return true;
			}
			return false;
		}
 
		public static function cloneShallow(sourceArray:Array):Array 
		{ 
			var returnArray:Array = new Array();
			var itemCount:Number = sourceArray.length;
			for (var i:Number = 0; i < itemCount; i++)
			{
				returnArray.push(sourceArray[i]);
			}
			return returnArray;
		}
	}
}