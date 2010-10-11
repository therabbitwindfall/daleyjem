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
		
		public static function randomize(array:Array):Array
		{
			var newArray:Array = new Array();
			while (array.length > 0)
			{
				var obj:Array = array.splice(Math.floor(Math.random() * array.length), 1);
				newArray.push(obj[0]);
			}
			return newArray;
		}
	}
}