package com.daleyjem.as3.air.ui
{
	import com.daleyjem.as3.utils.DisplayTools;
	import com.daleyjem.as3.utils.IO;
	import com.daleyjem.as3.utils.Time;
	import fl.containers.ScrollPane;
	import flash.display.MovieClip;
	import com.daleyjem.as3.air.ui.DownloadManagerItem;
	import com.daleyjem.as3.air.net.InternetFile;
	import com.daleyjem.as3.air.net.InternetFileEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.text.TextField;
	import flash.filters.DropShadowFilter;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	public class DownloadManager extends MovieClip
	{
		public var items:Array = new Array();
		public var isReady:Boolean = false;
		
		private var itemContainer:MovieClip;
		private var currY:Number = 0;
		private var overlay:Sprite;
		private var dropShadow:DropShadowFilter;
		private var _stageWidth:uint;
		private var _stageHeight:uint;
		private var currIndex:uint = 0;
		private var dlStartTime:int = 0;
		private var dlByteProgress:uint = 0;
		private var dlByteAccum:uint = 0;
		
		private var preFetch:Boolean;
		private var authUser:String;
		private var authPassword:String;
		private var authType:String;
		
		public var status_txt:TextField;
		public var net_txt:TextField;
		public var scrollPane_mc:ScrollPane;
		public var title_txt:TextField;
		
		public function DownloadManager(stageWidth:uint = 0, stageHeight:uint = 0):void
		{
			status_txt = getChildByName("status_txt") as TextField;
			net_txt = getChildByName("net_txt") as TextField;
			scrollPane_mc = getChildByName("scrollPane_mc") as ScrollPane;
			
			_stageWidth = stageWidth;
			_stageHeight = stageHeight;
			
			visible = false;
			dropShadow = new DropShadowFilter(2, 45, 0, .2, 2, 2);
			filters = [dropShadow];
			
			//cancel_mc.label = "Cancel";
			itemContainer = new MovieClip();
			
			scrollPane_mc.source = itemContainer;
			//cancel_mc.addEventListener(MouseEvent.CLICK, onCancelClick);
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function addItem(item:DownloadManagerItem):void
		{
			item.index = items.length;
			item.addEventListener(InternetFileEvent.FILE_WRITE_COMPLETE, onItemWriteComplete);
			item.addEventListener(ProgressEvent.PROGRESS, onDLItemProgress);
			item.y = currY;
			itemContainer.addChild(item);
			scrollPane_mc.update();
			currY += item.height;
			items.push(item);
		}
		
		public function start(_preFetch:Boolean = true, _authUser:String = null, _authPassword:String = null, _authType:String = "Basic"):void
		{
			preFetch		= _preFetch;
			authUser		= _authUser;
			authPassword	= _authPassword;
			authType 		= _authType;
			
			currIndex = 0;
			
			if (preFetch)
			{
				pollFilesizes();
			}
			else
			{
				isReady = true;
				onItemWriteComplete();
			}
		}
		
		private function pollFilesizes():void
		{
			status_txt.text = "Getting total filesize...";
			var internetFile:InternetFile = (items[currIndex] as DownloadManagerItem).internetFile;
			internetFile.addEventListener(InternetFileEvent.HEADER_POLL_COMPLETE, onDLHeaderPollComplete);
			internetFile.getFilesize();
		}
		
		private function onDLHeaderPollComplete(e:InternetFileEvent):void 
		{
			dlByteAccum += (e.target as InternetFile).headerBytes;
			currIndex++;
			if (currIndex == items.length)
			{
				currIndex = 0;
				dlStartTime = getTimer();
				isReady = true;
				onItemWriteComplete();
			}
			else
			{
				pollFilesizes();
			}
		}
		
		private function removeItem(item:DownloadManagerItem):void
		{
			var tempHeight:Number = item.height;
			itemContainer.removeChild(item);
			var itemCount:uint = items.length;
			for (var i:uint = item.index + 1; i < itemCount; i++)
			{
				var tempItem:DownloadManagerItem = items[i];
				tempItem.y -= tempHeight;
			}
			scrollPane_mc.update();
		}
		
		private function onDLItemProgress(e:ProgressEvent):void 
		{
			if (!preFetch) return;
			var incBytes:uint = dlByteProgress + e.bytesLoaded;
			var newTime:int = getTimer();
			var millPass:int = newTime - dlStartTime;
			var incBits:Number = incBytes * 0.000007629;
			var incSec:Number = millPass / 1000;
			var estMill:Number = ((dlByteAccum - incBytes) * millPass) / incBytes;
			//net_txt.text = ;
			net_txt.htmlText =  IO.getFilesizeFormat(incBytes) + "/" + IO.getFilesizeFormat(dlByteAccum) + " @" +
								Math.round(incBits / incSec).toString() + "Mbps" +
								"<br> Estimated Time: " + 
								Time.convertSecondsToTimeStamp(estMill / 1000);
			//net_txt.text = IO.getFilesizeFormat(incBytes) + " / " + IO.getFilesizeFormat(dlByteAccum);
		}
		
		private function onItemWriteComplete(e:InternetFileEvent = null):void 
		{
			status_txt.text = (currIndex + 1) + " of " + items.length + " complete";
			if (e != null)
			{
				var item:DownloadManagerItem = (e.target as DownloadManagerItem);
				dlByteProgress += item.internetFile.bytesTotal;
				item.removeEventListener(InternetFileEvent.FILE_WRITE_COMPLETE, onItemWriteComplete);
				dispatchEvent(new DownloadManagerEvent(item, DownloadManagerEvent.ITEM_COMPLETE));
				removeItem(item);
			}
			
			if (currIndex < items.length)
			{
				var tempItem:DownloadManagerItem = items[currIndex];
				if (authUser != null)
				{
					tempItem.internetFile.download(tempItem.local, authUser, authPassword, authType);
				}
				else
				{
					tempItem.internetFile.download(tempItem.local);
				}
			}
			else
			{
				dispatchEvent(new Event(Event.COMPLETE));
				dispose();
			}
			
			currIndex++;
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			overlay = new Sprite();
			overlay.graphics.beginFill(0, .5);
			overlay.graphics.drawRect(0, 0, _stageWidth, _stageHeight);
			overlay.graphics.endFill();
			
			stage.addChildAt(overlay, stage.numChildren - 1);
			stage.setChildIndex(this, stage.numChildren - 1);
			
			DisplayTools.centerWithin(this, _stageWidth, _stageHeight);
			
			visible = true;
		}
		
		private function onCancelClick(e:MouseEvent):void 
		{
			
		}
		
		private function dispose():void
		{
			stage.removeChild(overlay);
			parent.removeChild(this);
			dispatchEvent(new Event(Event.CLOSE));
		}
	}
}