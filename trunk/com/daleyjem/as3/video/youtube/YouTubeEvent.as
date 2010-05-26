package com.daleyjem.as3.video.youtube
{
	import flash.events.Event;
	
	public class YouTubeEvent extends Event
	{
		public static const SEARCH_COMPLETE:String	= "searchComplete";
		public static const GET_FLV_COMPLETE:String	= "getFLVComplete"; 
		
		public function YouTubeEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false):void
		{
			super(type, bubbles, cancelable);
		}
	}
	
}