package com.daleyjem.as3.air
{
	import flash.events.Event;
	
	/**
	 * @author Jeremy Daley
	 */
	public class ApplicationUpdateEvent extends Event
	{
		public static const UPDATE_CHECK_COMPLETE:String	= "updateCheckComplete";
		public static const UPDATE_DOWNLOAD_COMPLETE:String	= "updateDownloadComplete";
		
		public function ApplicationUpdateEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false):void
		{
			super(type, bubbles, cancelable);
		}
	}
	
}