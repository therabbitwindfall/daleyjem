package com.daleyjem.as3.net
{
	import flash.events.Event;
	
	/**
	 * @author Jeremy Daley
	 */
	public class InternetFileEvent extends Event
	{
		public static const META_DATA_READY:String			= "metaDataReady";
		public static const FILE_DOWNLOAD_COMPLETE:String	= "fileDownloadComplete";
		public static const FILE_WRITE_COMPLETE:String		= "fileWriteComplete";
		public static const HEADER_POLL_COMPLETE:String		= "headerPollComplete";
		
		public var file:InternetFile;
		
		public function InternetFileEvent(internetFile:InternetFile, type:String, bubbles:Boolean=false, cancelable:Boolean=false):void
		{
			file = internetFile;
			super(type, bubbles, cancelable);
		}
	}
	
}