package com.daleyjem.as3.net
{
	public class Uri
	{
		private var _path:String;
		private var _protocol:String;
		private var _host:String;
		private var _port:String;
		private var _trail:String;
		private var _hash:String = null;
		private var _variables:Array = new Array();
		
		public var isRTMP:Boolean = false;
		
		public function Uri(uriPath:String):void
		{
			if (uriPath.split("://").length < 2) return;
			_path = uriPath;
			_protocol = path.split("://")[0];
			_host = path.split("://")[1].split("/")[0];
			_port = (host.split(":").length > 1) ? (host.split(":")[1]) : ("");
			var temp:Object = path.split("://")[1];
			_trail = temp.replace(host, "");
			temp = path.split("#");
			if (temp.length > 1) _hash = temp[1];
			temp = temp[0].split("?");
			if (temp.length > 1)
			{
				temp = temp[1].split("&");
				for each (var raw:String in temp)
				{
					var keyVal:Object = new Object();
					keyVal.key = raw.split("=")[0];
					keyVal.value = raw.split("=")[1];
					_variables.push(keyVal);
				}
			}
			
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
		
		/**
		 * Gets a URL variable.
		 * @param	key	<String> The URL variable name
		 * @return
		 */
		public function getVariable(key:String):Object
		{
			for each (var keyVal:Object in _variables)
			{
				if (keyVal.key == key) return keyVal;
			}
			return null;
		}
		
		/**
		 * Gets the URI of the SWF file calling the function.
		 * @param	returnNonHTTP	<Boolean> If false, returns null when the URI doesn't contain "http://"
		 */
		public static function getThisURI(returnNonHTTP:Boolean = false):String
		{
			
		}
		
		private function rebuildPath():void
		{
			_path = protocol + "://" + host;
			if (port.length > 0) _path += ":" + port;
			_path += trail;
		}
	}
}