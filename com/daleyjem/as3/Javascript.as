package com.daleyjem.as3
{
	import flash.external.ExternalInterface;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	public class Javascript
	{
		public static function send(js:String):void
		{
			ExternalInterface.call("eval", js);
			//navigateToURL(new URLRequest("javascript:" + js), "_self");
		}
	}
}