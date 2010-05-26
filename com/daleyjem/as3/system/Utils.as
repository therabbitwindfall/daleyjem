package com.daleyjem.as3.system
{
	import flash.net.LocalConnection;
	
	public final class Utils
	{
		public static function forceGarbageCollection():void
		{
			try 
			{
				var lc1:LocalConnection = new LocalConnection();
				var lc2:LocalConnection = new LocalConnection();
				lc1.connect("name");
				lc2.connect("name");
			}
			catch (e:Error)
			{
			}
			trace("force garbage collection");
		}
	}
	
}