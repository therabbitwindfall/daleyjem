package com.daleyjem.as3
{
	import flash.external.ExternalInterface;
	
	public class Javascript
	{
		public static function send(js:String):void
		{
			ExternalInterface.call("eval", js);
		}
	}
}