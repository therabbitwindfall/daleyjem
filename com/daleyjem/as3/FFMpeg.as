package com.daleyjem.as3
{
	import com.daleyjem.as3.Utils.Time;
	
	public class FFMpeg
	{
		public var time:Number = 0;
		public var duration:Number = 0;
		
		private var _output:String;
		
		public function FFMpeg(output:String = ""):void
		{
			if (output.length == 0) return;
			
			load(output);
			parseInput();
			parseOutput();
		}
		
		public function load(output:String):void
		{
			_output = output;
			parseProgress();
		}
		
		private function parseInput():void
		{
			var inputString:String = _output.substring(_output.indexOf("Input #0,"), _output.indexOf("Output #0,"));
			var temp:String = inputString.substr(inputString.indexOf("Duration: "));
			duration = Time.convertTimeStampToSeconds(temp.substring(10, temp.indexOf(",") - 1));
			//trace("duration:", duration);
		}
		
		private function parseOutput():void
		{
			//var outputString:String = _output.substring(_output.indexOf("Output #0,"), _output.indexOf("Stream mapping:"));
		}
		
		private function parseProgress():void
		{
			var temp:String = _output.substring(_output.lastIndexOf("time="), _output.lastIndexOf("bitrate="));
			time = Number(temp.substring(5, temp.indexOf(" ") - 1));
			//trace(time);
		}
	}
}