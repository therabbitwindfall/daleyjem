package com.daleyjem.as3
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	[Event(name = "soundComplete", type = "flash.events.Event")]
	[Event(name = "change", type = "flash.events.Event")]
	public class SoundPlayer extends EventDispatcher
	{
		/* The SoundChannel object that the SoundPlayer plays through */
		public var soundChannel:SoundChannel;
		/* The current position (in seconds) of the SoundPlayer */
		public var time:Number;
		/* The total time (in seconds) of the SoundPlayer */
		public var duration:Number;
		
		private var position:Number;
		private var sound:Sound;
		private var timer:Timer;
		private var _volume:Number;
		
		/**
		 * Creates a handler for playing sound files.
		 * @param	filePath	<String> Relative or absolute path to the soundfile
		 */
		public function SoundPlayer(filePath:String):void
		{
			timer = new Timer(50);
			sound = new Sound(new URLRequest(filePath));
		}
		
		public function get volume():Number
		{
			return _volume;
		}
		public function set volume(value:Number):void
		{
			_volume = value;
			var soundTransform:SoundTransform = new SoundTransform();
			soundTransform.volume = volume;
			soundChannel.soundTransform = soundTransform;
		}
		
		/**
		 * Plays the loaded sound file.
		 * @param	startTime	<Number> Time (in milliseconds) to start at when playback starts.
		 */
		public function play(startTime:Number = 0):void
		{
			soundChannel = sound.play(startTime);
			soundChannel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			timer.addEventListener(TimerEvent.TIMER, onPlayheadUpdate);
			timer.start();
		}
		
		/**
		 * Pauses the current playing sound.
		 */
		public function pause():void
		{
			position = soundChannel.position;
			soundChannel.stop();
			timer.removeEventListener(TimerEvent.TIMER, onPlayheadUpdate);
		}
		
		/**
		 * Resumes a currently paused sound.
		 */
		public function resume():void
		{
			play(position);
		}
		
		/**
		 * Mutes the currently playing sound.
		 */
		public function mute():void
		{
			soundChannel.soundTransform = new SoundTransform(0);
		}
		
		/**
		 * Un-mutes a currently muted sound.
		 */
		public function unMute():void
		{
			soundChannel.soundTransform = new SoundTransform(1);
		}
		
		/**
		 * Stops a currently playing sound.
		 */
		public function stop():void
		{
			if (soundChannel != null) soundChannel.stop();
			timer.removeEventListener(TimerEvent.TIMER, onPlayheadUpdate);
		}
		
		private function onSoundComplete(e:Event):void 
		{
			timer.removeEventListener(TimerEvent.TIMER, onPlayheadUpdate);
			dispatchEvent(new Event(Event.SOUND_COMPLETE));
		}
		
		private function onPlayheadUpdate(e:TimerEvent):void 
		{
			time = soundChannel.position / 1000;
			duration = sound.length / 1000;
			dispatchEvent(new Event(Event.CHANGE));
		}
	}
}