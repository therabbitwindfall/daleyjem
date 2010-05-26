package com.daleyjem.as3.air.ui
{
	import com.daleyjem.as3.air.net.InternetFile;
	import com.daleyjem.as3.air.net.InternetFileEvent;
	import flash.display.MovieClip;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Jeremy Daley
	 */
	public class DownloadManagerItem extends MovieClip
	{
		public var local:String;
		
		public var internetFile:InternetFile;
		public var isComplete:Boolean = false;
		public var parameters:Object;
		public var index:uint;
		
		public var progress_mc:MovieClip;
		public var bg_mc:MovieClip;
		public var label_txt:TextField;
		
		public function DownloadManagerItem(_uri:String = "", _local:String = ""):void
		{
			progress_mc = getChildByName("progress_mc") as MovieClip;
			bg_mc = getChildByName("bg_mc") as MovieClip;
			label_txt = getChildByName("label_txt") as TextField;
			
			local = _local;
			parameters = new Object();
			progress_mc.width = 0;
			internetFile = new InternetFile(_uri);
			internetFile.addEventListener(ProgressEvent.PROGRESS, onDownloadProgress);
			internetFile.addEventListener(InternetFileEvent.FILE_DOWNLOAD_COMPLETE, onDownloadComplete);
			internetFile.addEventListener(InternetFileEvent.FILE_WRITE_COMPLETE, onWriteComplete)
			//internetFile.download(_local);
			var tempFile:File = new File(local);
			label_txt.htmlText = tempFile.name;
		}
		
		public function download():void
		{
			internetFile.download(local);
		}
		
		private function onWriteComplete(e:InternetFileEvent):void 
		{
			internetFile.removeEventListener(InternetFileEvent.FILE_WRITE_COMPLETE, onWriteComplete);
			label_txt.htmlText = "Complete";
			isComplete = true;
			dispatchEvent(new InternetFileEvent(internetFile, InternetFileEvent.FILE_WRITE_COMPLETE));
		}
		
		private function onDownloadComplete(e:InternetFileEvent):void 
		{
			internetFile.removeEventListener(ProgressEvent.PROGRESS, onDownloadProgress);
			internetFile.removeEventListener(InternetFileEvent.FILE_DOWNLOAD_COMPLETE, onDownloadComplete);
			dispatchEvent(new InternetFileEvent(internetFile, InternetFileEvent.FILE_DOWNLOAD_COMPLETE));
		}
		
		private function onDownloadProgress(e:ProgressEvent):void 
		{
			progress_mc.width = (e.bytesLoaded / e.bytesTotal) * bg_mc.width;
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, e.bytesLoaded, e.bytesTotal));
		}
	}
}