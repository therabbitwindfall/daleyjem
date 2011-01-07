package com.daleyjem.as3
{
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.events.ContextMenuEvent;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.net.FileReference;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.ErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.EventDispatcher;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.system.LoaderContext;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	[Event(name = "init", type = "flash.events.Event")]
	[Event(name = "complete", type = "flash.events.Event")]
	[Event(name = "progress", type = "flash.events.ProgressEvent")]
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	public class ExternalImage extends Sprite
	{		
		public var image:Bitmap;
		private var imageLoader:Loader = new Loader();
		private var hasSmoothing:Boolean = false;
		private var percLoaded:Number = 0;
		private var imgPath:String;
		private var bLoaded:Number = 0;
		private var bTotal:Number = 0;
		private var clickContextMenu:ContextMenu;
		private var fileReference:FileReference;
		private var hasBorder:Boolean = false;
		private var borderThickness:Number;
		private var borderColor:Number;
		private var hasDrawnBorder:Boolean = false;
		private var isInit:Boolean = false;
		
		public var url:String = "";
		public var props:Object = new Object();
		
		/**
		 * Loads an image into a Sprite from the url specified and applies smoothing.
		 * Provides right-click menu options for emulating a browser's native image behaviors.
		 * 
		 * @param	imagePath			<String> Uri of the image.
		 * @param	addSmoothing		<Boolean> Apply smoothing to the image.
		 * @param	addRightClickMenu	<Boolean> Adds a menu with "Save As" and "View Image" options to emulate browser image behaviors.
		 */
		public function ExternalImage(imagePath:String, addSmoothing:Boolean = false, addRightClickMenu:Boolean = false, loaderContext:LoaderContext = null):void
		{
			url = imagePath;
			clickContextMenu = new ContextMenu();
			imgPath = imagePath;
			hasSmoothing = addSmoothing;
			imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, doLoadFail);
			imageLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
			if (loaderContext == null) loaderContext = new LoaderContext();
			imageLoader.load(new URLRequest(imagePath), loaderContext);
			
			if (addRightClickMenu)
			{
				var viewImageItem:ContextMenuItem = new ContextMenuItem("View Image");
				var saveImageAsItem:ContextMenuItem = new ContextMenuItem("Save Image As...");
				viewImageItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, viewImage);
				saveImageAsItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, saveImageAs);
				clickContextMenu.hideBuiltInItems();
				clickContextMenu.customItems.push(viewImageItem);
				clickContextMenu.customItems.push(saveImageAsItem);
				contextMenu = clickContextMenu;
			}
		}
		
		/**
		 * Gets or sets whether the image has smoothing on it.
		 */
		public function get smoothing():Boolean
		{
			return hasSmoothing;
		}
		
		public function set smoothing(_smoothing:Boolean):void
		{
			hasSmoothing = _smoothing;
			image.smoothing = _smoothing;
		}
		
		/**
		 * Read only. Returns how many bytes of the image has loaded.
		 */
		public function get bytesLoaded():Number
		{
			return bLoaded;
		}
		
		/**
		 * Read only. Returns the total number of bytes for the image.
		 */
		public function get bytesTotal():Number
		{
			return bTotal;
		}
		
		/**
		 * Adds or removes smoothing to the image.
		 */
		public function toggleSmoothing():void
		{
			smoothing = smoothing ? false : true;
		}
		
		/**
		 * Adds a border around the image
		 * @param	thickness	<Number> Pixel thickness of image border.
		 * @param	color		<Number> Hex color of border color.
		 */
		public function addBorder(thickness:Number, color:Number):void
		{
			borderThickness = thickness;
			borderColor = color;
			hasBorder = true;
			if (image != null && hasDrawnBorder == false) drawBorder();
		}
		
		private function viewImage(e:ContextMenuEvent):void
		{
			navigateToURL(new URLRequest(imgPath), "_blank");
		}
		
		private function saveImageAs(e:ContextMenuEvent):void
		{
			fileReference = new FileReference();
			fileReference.download(new URLRequest(getQualifiedPath(imgPath)));		
		}
		
		private function getQualifiedPath(origPath:String):String
		{
			if (origPath.indexOf("http://") > -1 || origPath.indexOf("https://") > -1) return origPath;
			if (origPath.indexOf("../") > -1) origPath = origPath.replace("../", "");
			var qualifiedPath:String = "";
			var protocol:String = ExternalInterface.call("window.location.protocol.toString");
			
			if (protocol == "http:" || protocol == "https:")
			{
				var domain:String = ExternalInterface.call("window.location.host.toString");
				var path:String = ExternalInterface.call("window.location.pathname.toString");
				if (path.indexOf("/") > -1) path = path.replace(path.split("/")[1], "");
				protocol += "//";
				origPath = formatRelativePath(qualifiedPath, origPath);
				qualifiedPath += protocol + domain + path + origPath;
			}
			
			return qualifiedPath;
		}
		
		private function formatRelativePath(shortPath:String, relativePath:String):String
		{
			var backDirSplit:Array = relativePath.split("../");
			var backDirCount:Number = backDirSplit.length - 1;
			
			var endAppend:String = backDirSplit[backDirCount];
			var shortSplit:Array = shortPath.split("/");
			shortSplit.splice(shortSplit.length - 1, 1);
			
			for (var i:Number = 0; i < backDirCount; i++)
			{
				shortSplit.splice(shortSplit.length - 1, 1);
			}
			
			return shortSplit.join("/") + endAppend;
		}
		
		private function dispose():void
		{
			imageLoader.removeEventListener(Event.COMPLETE, onComplete);
			imageLoader.removeEventListener(IOErrorEvent.IO_ERROR, doLoadFail);
			imageLoader.removeEventListener(ProgressEvent.PROGRESS, onProgress);
		}
		
		private function onProgress(e:ProgressEvent):void
		{
			bTotal = e.bytesTotal;
			bLoaded = e.bytesLoaded;
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS));
			if (!isInit)
			{
				isInit = true;
				dispatchEvent(new Event(Event.INIT));
			}
		}
		
		private function onComplete(e:Event):void
		{
			dispose();
			var imageBMData:BitmapData = (imageLoader.content as Bitmap).bitmapData;
			image = addChild(new Bitmap(imageBMData, "auto", true)) as Bitmap;
			image.smoothing = hasSmoothing;
			if (hasBorder && hasDrawnBorder == false) drawBorder();
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function doLoadFail(e:IOErrorEvent):void
		{
			dispose();
			dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
			trace("Cannot load image at path: \"" + imgPath + "\"");
		}
		
		private function drawBorder():void
		{
			var border:Sprite = new Sprite();
			border.graphics.lineStyle(borderThickness, borderColor);
			border.graphics.beginFill(0, 0);
			border.graphics.drawRect(0, 0, image.width, image.height);
			border.graphics.endFill();
			addChild(border);
			hasDrawnBorder = true;
		}
	}
}