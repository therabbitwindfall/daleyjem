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
		}
		
		public function getUserTimeline(userName:String):void
		{
			var js:String = "var theHead = document.getElementsByTagName('head')[0];";
			js += "var scriptElement = document.createElement('script');";
			js += "scriptElement.type = 'text/javascript';";
			js += "scriptElement.src = 'http://api.twitter.com/1/statuses/user_timeline.xml?screen_name=" + userName + "&count=1&callback=onTwitter';";
			js += "theHead.appendChild(scriptElement);";
			
			Javascript.send(js);
		}
	}
}