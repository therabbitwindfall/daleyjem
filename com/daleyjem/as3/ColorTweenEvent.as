package com.daleyjem.as3
{
	import flash.events.Event;
	
	public class ColorTweenEvent extends Event
	{
    	public static const COMPLETE:String = "complete";
		public static const PROGRESS:String = "progress";

		public function ColorTweenEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}