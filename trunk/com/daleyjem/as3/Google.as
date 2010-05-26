package com.daleyjem.as3
{
	import flash.external.ExternalInterface;
	
	public final class Google
	{
		public static function trackPageview(action:String):void
		{
			try
			{
				ExternalInterface.call("pageTracker._trackPageview",  action);
				trace("Google->TrackPageview: Action=" + action); 
			}
			catch (e)
			{
				trace("Google->TrackPageview: Error");
			}
		}
		
		public static function trackEvent(category:String = "", action:String = "", optional_label:String = "", optional_value:Number = NaN):void
		{
			try
			{
				if (isNaN(optional_value))
				{
					ExternalInterface.call("pageTracker._trackEvent", category, action, optional_label);
					trace("Google->TrackEvent: Category=" + category + "; Action=" + action + "; Label=" + optional_label + "; Optional= <not set>");
				}
				else
				{
					ExternalInterface.call("pageTracker._trackEvent", category, action, optional_label, optional_value);
					trace("Google->TrackEvent: Category=" + category + "; Action=" + action + "; Label=" + optional_label + "; Optional=" + optional_value);
				}
			}
			catch (e)
			{
				trace("Google->TrackEvent: Error");
			}
		}
	}
}