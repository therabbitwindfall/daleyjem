package com.daleyjem.as3
{
	import flash.events.EventDispatcher;
	import flash.display.DisplayObject;
	import flash.events.ProgressEvent;
	import flash.geom.ColorTransform;
	import flash.media.SoundTransform;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.media.SoundChannel;
	import flash.utils.Timer;
	
	public class SoundTween extends EventDispatcher
	{
		public var value:Number;
		public var currFrame:Number = 0;
		public var frameDuration:Number;
	
		private var soundTransform:SoundTransform;
		
		private var _soundChannel:SoundChannel;
		private var _soundTransform:SoundTransform;
		private var _startValue:Number;
		private var _endValue:Number;
		private var _property:String;
		
		private var milliIncrement:Number = 50;
		private var currInc:Number = 0;
		private var durInc:Number = 0;
		private var incrementTimer:Timer;
	
		public function SoundTween(soundTransform:SoundTransform, property:String, startValue:Number, endValue:Number, duration:Number):void
		//public function SoundTween(soundChannel:SoundChannel, property:String, startValue:Number, endValue:Number, duration:Number):void
		{
			//_soundChannel = soundChannel;
			_soundTransform = soundTransform;
			_property = property;
			_startValue = startValue;
			_endValue = endValue;
			
			value = startValue;
			durInc = 1000 * duration;
			
			if (duration <= 0)
			{
				SetValue(endValue);
				return;
			}
			
			incrementTimer = new Timer(milliIncrement);
			incrementTimer.addEventListener(TimerEvent.TIMER, incrementValue);
			incrementTimer.start();
		}
		
		public function stop():void
		{
			if (incrementTimer != null)	incrementTimer.stop();
		}
		
		private function incrementValue(e:TimerEvent):void
		{
			currInc += milliIncrement;
			
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS));
			
			if (currInc >= durInc)
			{
				e.target.stop();
				currInc = durInc;
				dispatchEvent(new Event(Event.COMPLETE));
			}
			
			var framePercentage:Number = currInc / durInc;
			var valueInc:Number = framePercentage * (_endValue - _startValue);
			var newValue:Number = _startValue + valueInc;
			
			SetValue(newValue);
		}
		
		private function SetValue(myNewValue:Number):void
		{
			var myST:SoundTransform = new SoundTransform();
			myST[_property] = myNewValue;
			value = myNewValue;
			_soundTransform = myST;
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS));
			//_soundChannel.soundTransform = myST;
		}
	}
}