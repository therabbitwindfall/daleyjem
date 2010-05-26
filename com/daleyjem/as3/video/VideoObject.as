package com.daleyjem.as3.video
{
	import com.daleyjem.as3.SoundTween;
	import com.daleyjem.as3.net.NCTest;
	import com.daleyjem.as3.net.Uri;
	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	import flash.external.ExternalInterface;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.NetStream;
	import flash.net.NetConnection;
	import flash.media.Video;
	import com.daleyjem.as3.video.VideoObjectStatus;
	import com.daleyjem.as3.video.VideoObjectEvent;
	
	[Event(name = "playProgress", type = "com.daleyjem.as3.video.VideoObjectEvent")]
    [Event(name = "playStatePlaying", type = "com.daleyjem.as3.video.VideoObjectEvent")]
	[Event(name = "playStatePaused", type = "com.daleyjem.as3.video.VideoObjectEvent")]
	[Event(name = "playStateComplete", type = "com.daleyjem.as3.video.VideoObjectEvent")]
	[Event(name = "videoReady", type = "com.daleyjem.as3.video.VideoObjectEvent")]
	[Event(name = "invalidConnection", type = "com.daleyjem.as3.video.VideoObjectEvent")]
	[Event(name = "bufferStart", type = "com.daleyjem.as3.video.VideoObjectEvent")]
	[Event(name = "bufferComplete", type = "com.daleyjem.as3.video.VideoObjectEvent")]
	public class VideoObject extends Sprite
	{
		/**
		 * The total number of seconds available in the buffer
		 */
		public var bufferLength:Number = 0;
		/**
		 * The total duration of the video.
		 */
		public var duration:Number = 0;
		/**
		 * The current playhead time of the video.
		 */
		public var time:Number = 0;
		/**
		 * The current playback status of the video.
		 */
		public var status:String;
		/**
		 * The path of the currently loaded FLV.
		 */
		public var url:String;
		/**
		 * The original width of the video.
		 */
		public var nativeWidth:uint = 0;
		/**
		 * The original height of the video.
		 */
		public var nativeHeight:uint = 0;
		/**
		 * For setting custom properties on this object.
		 */
		public var props:Object = new Object();
		/**
		 * All meta data
		 */
		public var rawMetaData:Object; 
		 
		private var netConnection:NetConnection;
		private var ncTest:NCTest;
		private var netStream:NetStream;
		private var netClient:Object;
		private var video:Video;
		private var _vWidth:int;
		private var _vHeight:int;
		private var _autoPlay:Boolean = false;
		private var _volume:Number = 1;
		private var _bufferTime:Number = 1;
		private var connectionString:String = null;
		private var extensionArray:Array = new Array(
			{extension: "flv", protocol: "", keepExtension: false},
			{extension: "f4v", protocol: "mp4:", keepExtension: true},
			{extension: "mp4", protocol: "mp4:", keepExtension: true}
		);
		
		/**
		 * Creates a container for displaying and controlling playback of video.
		 * @param	vWidth	<int> The desired width of the video.
		 * @param	vHeight	<int> The desired height of the video.
		 */
		public function VideoObject(vWidth:int, vHeight:int):void
		{
			_vWidth = vWidth;
			_vHeight = vHeight;
			
			video = new Video(_vWidth, _vHeight);
			video.width = vWidth;
			video.height = vHeight;
		}
		
		/**
		 * Gets or sets the amount of time to buffer the video before playback.
		 */
		public function get bufferTime():Number
		{
			return _bufferTime;
		}
		public function set bufferTime(value:Number):void
		{
			_bufferTime = value;
			if (netStream != null) netStream.bufferTime = _bufferTime;
		}
		 
		/**
		 * Gets or sets the volume of the video.
		 */
		public function get volume():Number
		{
			return _volume;
		}
		public function set volume(value:Number):void
		{
			_volume = value;
			if (netStream != null) netStream.soundTransform = new SoundTransform(value);
		}
		
		/**
		 * Fades volume to given value over given amount of time.
		 * @param	newVolume		<Number> Volume to fade to.
		 * @param	fadeDuration	<Number> Duration of volume fade.
		 */
		public function fadeVolumeTo(newVolume:Number, fadeDuration:Number = 1):void
		{
			var soundTween:SoundTween = new SoundTween(netStream.soundTransform, "volume", netStream.soundTransform.volume, newVolume, fadeDuration);
			soundTween.addEventListener(ProgressEvent.PROGRESS, onSoundTweenProgress);
		}
		
		private function onSoundTweenProgress(e:ProgressEvent):void 
		{
			var soundTween:SoundTween = e.target as SoundTween;
			volume = soundTween.value;
		}
		
		/**
		 * Gets or sets whether the video should smooth jagged edges due to scaling.
		 */
		public function get smoothing():Boolean
		{
			return video.smoothing;
		}
		public function set smoothing(value:Boolean):void
		{
			video.smoothing = value;
		}
		
		/**
		 * Loads the specified path into the VideoObject container
		 * @param	flvPath		<String> The relative or absolute path of the video.
		 * @param	autoPlay	<Boolean> Sets whether or not the video should play automatically once loaded.
		 */
		public function load(flvPath:String, autoPlay:Boolean = false):void
		{
			if (netConnection != null) netConnection.close();
			var tempUri:Uri = new Uri(flvPath);
			url = flvPath;
			status = VideoObjectStatus.STOPPED;
			_autoPlay = autoPlay;
			
			if (tempUri.isRTMP)
			{
				ncTest = new NCTest(tempUri);
				ncTest.addEventListener(ErrorEvent.ERROR, onConnectionFail);
				ncTest.addEventListener(Event.CONNECT, onConnectionSuccess);
			}
			else
			{
				prepareFLVPath(url);
			}
		}
		
		/**
		 * Closes out VideoObject
		 */
		public function close():void
		{
			if (video != null) video.clear();
			if (netStream != null) netStream.close();
			if (netConnection != null) netConnection.close();
			status = VideoObjectStatus.STOPPED;
			dispatchEvent(new VideoObjectEvent(VideoObjectEvent.PLAY_STATE_STOPPED));
		}
		
		/**
		 * Pauses the currently playing video.
		 */
		public function pause():void
		{
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			netStream.pause();
			status = VideoObjectStatus.PAUSED;
			dispatchEvent(new VideoObjectEvent(VideoObjectEvent.PLAY_STATE_PAUSED));
		}
		
		/**
		 * Plays the currently loaded video.
		 */
		public function play():void
		{
			switch (status)
			{
				case VideoObjectStatus.PAUSED:
					resume();
					break;
				case VideoObjectStatus.STOPPED:
					_autoPlay = true;
					prepareFLVPath(url);
					break;
			}
		}
		
		/**
		 * Seeks to the specified percentage of the video's total duration.
		 * @param	value	<Number> A value between 0-1 to seek to.
		 */
		public function seekPercent(value:Number):void
		{
			netStream.seek(duration * value);
		}
		
		private function onConnectionSuccess(e:Event):void
		{
			var tempNCTest:NCTest = e.target as NCTest;
			
			netConnection = ncTest.validNetConnection;
			netConnection.client = this;

			//netConnection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
			netConnection.addEventListener(NetStatusEvent.NET_STATUS, onConnectionNetStatus);
			
			netClient = new Object();
			netClient.onMetaData = onMetaData;
			
			prepareFLVPath(url);
		}
		
		private function onConnectionFail(e:ErrorEvent):void
		{
			dispatchEvent(new VideoObjectEvent(VideoObjectEvent.INVALID_CONNECTION));
			ncTest.retest();
		}
		
		private function resume():void
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			netStream.resume();
			status = VideoObjectStatus.PLAYING;
			dispatchEvent(new VideoObjectEvent(VideoObjectEvent.PLAY_STATE_PLAYING));
		}
		
		private function prepareFLVPath(inputPath:String):void
		{
			url = inputPath;

			if (url.toLowerCase().substr(0, 3) == "rtm")
			{
				var lastIndex:Number = url.lastIndexOf("/");
				connectionString = ncTest.validUri; // url.substr(0, lastIndex);
				var splitArray:Array = url.split("/");
				url = getFMSPath(splitArray[splitArray.length - 1]);
			}
			else
			{
				connectionString = null;
			}

			if (connectionString == null)
			{
				netConnection = new NetConnection();
				netConnection.connect(null);
				netClient = new Object();
				netClient.onMetaData = onMetaData;
			}
			
			setNetStream();
		}
		
		private function setNetStream():void
		{
			if (netStream != null) netStream.close();
			netStream = new NetStream(netConnection);
			netStream.bufferTime = bufferTime;
			netStream.addEventListener(NetStatusEvent.NET_STATUS, onStreamNetStatus);
			netStream.client = netClient;
			
			if (_autoPlay) playFLV(url);
			video.attachNetStream(netStream);

			if (!hasEventListener(Event.ENTER_FRAME)) addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			addChild(video);
		}
		
		private function playFLV(flvPath:String):void
		{
			netStream.play(flvPath);
			volume = volume;
			status = VideoObjectStatus.PLAYING;
			dispatchEvent(new VideoObjectEvent(VideoObjectEvent.PLAY_STATE_PLAYING));
		}
		
		private function getFMSPath(inputPath:String):String
		{
			var extensionIndex:Number = inputPath.lastIndexOf(".");
			var extension:String = inputPath.substr(extensionIndex);
			var extensionCount:Number = extensionArray.length;
			for (var i:Number = 0; i < extensionCount; i++)
			{
				if (extensionArray[i].extension == extension.split(".").join(""))
				{
					if (extensionArray[i].keepExtension)
					{
						return extensionArray[i].protocol + inputPath;
					}
					else
					{
						return extensionArray[i].protocol + inputPath.split(extension).join("");
					}
				}
			}
			return "";
		}
		
		private function onEnterFrame(e:Event):void 
		{
			//trace(netStream.bufferLength);
			time = netStream.time;
			bufferLength = netStream.bufferLength;
			dispatchEvent(new VideoObjectEvent(VideoObjectEvent.PLAY_PROGRESS));
		}
		
		private function onConnectionNetStatus(e:NetStatusEvent):void 
		{
			//trace(url, "=", e.info.code);
			switch (e.info.code)
			{
				case "NetConnection.Connect.Success":
					setNetStream();
					break;
			}
		}
		
		private function onStreamNetStatus(e:NetStatusEvent):void 
		{
			//trace(url, "=", e.info.code);
			//trace(netStream.bufferLength, netStream.bufferTime);
			switch (e.info.code)
			{
				case "NetStream.Play.Stop":
					removeEventListener(Event.ENTER_FRAME, onEnterFrame);
					time = 0;
					status = VideoObjectStatus.STOPPED;
					dispatchEvent(new VideoObjectEvent(VideoObjectEvent.PLAY_STATE_COMPLETE));
					break;
				case "NetStream.Play.Reset":
					//dispatchEvent(new VideoObjectEvent(VideoObjectEvent.VIDEO_READY));
					break;
				case "NetStream.Play.Start":
					dispatchEvent(new VideoObjectEvent(VideoObjectEvent.VIDEO_READY));
					break;
				case "NetStream.Buffer.Empty":
					dispatchEvent(new VideoObjectEvent(VideoObjectEvent.BUFFER_START));
					break;
				case "NetStream.Buffer.Full":
					if (!hasEventListener(Event.ENTER_FRAME)) addEventListener(Event.ENTER_FRAME, onEnterFrame);
					dispatchEvent(new VideoObjectEvent(VideoObjectEvent.BUFFER_COMPLETE));
					break;
			}
		}
		
		private function onMetaData(infoObject:Object):void
		{
			rawMetaData = new Object();
			for (var tester:Object in infoObject)
			{
				rawMetaData[tester] = infoObject[tester];
				//trace(tester + " = " + infoObject[tester]);
			}
			duration = infoObject.duration;
			nativeWidth = infoObject.width;
			nativeHeight = infoObject.height;
			dispatchEvent(new VideoObjectEvent(VideoObjectEvent.META_DATA_READY));
		}
		
		public function onBWDone():void	{}
		
		private function onAsyncError(e:AsyncErrorEvent):void {}
	}
}