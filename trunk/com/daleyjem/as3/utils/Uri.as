package com.daleyjem.as3.utils
{
	public class Uri
	{
		private var _path:String;
		private var _protocol:String;
		private var _host:String;
		private var _port:String;
		private var _trail:String;
		
		public var isRTMP:Boolean = false;
		
		public function Uri(uriPath:String):void
		{
			if (uriPath.split("://").length < 2) return;
			_path = uriPath;
			_protocol = path.split("://")[0];
			_host = path.split("://")[1].split("/")[0];
			_port = (host.split(":").length > 1) ? (host.split(":")[1]) : ("");
			var temp:String = path.split("://")[1];
			_trail = temp.replace(host, "");
			if (protocol.substr(0, 3).toLowerCase() == "rtm") isRTMP = true;
		}
		
		public function get path():String
		{
			return _path;
		}
		
		public function get protocol():String
		{
			return _protocol;
		}
		public function set protocol(value:String):void
		{
			_protocol = value;
			rebuildPath();
		}
		
		public function get host():String
		{
			return _host;
		}
		
		public function get port():String
		{
			return _port;
		}
		public function set port(value:String):void
		{
			_port = value;
			rebuildPath();
		}
		
		public function get trail():String
		{
			return _trail;
		}
		
		public function getNCPath():String
		{
			return _path.substring(0, _path.lastIndexOf("/"));
		}
		
		private function rebuildPath():void
		{
			_path = protocol + "://" + host;
			if (port.length > 0) _path += ":" + port;
			_path += trail;
		}
	}
}