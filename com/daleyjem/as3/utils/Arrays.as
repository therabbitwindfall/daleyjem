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
 
		public static function cloneShallow(sourceArray:Object):Object
		{ 
			var returnArray:Array = new Array();
			var itemCount:Number = sourceArray.length;
			for (var i:Number = 0; i < itemCount; i++)
			{
				returnArray.push(sourceArray[i]);
			}
			return returnArray;
		}
		
		public static function randomize(array:Object):Object
		{
			var newArray:Array = new Array();
			while (array.length > 0)
			{
				var obj:Object = array.splice(Math.floor(Math.random() * array.length), 1);
				
				newArray.push(obj[0]);
			}
			return newArray;
		}
		
		public static function sortOnKey(array:Object, key:String):Array
		{
			var count:uint = array.length;
			var newArray:Array = new Array();
			for (var objIndex:uint = 0; objIndex < count; objIndex++)
			{
				var newItem:Array;
				if (typeof(array[objIndex][key]) == "number")
				{
					newItem = new Array(String2.prependCharacter(String(array[objIndex][key]), 9, "0"), array[objIndex]);
				}
				else
				{
					newItem = new Array(array[objIndex][key], array[objIndex]);
				}
				if (typeof(array[objIndex][key]) == "number");
				newArray.push(newItem);
			}
			newArray = newArray.sort();
			var returnArray:Array = new Array();
			for each (var arrayItem:Object in newArray)
			{
				returnArray.push(arrayItem[1]);
			}
			return returnArray;
		}
	}
}