package com.daleyjem.as3
{
	import flash.events.ErrorEvent;
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	public class Twitter extends EventDispatcher
	{
		private static const ERR_NO_BROWSER:String = "Browser/javascript not available";
		
		public function Twitter():void
		{
			if (!ExternalInterface.available) dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, ERR_NO_BROWSER));
			//ExternalInterface.call("document.getElementsByTagName(\"body\")[0].innerHTML += \"yo dude\"");
			var js:String = "javascript:document.getElementsByTagName(\"body\")[0].innerHTML += \"yo dude\"";
			//navigateToURL(new URLRequest(js), "_self");
		}
		
		public function test():void
		{
			Javascript.send("document.getElementsByTagName('body')[0].innerHTML += 'dude<br>'; ");
		}
	}
}