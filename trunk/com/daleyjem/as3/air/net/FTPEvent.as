package com.daleyjem.as3.air.net
{
	import flash.events.Event;
	
	/**
	 * @author Jeremy Daley
	 */
	public class FTPEvent extends Event
	{
		public static const CONNECTED:String		= "connected";
		public static const UPLOAD_COMPLETE:String	= "uploadComplete";
		
		public function FTPEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false):void
		{
			super(type, bubbles, cancelable);
		}
	}
	
}