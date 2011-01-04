package com.daleyjem.as3.video
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.events.OutputProgressEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Jeremy Daley
	 */
	public class VideoRecorder extends EventDispatcher
	{
		public var isRecording:Boolean = false;
		
		private var timer:Timer;
		private var startTime:Number;
		private var outputStream:FileStream;
		private var outputFile:File;
		private var bitmapData:BitmapData
		private var sourceObject:DisplayObject;
		private var rect:Rectangle;
		private var numFramesWriting:int = 0;
		private var numFramesWritten:int = 0;
		
		public function VideoRecorder(displayObject:DisplayObject, rawOutputFile:File, fps:int = 15, captureSound:Boolean = false):void
		{
			sourceObject = displayObject;
			outputFile = rawOutputFile;
			bitmapData = new BitmapData(displayObject.width, displayObject.height, false);
			rect = new Rectangle(0, 0, displayObject.width, displayObject.height);
			
			timer = new Timer(1 / fps);
			timer.addEventListener(TimerEvent.TIMER, onTimerTick);
		}
		
		public function record():void
		{
			startTime = getTimer();
			beginWriteData();
		}
		
		public function stop():void
		{
			timer.stop();
			outputStream.close();
		}
		
		private function beginWriteData():void
		{			
			outputStream = new FileStream();
			outputStream.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS, onChunkWritten);
			outputStream.openAsync(outputFile, FileMode.APPEND);
			
			timer.start();
			
			updateWriteData();
		}
		
		private function updateWriteData():void
		{
			numFramesWriting++;
			bitmapData.draw(sourceObject);
			var writeObject:Object = new Object();
			writeObject.position = getTimer() - startTime;
			var byteArray:ByteArray = bitmapData.getPixels(rect);
			byteArray.deflate();
			writeObject.bytes = byteArray;
			outputStream.writeObject(writeObject);
		}
		
		private function onChunkWritten(e:OutputProgressEvent):void 
		{
			numFramesWritten++;
		}
		
		private function onTimerTick(e:TimerEvent):void 
		{
			updateWriteData();
		}
	}
	
}