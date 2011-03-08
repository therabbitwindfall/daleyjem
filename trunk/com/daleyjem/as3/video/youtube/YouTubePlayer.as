package com.daleyjem.as3.video.youtube
{
	import com.adobe.net.URI;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	/**
	 * Skinned YouTube Player
	 * @author Jeremy Daley
	 */
	public class YouTubePlayer extends Sprite
	{
		public var isPlaying:Boolean = false;
		public var time:Number;
		public var duration:Number;
		
		private var loaderURL:String;
		private var loader:Loader;
		private var player:Object;
		
		private static const URL_PREPEND:String = "http://www.youtube.com/v/";
		
		public static const STATE_PLAYING:String	= "youtubePlaying";
		public static const STATE_BUFFERING:String	= "youtubeBuffering";
		public static const STATE_COMPLETE:String	= "youtubeComplete";
		public static const PLAY_PROGRESS:String	= "youtubePlayProgress";
		
		public function YouTubePlayer(_id:String, _autoPlay:Boolean = false, _apiVersion:Number = 3):void
		{
			loaderURL = URL_PREPEND + _id + "?version=" + _apiVersion.toString() + "&autoplay=" + ((_autoPlay) ? ("1") : ("0"));
			
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.INIT, onLoaderInit);
			loader.load(new URLRequest(loaderURL));
			
			addChild(loader);
		}
		
		private function onLoaderInit(e:Event):void 
		{
			player = loader.content;
			player.addEventListener("onReady", onYoutubeReady);
			player.addEventListener("onStateChange", onYoutubePlaystateChange);
			player.addEventListener("onError", onYoutubeError);
		}
		
		private function onYoutubeError(e:Event):void 
		{
			trace("youtube error");
		}
		
		private function onYoutubePlaystateChange(e:Event):void 
		{
			switch (player.getPlayerState())
			{
				case 0:
					isPlaying = false;
					dispatchEvent(new Event(STATE_COMPLETE));
					break;
				case 1:
					isPlaying = true;
					dispatchEvent(new Event(STATE_PLAYING));
					break;
				case 3:
					isPlaying = false;
					dispatchEvent(new Event(STATE_BUFFERING));
					break;
			}
			
			if (isPlaying)
			{
				addEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
			else
			{
				if (hasEventListener(Event.ENTER_FRAME)) removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}
		
		private function onEnterFrame(e:Event):void 
		{
			time = player.getCurrentTime();
			dispatchEvent(new Event(PLAY_PROGRESS));
		}
		
		private function onYoutubeReady(e:Event):void 
		{
			duration = player.getDuration();
			dispatchEvent(new Event(Event.INIT));
		}
	}
}