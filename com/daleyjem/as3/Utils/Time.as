package com.daleyjem.as3.Utils
{
	public final class Time
	{
		/**
		 * Converts a hh:mm:ss.ms formatted timestamp to seconds.
		 * 
		 * @param	timeStamp	<String> hh:mm:ss.ms formatted timestamp.
		 * @return	seconds		<Number> Converted timestamp in seconds format.
		 */
		public static function convertTimeStampToSeconds(timeStamp:String):Number
		{
			var colonSplit:Array = timeStamp.split(":");
			var hoursAsSeconds:Number = Number(colonSplit[0]) * 60 * 60;
			var minutesAsSeconds:Number = Number(colonSplit[1]) * 60;
			var secondsAsSeconds:Number = Number(colonSplit[2].split(".")[0]);
			var milliseconds:Number = Number(colonSplit[2].split(".")[1]) / 10;
			var returnVal:Number = hoursAsSeconds + minutesAsSeconds + secondsAsSeconds + milliseconds;
			return returnVal;
		}
		
		/**
		 * Converts seconds to mm:ss timestamp.
		 * 
		 * @param	time	<Number> Time in seconds.
		 * @return
		 */
		public static function convertSecondsToTimeStamp(time:Number):String
		{
			var minutes:Number = Math.floor(time / 60);
			var seconds:Number = int(time - (minutes * 60));
			var min:String = minutes.toString();
			var sec:String = seconds.toString();
			if (sec.length == 1) sec = "0" + sec;
			return min + ":" + sec;
		}
	}
}