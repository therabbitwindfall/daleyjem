package com.daleyjem.as3
{
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.geom.Rectangle;
	
	public class MP3Player extends EventDispatcher
	{
		/* Control vars */
		private var _playButton:Sprite;
		private var _pauseButton:Sprite;
		private var _seekBar:Sprite;
		private var _seekHandle:Sprite;
		private var _seekFill:Sprite;
		private var _currentTimeTextField:TextField;
		private var _totalTimeTextField:TextField;
		private var _volumeBar:Sprite;
		private var _volumeHandle:Sprite;

		private var soundChannel:SoundChannel;
		
		private var isDownloaded:Boolean = false;
		private var isAdjustingProgress:Boolean = false;
		private var isAdjustingVolume:Boolean = false;
		private var isPlaying:Boolean = false;
		
		private var currVolume:Number = 0;
		private var currTime:Number = 0;
		private var _totalTime:Number;
		
		public var sound:Sound;
		
		public function MP3Player():void;
		
		public function load(mp3Source:String, autoPlay:Boolean = true, startVolume:Number = 1, totalSeconds:Number = 0):void
		{
			if (_currentTimeTextField != null) _currentTimeTextField.text = "00:00";
			if (_totalTimeTextField != null) _totalTimeTextField.text = "--:--";
			_seekHandle.visible = false;
			
			if (totalSeconds > 0)
			{
				_totalTime = totalSeconds * 1000;
				isDownloaded = true;
			}
			_playButton.visible = true;
			_pauseButton.visible = false;
			
			currVolume = startVolume;
			_volumeHandle.x = _volumeBar.x + (currVolume * _volumeBar.width) - (_volumeHandle.width * .5);
			
			sound = new Sound();
			sound.addEventListener(Event.COMPLETE, mp3Downloaded);
			sound.addEventListener(ProgressEvent.PROGRESS, mp3Progress);
			sound.load(new URLRequest(mp3Source));
			
			if (autoPlay) plauseAudio();
		}
		
		public function get playButton():Sprite
		{
			return _playButton;
		}
		public function set playButton(__playButton:Sprite):void
		{
			_playButton = __playButton;
			_playButton.buttonMode = true;
			_playButton.addEventListener(MouseEvent.CLICK, plauseAudio);
			_playButton.stage.addEventListener(MouseEvent.MOUSE_MOVE, HandleDrag)
			_playButton.stage.addEventListener(MouseEvent.MOUSE_UP, HandleStopDrag);
		}
		
		public function get pauseButton():Sprite
		{
			return _pauseButton;
		}
		public function set pauseButton(__pauseButton:Sprite):void
		{
			_pauseButton = __pauseButton;
			_pauseButton.buttonMode = true;
			_pauseButton.addEventListener(MouseEvent.CLICK, plauseAudio);
		}
		
		public function get seekBar():Sprite
		{
			return _seekBar;
		}
		public function set seekBar(__seekBar:Sprite):void
		{
			_seekBar = __seekBar;
		}
		
		public function get seekFill():Sprite
		{
			return _seekFill;
		}
		public function set seekFill(__seekFill:Sprite):void
		{
			_seekFill = __seekFill;
		}
		
		public function get seekHandle():Sprite
		{
			return _seekHandle;
		}
		public function set seekHandle(__seekHandle:Sprite):void
		{
			_seekHandle = __seekHandle;
			_seekHandle.buttonMode = true;
			_seekHandle.addEventListener(MouseEvent.MOUSE_DOWN, HandleStartDrag);
		}
		
		public function get currentTimeTextField():TextField
		{
			return _currentTimeTextField;
		}
		public function set currentTimeTextField(__currentTimeTextField:TextField):void
		{
			_currentTimeTextField = __currentTimeTextField;
		}
		
		public function get totalTimeTextField():TextField
		{
			return _totalTimeTextField;
		}
		public function set totalTimeTextField(__totalTimeTextField:TextField):void
		{
			_totalTimeTextField = __totalTimeTextField;
		}
		
		public function get volumeBar():Sprite
		{
			return _volumeBar;
		}
		public function set volumeBar(__volumeBar:Sprite):void
		{
			_volumeBar = __volumeBar;
		}
		
		public function get volumeHandle():Sprite
		{
			return _volumeHandle;
		}
		public function set volumeHandle(__volumeHandle:Sprite):void
		{
			_volumeHandle = __volumeHandle;
			_volumeHandle.buttonMode = true;
			_volumeHandle.addEventListener(MouseEvent.MOUSE_DOWN, VolumeStartDrag);
		}
		
		private function plauseAudio(e:MouseEvent = null):void
		{
			if (isPlaying == true)
			{
				_pauseButton.visible = false;
				_playButton.visible = true;
				soundChannel.soundTransform = new SoundTransform(0);
				soundChannel.stop();
				isPlaying = false;
				_playButton.removeEventListener(Event.ENTER_FRAME, updatePlayhead);
			}
			else
			{
				_pauseButton.visible = true;
				_playButton.visible = false;
				isPlaying = true;
				soundChannel = new SoundChannel();
				soundChannel = sound.play(currTime, 0, new SoundTransform(currVolume));
				_playButton.addEventListener(Event.ENTER_FRAME, updatePlayhead);
			}
		}
		
		private function mp3Progress(e:ProgressEvent):void
		{
			if (_seekFill == null) return;
			//trace(e.bytesLoaded, e.bytesTotal);
			var perc:Number = e.bytesLoaded / e.bytesTotal;
			_seekFill.x = _seekBar.x;
			_seekFill.width = _seekBar.width * perc;
		}
		
		private function mp3Downloaded(e:Event):void
		{
			if (_seekFill != null) _seekFill.visible = false;
			_totalTime = sound.length;
			isDownloaded = true;
		}
		
		private function updatePlayhead(e:Event):void
		{
			if (isDownloaded && _seekHandle.visible == false) _seekHandle.visible = true;
			currTime = soundChannel.position;
			if (currentTimeTextField != null) currentTimeTextField.text = FormatTimeStamp(soundChannel.position / 1000);
			if (isDownloaded && _totalTimeTextField != null) _totalTimeTextField.text = FormatTimeStamp(_totalTime / 1000);
			var perc:Number = currTime / _totalTime;
			if (isAdjustingProgress == false && isDownloaded) _seekHandle.x = _seekBar.x + (_seekBar.width * perc) - (.5 * _seekHandle.width);
		}
		
		private function convertTimeStampToSeconds(timeStamp:String):Number
		{
			return (Number(timeStamp.split(":")[0]) * 60) + Number(timeStamp.split(":")[1]);
		}
		
		private function FormatTimeStamp(seconds:Number):String
		{
			var returnTime:String = "";
			seconds = Math.ceil(seconds);
			var min:Number = Math.floor(seconds / 60);
			if (min == 0) returnTime += "00";
			if (min.toString().length < 2 && returnTime == "") returnTime += "0" + min.toString();
			if (min > 9) returnTime += min.toString();
			returnTime += ":";
			var remSecs:Number = seconds - (60 * min);
			if (remSecs == 0) returnTime += "00";
			if (remSecs > 0 && remSecs <= 9) returnTime += "0" + remSecs.toString();
			if (remSecs > 9) returnTime += remSecs.toString();
			return returnTime;
		}
		
		private function HandleStartDrag(e:MouseEvent):void
		{
			isAdjustingProgress = true;
			_seekHandle.startDrag(false, new Rectangle(_seekBar.x - (_seekHandle.width * .5), _seekHandle.y, _seekBar.width, 0));
		}
		
		private function VolumeStartDrag(e:MouseEvent):void
		{
			isAdjustingVolume = true;
			_volumeHandle.startDrag(false, new Rectangle(_volumeBar.x - (_volumeHandle.width * .5), _volumeHandle.y, _volumeBar.width, 0));
		}
		
		private function HandleStopDrag(e:MouseEvent):void
		{
			if (isAdjustingProgress)
			{
				soundChannel.stop();
				isAdjustingProgress = false;
				_seekHandle.stopDrag();
				
				var seekPerc:Number = Math.floor(((_seekHandle.x + (.5 * _seekHandle.width)) - _seekBar.x)) / _seekBar.width;

				if (isPlaying == true)
				{
					var newSec:Number = seekPerc * _totalTime;
					soundChannel = new SoundChannel();
					soundChannel = sound.play(newSec, 0, new SoundTransform(currVolume));
				}
				else
				{
					currTime = seekPerc * _totalTime;
				}
				
				return;
			}
			
			if (isAdjustingVolume)
			{
				isAdjustingVolume = false;
				_volumeHandle.stopDrag();
				return;
			}
		}
		
		private function HandleDrag(e:MouseEvent):void
		{	
			if (isAdjustingVolume)
			{
				var perc:Number = Math.floor((_volumeHandle.x - _volumeBar.x) + (_volumeHandle.width * .5)) / _volumeBar.width;
				currVolume = perc;
				soundChannel.soundTransform = new SoundTransform(perc);
			}
		}
	}
}