package com.daleyjem.as3.net
{
	import flash.events.AsyncErrorEvent;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import com.daleyjem.as3.net.Uri;
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	
	[Event(name = "connect", type = "flash.events.Event")]
    [Event(name = "error", type = "flash.events.ErrorEvent")]
	public class NCTest extends EventDispatcher
	{
		private var ppArray:Array = new Array(
			{protocol:"rtmp", port:1935},
			{protocol:"rtmp", port:443},
			{protocol:"rtmp", port:80},
			{protocol:"rtmpt", port:80}
		);
		private var _validUri:String;
		private var _validNetConnection:NetConnection;
		private var ncArray:Array = new Array();
		private var numFailed:Number = 0;
		private var _uri:Uri;
		
		public function NCTest(uri:Uri):void
		{
			_uri = uri;
			for each (var ppItem:Object in ppArray)
			{
				var tempNC:NetConnection = new NetConnection();
				tempNC.proxyType = "best";
				ncArray.push(tempNC);
				uri.protocol = ppItem.protocol;
				uri.port = ppItem.port;
				tempNC.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
				tempNC.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
				trace("Attempting connect:", uri.getNCPath());
				tempNC.connect(uri.getNCPath());
			}
		}
		
		public function get validUri():String
		{
			return _validUri;
		}
		
		public function get validNetConnection():NetConnection
		{
			return _validNetConnection;
		}
		
		public function retest():void
		{
			numFailed = 0;
			var uri:Uri = _uri;
			for each (var ppItem:Object in ppArray)
			{
				var tempNC:NetConnection = new NetConnection();
				tempNC.proxyType = "best";
				ncArray.push(tempNC);
				uri.protocol = ppItem.protocol;
				uri.port = ppItem.port;
				tempNC.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
				tempNC.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
				trace("Attempting connect (\"best\" proxyType):", uri.getNCPath());
				tempNC.connect(uri.getNCPath());
			}
		}
		
		private function onNetStatus(e:NetStatusEvent):void 
		{
			var tempNC:NetConnection = e.target as NetConnection;
			if (tempNC.uri != null)
			{
				trace(tempNC.uri, e.info.code);
			}
			switch (e.info.code.toLowerCase())
			{
				case "netconnection.connect.success":
					_validNetConnection = tempNC;
					_validUri = tempNC.uri;
					closeOtherNC();
					dispatchEvent(new Event(Event.CONNECT));
					break;
				case "netconnection.connect.failed":
				case "netconnection.connect.sslhandshakefailed":
					tempNC.close();
					numFailed++;
					break;
			}
			if (numFailed == ppArray.length) dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
		}
		
		private function closeOtherNC():void
		{
			for each (var tempNC:NetConnection in ncArray)
			{
				if (tempNC != _validNetConnection) tempNC.close();
			}
		}
		
		private function onAsyncError(e:AsyncErrorEvent):void {}
	}
}