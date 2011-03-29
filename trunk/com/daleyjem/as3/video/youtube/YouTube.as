package com.daleyjem.as3.video.youtube
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	
	[Event(name = "searchComplete", type = "com.daleyjem.as3.video.youtube.YouTubeEvent")]
	[Event(name = "getFLVComplete", type = "com.daleyjem.as3.video.youtube.YouTubeEvent")]
	[Event(name = "error", type = "flash.events.ErrorEvent")]
	public class YouTube extends EventDispatcher
	{
		private var atomNS:Namespace	= new Namespace("http://www.w3.org/2005/Atom");
		private var ytNS:Namespace		= new Namespace("http://gdata.youtube.com/schemas/2007");
		private var appNS:Namespace		= new Namespace("http://purl.org/atom/app#");
		
		/**
		 * Contains a list of <YouTubeSearchResult>
		 */
		public var searchResults:Array = new Array();
		public var flvURL:String = "";
		
		private var _suppressNonEmbeddable:Boolean = false;
		
		private static const URL_SEARCH_PREPEND:String	= "http://gdata.youtube.com/feeds/api/videos?";
		private static const URL_PAGE_PREPEND:String	= "http://www.youtube.com/watch?";
		private static const URL_GET_PREPEND:String		= "http://www.youtube.com/get_video?";
		
		/**
		 * Instantiates a YouTube object for calling methods that
		 * pull data from the YouTube data API
		 */
		public function YouTube():void {}
		
		/**
		 * Makes an asynchronous call to the YouTube data API for results matching your search query.
		 * @param	query					<String> Search terms for YouTube videos
		 * @param	maxResults				<uint> Number of max results to retrieve from YouTube data API
		 * @param	suppressNonEmbeddable	<Boolean> Hide video results with <yt:noembed> or "limitedSyndication"
		 */
		public function search(query:String, maxResults:uint = 10, suppressNonEmbeddable:Boolean = false):void
		{
			_suppressNonEmbeddable = suppressNonEmbeddable;
			query = query.split(" ").join("+");
			var requestURL:String = URL_SEARCH_PREPEND + "q=" + query + "&max-results=" + maxResults;
			var searchLoader:URLLoader = new URLLoader();
			searchLoader.addEventListener(Event.COMPLETE, onSearchLoaderComplete);
			searchLoader.load(new URLRequest(requestURL));
		}
		
		private function onSearchLoaderComplete(e:Event):void 
		{
			var searchLoader:URLLoader = e.target as URLLoader;
			var resultXML:XML = new XML(searchLoader.data);
			for each (var entryNode:XML in resultXML..atomNS::entry)
			{
				if (entryNode..ytNS::noembed.length() > 0 && _suppressNonEmbeddable) continue;
				if (entryNode..appNS::control.ytNS::state.@reasonCode == "limitedSyndication" && _suppressNonEmbeddable) continue;
				searchResults.push(new YouTubeSearchResult(entryNode));
			}
			dispatchEvent(new YouTubeEvent(YouTubeEvent.SEARCH_COMPLETE));
		}
	}
}