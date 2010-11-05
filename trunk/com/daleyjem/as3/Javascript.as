package com.daleyjem.as3
{
	import flash.external.ExternalInterface;
	
	public class Javascript
	{
		/**
		 * Allows Flash to call a process of Javascript commands, rather than just functions w/parameters
		 * By using "eval"
		 * @param	js	<String> A single command or series of commands (terminated with ";")
		 * @example	Javascript.send("document.getElementsByTagName('body')[0].innerHTML += 'Appended text'");
		 */
		public static function send(js:String):void
		{
			ExternalInterface.call("eval", js);
		}
	}
}