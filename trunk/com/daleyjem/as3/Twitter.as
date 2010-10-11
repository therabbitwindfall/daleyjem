package com.daleyjem.as3
{
	import com.adobe.serialization.json.JSON;
	import flash.events.ErrorEvent;
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	/**
	 * Allows client-side Twitter access by coordinating with the browser.
	 * @author	Jeremy Daley
	 */
	public class Twitter extends EventDispatcher
	{
		public function Twitter():void
		{
			ExternalInterface.addCallback("onUserTimeline", onUserTimeline);
		}
		
		public function getUserTimeline(userName:String):void
		{
			var js:String = "var theHead = document.getElementsByTagName('head')[0];";
			js += "var scriptIncludeElement = document.createElement('script');";
			js += "scriptIncludeElement.type = 'text/javascript';";
			js += "scriptIncludeElement.src = 'http://api.twitter.com/1/statuses/user_timeline.json?screen_name=" + userName + "&count=1&callback=onUserTimeline';";
			js += "var scriptElement = document.createElement('script');";
			js += "scriptElement.type = 'text/javascript';";
			js += "if (isIE) scriptElement.text = \"function onUserTimeline(data){var flashObj = (isIE)?window['" + ExternalInterface.objectID + "']:document['" + ExternalInterface.objectID + "']; flashObj.onUserTimeline(data);}\";";
			js += "if (!isIE) {var scriptText = document.createTextNode(\"function onUserTimeline(data){var flashObj = (isIE)?window['" + ExternalInterface.objectID + "']:document['" + ExternalInterface.objectID + "']; flashObj.onUserTimeline(data);}\"); scriptElement.appendChild(scriptText);};";
			js += "theHead.appendChild(scriptElement);";
			js += "theHead.appendChild(scriptIncludeElement);";
			
			Javascript.send(js);
		}
		
		private function onUserTimeline(data:Object):void
		{
			Javascript.send("alert('" + data[0]["created_at"] + "');");
		}
	}
}