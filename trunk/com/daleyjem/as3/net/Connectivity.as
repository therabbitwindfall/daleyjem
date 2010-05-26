package com.daleyjem.as3.net
{
	import air.net.URLMonitor;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.net.URLRequest;
	
	[Event(name="networkChange", type="flash.events.Event")]
	/**
	 * Class to check for internet connectivity.
	 * @author Jeremy Daley
	 */
	public class Connectivity extends EventDispatcher
	{
		public static const CONNECT_FAILED:String = "connectFailed";
		public static const CONNECT_SUCCESS:String = "connectSuccess";
		
		public var status:String;
		
		private var monitor:URLMonitor;
		
		public function Connectivity(connectUri:String):void 
		{
			monitor = new URLMonitor(new URLRequest(connectUri));
			monitor.addEventListener(StatusEvent.STATUS, onMonitorStatus);
			monitor.start();
		}	
		
		private function onMonitorStatus(e:StatusEvent):void 
		{
			(e.target as URLMonitor).stop();
			switch (e.code)
			{
				case "Service.available":
					monitor.removeEventListener(StatusEvent.STATUS, onMonitorStatus);
					status = CONNECT_SUCCESS;
					dispatchEvent(new Event(Event.NETWORK_CHANGE));
					break;
				case "Service.unavailable":
					monitor.removeEventListener(StatusEvent.STATUS, onMonitorStatus);	
					status = CONNECT_FAILED;
					dispatchEvent(new Event(Event.NETWORK_CHANGE));
					break;
			}
			monitor = null;
		}
	}
}