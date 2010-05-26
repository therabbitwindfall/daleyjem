package com.daleyjem.as3.video
{
	import flash.events.Event;
	
	public class VideoObjectEvent extends Event
	{
		public static const PLAY_PROGRESS:String		= "playProgress";
    	public static const PLAY_STATE_PLAYING:String	= "playStatePlaying";
		public static const PLAY_STATE_PAUSED:String	= "playStatePaused";
		public static const PLAY_STATE_STOPPED:String	= "playStateStopped";
		public static const PLAY_STATE_COMPLETE:String	= "playStateComplete";
		public static const VIDEO_READY:String			= "videoReady";
		public static const META_DATA_READY:String		= "metaDataReady";
		public static const INVALID_CONNECTION:String	= "invalidConnection";
		public static const BUFFER_START:String			= "bufferStart";
		public static const BUFFER_COMPLETE:String		= "bufferComplete";
		
		public function VideoObjectEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}