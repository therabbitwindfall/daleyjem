package com.daleyjem.as3
{
	import flash.media.SoundTransform;
	import flash.media.SoundChannel;
	
	/**
	 * @author Jeremy M. Daley
	 */
	public class SoundProximity
	{
		public var soundChannel:SoundChannel;
		public var currVolume:Number;
		public var currPan:Number;
		
		private var __angle:Number;
		private var __distance:Number;
		
		private const SOUND_BEHIND_OFFSET:Number = .9;						// Offset of volume to decrease towards the back of target
		
		private var soundTransform:SoundTransform;
		private var currBehindOffset:Number = 0;
				
		/**
		 * Creates a handle for emulating sound perspective on the given
		 * SoundChannel by adjusting volume and pan in relation to the
		 * sound source's proximity and circular degree from the target.
		 * 
		 * @param    _soundChannel    <SoundChannel> The sound channel (source)
		 *           - Commonly produced by Sound.play():SoundChannel
		 */
		public function SoundProximity(_soundChannel:SoundChannel):void
		{
			soundTransform = new SoundTransform();
			soundChannel = _soundChannel;
		}
		
		/**
		 * Number in degrees from 0 to 360 indicating the circular
		 * position of the sound source in relation to the target's
		 * front face.
		 * 
		 * 0=front, 90=right, 180=back, 270=left
		 */
		public function get angle():Number
		{
			return __angle;
		}
		public function set angle(value:Number):void
		{
			var shiftPercentage:Number;
			var altShiftPercentage:Number;
			
			if (value > 0 && value < 180) 									// Sound is on right side
			{
				shiftPercentage = (90 - Math.abs(90 - value)) / 90;
				soundTransform.pan = shiftPercentage;
			}
			
			if (value > 180) 												// Sound is on left side
			{
				shiftPercentage = (90 - Math.abs(270 - value)) / 90;
				soundTransform.pan = -shiftPercentage;
			}
			
			if (value > 90 && value < 270) 									// Sound is behind
			{
				altShiftPercentage = (90 - Math.abs(180 - value)) / 90;
				currBehindOffset = (SOUND_BEHIND_OFFSET * soundTransform.volume) * altShiftPercentage;
			}
			else
			{
				currBehindOffset = 0;
			}
			
			if (soundTransform.pan <= -0.987) soundTransform.pan = -0.987;	// Prevents pan from going full-sided to left
			if (soundTransform.pan >= 0.987) soundTransform.pan = 0.987;	// Prevents pan from going full-sided to right
			
			soundChannel.soundTransform = soundTransform;
			__angle = value;
			distance = distance;											// Re-adjusts distance (volume) to accomodate possible "behind offset"
		}
		
		/**
		 * Percentage value between 0 and 1 indicating how far the 
		 * sound source is from the target's maximum hearing range.
		 * 
		 * 0=close, 1=far
		 */
		public function get distance():Number
		{
			return __distance;
		}
		
		public function set distance(value:Number):void
		{
			soundTransform.volume = value - currBehindOffset;
			if (soundTransform.volume <= 0) soundTransform.volume = 0;		// Prevents negative volume (which produces sound)
			soundChannel.soundTransform = soundTransform;
			__distance = value;
		}
	}
}