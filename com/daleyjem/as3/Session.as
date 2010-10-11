package com.daleyjem.as3
{
	import flash.net.SharedObject;
	
	public class Session
	{
		public static function set(key:String, value:Object, sessionName:String = "cookie"):void
		{
			SharedObject.getLocal(sessionName).data[key] = value;
		}
		
		public static function get(key:String, sessionName:String = "cookie"):Object
		{
			return SharedObject.getLocal(sessionName).data[key];
		}
		
		public static function has(key:String, sessionName:String = "cookie"):Boolean
		{
			return (SharedObject.getLocal(sessionName).data[key] != null);
		}
	}
}