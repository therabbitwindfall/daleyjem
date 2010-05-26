package com.daleyjem.as3.Utils
{
	public class IO
	{
		public static function getFilesizeFormat(bytes:Number):String
		{
			var appendArray:Array = new Array(
				"B",
				"KB",
				"MB",
				"GB",
				"TB"
			);
			
			var foundAppend:String;
			var foundIndex:uint;
			var appendCount:uint = appendArray.length;
			for (var appendIndex:uint = 0; appendIndex < appendCount; appendIndex++)
			{
				if (bytes >= Math.pow(1024, appendIndex))
				{
					foundAppend = appendArray[appendIndex];
					foundIndex = appendIndex;
				}
			}
			
			bytes = bytes / Math.pow(1024, foundIndex);
			
			if (Math.floor(bytes).toString().length < 4)
			{
				bytes = int(bytes * 10) / 10;
			}
			else
			{
				bytes = Math.floor(bytes);
			}
			
			return bytes.toString() + " " + foundAppend;
		}
	}
}