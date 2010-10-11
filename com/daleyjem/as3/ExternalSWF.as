package com.daleyjem.as3
{
	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.display.Loader;
	
	public class ExternalSWF extends Sprite
	{
		public var content:DisplayObject;
		
		private var loader:Loader;
		private var _origWidth:Number = 0;
		private var _origHeight:Number = 0;
		private var canvasMask:Sprite;
		private var _maskBounds:Boolean;
		
		public function ExternalSWF(swfPath:String, maskBounds:Boolean = true):void
		{
			_maskBounds = maskBounds;
			
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onSWFLoaded);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);
			loader.load(new URLRequest(swfPath));
		}
		
		/**
		 * (Read-only) Original canvas width of SWF
		 */
		public function get origWidth():Number
		{
			return _origWidth;
		}
		
		/**
		 * (Read-only) Original canvas height of SWF
		 */
		public function get origHeight():Number
		{
			return _origHeight;
		}
		
		private function onLoadProgress(e:ProgressEvent):void 
		{
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, e.bytesLoaded, e.bytesTotal));
		}
		
		private function onSWFLoaded(e:Event):void 
		{
			var info:LoaderInfo = e.target as LoaderInfo;
			_origWidth = info.width;
			_origHeight = info.height;

			var loader:Loader = info.loader;
			content = loader.content;
			addChild(loader);
			
			if (_maskBounds)
			{
				canvasMask = new Sprite();
				canvasMask.graphics.beginFill(0);
				canvasMask.graphics.drawRect(0, 0, origWidth, origHeight);
				canvasMask.graphics.endFill();
				addChild(canvasMask);
				loader.mask = canvasMask;
			}
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}