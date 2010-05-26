package com.daleyjem.as3.ui
{
	import flash.events.Event;
	/**
	 * ...
	 * @author Jeremy Daley
	 */
	public class ConfirmationPanelEvent extends Event
	{
		public static const OK:String		= "ok";
		public static const CANCEL:String	= "cancel";
		
		public function ConfirmationPanelEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false):void
		{
			super(type, bubbles, cancelable);
		}
	}
}