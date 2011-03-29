package com.daleyjem.as3.video.youtube
{
	public class YouTubeSearchResult
	{
		private var atomNS:Namespace = new Namespace("http://www.w3.org/2005/Atom");
		private var mediaNS:Namespace = new Namespace("http://search.yahoo.com/mrss/");
		
		public var title:String;
		public var id:String;
		public var description:String;
		public var author:String;
		public var thumbnails:Array = new Array();
		
		public function YouTubeSearchResult(entryNode:XML):void
		{
			id = entryNode.atomNS::id[0];
			id = id.substr(id.lastIndexOf("/") + 1);
			title = entryNode.atomNS::title[0];
			author = entryNode.atomNS::author.atomNS::name[0];
			description = entryNode..mediaNS::description[0];
			for each (var thumbnailNode:XML in entryNode..mediaNS::thumbnail)
			{
				thumbnails.push(thumbnailNode.@url);
			}
		}
	}	
}