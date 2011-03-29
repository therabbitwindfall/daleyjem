package com.daleyjem.as3.utils
{
	import flash.utils.ByteArray;
	
	public final class Arrays
	{
		/**
		 * Mimics PHP print_r function.
		 * @param	obj		<Object> Array object
		 * @param	indent	<String> Initial indent
		 */
		public static function print_r(obj:Object, indent:String = ""):void
		{
			var out:String = "";
			
			for (var item:* in obj)
			{
				if (typeof(obj[item]) == "object") out += indent + "[" + item + "] => Object\n";
				else out += indent + "[" + item + "] => " + obj[item] + "\n";
				out += print_r(obj[item], indent + "   ");
			}

			trace(out);
		}
		
		
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
		
		public static function sortOnKey(array:Object, key:String, prependZeros:Boolean = false, numZeros:int = 0):Array
		{
			var count:uint = array.length;
			var newArray:Array = new Array();
			for (var objIndex:uint = 0; objIndex < count; objIndex++)
			{
				var newItem:Array;

				if (prependZeros)
				{
					newItem = new Array(String2.prependCharacter(String(array[objIndex][key]), numZeros, "0"), array[objIndex]);
				}
				else
				{
					newItem = new Array(array[objIndex][key], array[objIndex]);
				}
				
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