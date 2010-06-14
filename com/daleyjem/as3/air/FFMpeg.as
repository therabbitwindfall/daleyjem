package com.daleyjem.as3.air
{
	import com.daleyjem.as3.utils.Time;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NativeProcessExitEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.utils.Timer;
	
	public class FFMpeg extends EventDispatcher
	{
		public var progressTime:Number = 0;
		public var videoTime:Number = 0;
		public var parameters:Array = new Array();
		public var error:String;
		
		private var exeFile:File;
		private var process:NativeProcess;
		private var processInfo:NativeProcessStartupInfo;
		private var timer:Timer;
		private var errorList:Array = new Array(
			{search: "no such file or directory", output: "Input file doesn't exist"}
		);
		
		public static const PARAM_VIDEO_BITRATE:String		= "-b;k";
		public static const PARAM_VIDEO_FRAMERATE:String	= "-r";
		public static const PARAM_VIDEO_DIMENSIONS:String	= "-s";
		public static const PARAM_VIDEO_CODEC:String		= "-vcodec";
		public static const PARAM_TIME_START:String			= "-ss";
		public static const PARAM_TIME_DURATION:String		= "-t";
		public static const PARAM_SAME_QUALITY:String 		= "-sameq";
		public static const PARAM_AUDIO_FREQUENCY:String	= "-ar";
		public static const PARAM_AUDIO_BITRATE:String		= "-ab;k";
		public static const PARAM_AUDIO_CHANNELS:String		= "-ac";
		public static const PARAM_AUDIO_DISABLED:String		= "-an";
		public static const PARAM_AUDIO_CODEC:String		= "-acodec";
		public static const PARAM_FILE_INPUT:String			= "-i";
		public static const PARAM_FILE_OUTPUT:String		= "-y";
		public static const PARAM_OUTPUT_TYPE:String		= "-f";
		
		public static const FILETYPE_WMV:String		= "wmv";
		public static const FILETYPE_MP3:String		= "mp3";
		public static const FILETYPE_WAV:String		= "wav";
		public static const FILETYPE_MOV:String		= "mov";
		public static const FILETYPE_MP4:String		= "mp4";
		public static const FILETYPE_AVI:String		= "avi";
		public static const FILETYPE_MPEG:String	= "mpg";
		
		public function FFMpeg(executable:File):void
		{
			processInfo = new NativeProcessStartupInfo();
			processInfo.executable = executable;
			
			//if (output.length == 0) return;
			
			//load(output);
			//parseInput();
			//parseOutput();
		}
		
		public function addParameter(parameter:String, value:String = null):void
		{
			var paramObj:Object = new Object();
			paramObj.parameter = parameter.split(";")[0];
			paramObj.value = value;
			paramObj.append = (parameter.indexOf(";") > -1) ? (parameter.split(";")[1]) : (""); 
			parameters.push(paramObj);
		}
		
		public function convert():void
		{
			processInfo.arguments = getArguments();
			trace(processInfo.arguments.toString());
			process = new NativeProcess();
			process.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, onErrorData);
			process.addEventListener(NativeProcessExitEvent.EXIT, onProcessExit);
			process.start(processInfo);
			//timer.start();
		}
		
		private function onProcessExit(e:NativeProcessExitEvent):void 
		{
			dispatchEvent(new Event(Event.CLOSE));
		}
		
		private function onErrorData(e:ProgressEvent):void 
		{
			var output:String = process.standardError.readUTFBytes(process.standardError.bytesAvailable);
			checkForError(output);
			if (output.indexOf("Input #0") > -1) parseInput(output);
			if (output.indexOf("time=") > -1) parseProgress(output);
			//trace("<< " + output + " >>");
		}
		
		private function checkForError(_output:String):void
		{
			for each (var errObj:Object in errorList)
			{
				if (_output.indexOf(errObj.search) > -1)
				{
					error = errObj.output;
					dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, errObj.output));
				}
			}
		}
		
		private function parseInput(_output:String):void
		{
			var inputString:String = _output.substring(_output.indexOf("Input #0,"), _output.indexOf("Output #0,"));
			var temp:String = inputString.substr(inputString.indexOf("Duration: "));
			videoTime = Time.convertTimeStampToSeconds(temp.substring(10, temp.indexOf(",") - 1));
			//trace("duration:", videoTime);
		}
		
		private function parseProgress(_output:String):void
		{
			var temp:String = _output.substring(_output.lastIndexOf("time="), _output.lastIndexOf("bitrate="));
			progressTime = Number(temp.substring(5, temp.indexOf(" ") - 1));
			//trace("progress:", progressTime);
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS));
		}
		
		private function getArguments():Vector.<String>
		{
			var returnVector:Vector.<String> = new Vector.<String>();
			for each (var keyVal:Object in parameters)
			{
				returnVector.push(keyVal.parameter);
				if (keyVal.value != null)
				{
					var val:String = keyVal.value + keyVal.append;
					returnVector.push(val);
				}
			}

			return returnVector;
		}
		/*
		public function load(output:String):void
		{
			_output = output;
			parseProgress();
		}
		*/
		
		/*
		private function parseOutput():void
		{
			//var outputString:String = _output.substring(_output.indexOf("Output #0,"), _output.indexOf("Stream mapping:"));
		}
		*/
		
		
	}
}