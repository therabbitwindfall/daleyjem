package com.daleyjem.as3.air.ui
{
	import flash.events.Event;
	
	/**
	 * @author Jeremy Daley
	 */
	public class DownloadManagerEvent extends Event
	{
		public static const ITEM_COMPLETE:String	= "itemComplete";
		
		public var item:DownloadManagerItem;
		
		public function DownloadManagerEvent(_item:DownloadManagerItem, type:String, bubbles:Boolean=false, cancelable:Boolean=false):void
		{
			item = _item;
			super(type, bubbles, cancelable);
		}
	}
	
}