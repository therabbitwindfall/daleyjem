package com.daleyjem.as3.video.youtube
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	
	[Event(name = "searchComplete", type = "com.daleyjem.as3.YouTubeEvent")]
	[Event(name = "getFLVComplete", type = "com.daleyjem.as3.YouTubeEvent")]
	[Event(name = "error", type = "flash.events.ErrorEvent")]
	public class YouTube extends EventDispatcher
	{
		private var atomNS:Namespace = new Namespace("http://www.w3.org/2005/Atom");
		
		public var searchResults:Array = new Array();
		public var flvURL:String = "";
		
		private static const URL_SEARCH_PREPEND:String	= "http://gdata.youtube.com/feeds/api/videos?";
		private static const URL_PAGE_PREPEND:String	= "http://www.youtube.com/watch?";
		private static const URL_GET_PREPEND:String		= "http://www.youtube.com/get_video?";
		
		/**
		 * Instantiates a YouTube object for calling methods that
		 * pull data from the YouTube data API
		 */
		public function YouTube(){}
		
		/**
		 * Gets the full URL of the FLV file asynchronously
		 * @param	videoID	<String> The video "id" of the <YouTubeSearchResult>
		 */
		public function getVideoURL(videoID:String):void
		{
			var requestURL:String = URL_PAGE_PREPEND + "v=" + videoID;
			var getStream:URLStream = new URLStream();
			getStream.addEventListener(Event.COMPLETE, onGetURLComplete);
			getStream.load(new URLRequest(requestURL));
		}
		
		/**
		 * Makes an asynchronous call to the YouTube data API for results matching your search query.
		 * @param	query		<String> Search terms for YouTube videos
		 * @param	maxResults	<uint> Number of max results to retrieve from YouTube data API
		 */
		public function search(query:String, maxResults:uint = 10):void
		{
			query = query.split(" ").join("+");
			var requestURL:String = URL_SEARCH_PREPEND + "q=" + query + "&max-results=" + maxResults;
			var searchLoader:URLLoader = new URLLoader();
			searchLoader.addEventListener(Event.COMPLETE, onSearchLoaderComplete);
			searchLoader.load(new URLRequest(requestURL));
		}
		
		private function onGetURLComplete(e:Event):void 
		{
			var getStream:URLStream = e.target as URLStream;
			var htmlSource:String = getStream.readUTFBytes(getStream.bytesAvailable);
			getStream.close();
			
			var regEx:RegExp = /"t": "(.*?)"/;
			var result:Array = htmlSource.match(regEx);
			if (result == null || result.length < 2)
			{
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
				return;
			}
			var param_t:String = result[1];
			
			regEx = /"video_id": "(.*?)"/;
			result = htmlSource.match(regEx);
			if (result.length < 2)
			{
				trace("YouTube: Error matching RegEx");
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
				return;
			}
			var param_video_id:String = result[1];
			
			flvURL = URL_GET_PREPEND + "video_id=" + param_video_id + "&t=" + param_t;
			trace("YouTube: found URL:", flvURL);
			dispatchEvent(new YouTubeEvent(YouTubeEvent.GET_FLV_COMPLETE));
		}
		
		private function onSearchLoaderComplete(e:Event):void 
		{
			var searchLoader:URLLoader = e.target as URLLoader;
			var resultXML:XML = new XML(searchLoader.data);
			for each (var entryNode:XML in resultXML..atomNS::entry)
			{
				searchResults.push(new YouTubeSearchResult(entryNode));
			}
			dispatchEvent(new YouTubeEvent(YouTubeEvent.SEARCH_COMPLETE));
		}
	}
}