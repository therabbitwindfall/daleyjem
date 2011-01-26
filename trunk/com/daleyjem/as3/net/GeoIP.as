package com.daleyjem.as3.net
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * IP Address lookup generated from current IP (null) or a given value.
	 * @author Jeremy Daley
	 */
	public class GeoIP extends EventDispatcher
	{
		public var address:String = "";
		public var city:String = "";
		public var state:String = "";
		public var zip:String = "";
		public var latitude:String = "";
		public var longitude:String = "";
		public var ip:String = "";
		
		private var geoIPServiceURL:String = "http://api.ipinfodb.com/v2/ip_query.php?key=";
		private var urlLoader:URLLoader;
		private var xml:XML;
		
		/**
		 * Instantiate new IP address lookup object
		 * @param	apiKey	<String> API key for api.ipinfodb.com service
		 * @link	http://api.ipinfodb.com
		 */
		public function GeoIP(apiKey:String = "5d7d1322f912bbca635fb9ab3c51385f32e73392e9c44a1d6fe2a61cbf633a61"):void
		{
			geoIPServiceURL += apiKey;
			urlLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, onLoaderComplete);
		}
		
		public function lookup(ipAddress:String = null):void
		{
			var append:String = "";
			if (ipAddress != null)
			{
				append += "?ip=" + ipAddress;
			}
			urlLoader.load(new URLRequest(geoIPServiceURL + append));
		}
		
		private function onLoaderComplete(e:Event):void 
		{
			xml = new XML(urlLoader.data);
			
			state = xml..RegionName;
			city = xml..City;
			zip = xml..ZipPostalCode;
			latitude = xml..Latitude;
			longitude = xml..Longitude;
			ip = xml..Ip;
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
	
}