package com.daleyjem.as3
{
	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.system.ApplicationDomain;
	
	public class ExternalSWF extends Sprite
	{
		public var content:Object;
		public var props:Object = new Object();
		public var isLoaded:Boolean = false;
		
		private var loader:Loader;
		private var _origWidth:Number = 0;
		private var _origHeight:Number = 0;
		private var canvasMask:Sprite;
		private var _maskBounds:Boolean;
		private var domain:ApplicationDomain;
		
		public function ExternalSWF(swfPath:String, maskBounds:Boolean = true):void
		{
			_maskBounds = maskBounds;
			
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onSWFLoaded);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);
			loader.load(new URLRequest(swfPath));
		}
		
		/**
		 * Gets the <Class> reference to an object in the SWF's library.
		 * @param	className	<String> The definition name as it exists in the SWF's library.
		 * @return	<Class>
		 */
		public function getClassByName(className:String):Class
		{
			return domain.getDefinition(className) as Class;
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
		
		private function onIOError(e:IOErrorEvent):void 
		{
			dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
		}
		
		private function onLoadProgress(e:ProgressEvent):void 
		{
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, e.bytesLoaded, e.bytesTotal));
		}
		
		private function onSWFLoaded(e:Event):void 
		{
			//trace("ExternalSWF: SWF Loaded");
			var info:LoaderInfo = e.target as LoaderInfo;
			_origWidth = info.width;
			_origHeight = info.height;
			domain = info.applicationDomain;
			
			var loader:Loader = info.loader;
			content = loader.content as Object;
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
			
			isLoaded = true;
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}