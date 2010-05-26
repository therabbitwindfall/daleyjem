package com.daleyjem.as3
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	/**
	 * @author Jeremy Daley
	 */
	public class SpeechSynthesizer extends EventDispatcher
	{
		private var _sentence:String;
		private var _voice:String;
		private var _engineUri:String;
		private var _voiceVariable:String;
		private var _sentenceVariable:String;
		private var _requestMethod:String;
		private var request:URLRequest;
		private var requestVars:URLVariables;
		private var speechSound:Sound;
		
		/**
		 * A class for communicating with a TTS engine.
		 * 
		 * @param	engineUri			<String> Uri of TTS engine.
		 * @param	sentenceVariable	<String> GET/POST variable that engine takes for the text to speak (default="sentence").
		 * @param	voiceVariable		<String> GET/POST variable that engine takes as the voice to speak as (default="voice").
		 * @param	requestMethod		<flash.net.URLRequestMethod> Request methods POST or GET (default="GET").
		 */
		public function SpeechSynthesizer(engineUri:String, sentenceVariable:String = "sentence", voiceVariable:String = "voice", requestMethod:String = URLRequestMethod.GET):void
		{
			_engineUri = engineUri;
			_sentenceVariable = sentenceVariable;
			_voiceVariable = voiceVariable;
			_requestMethod = requestMethod;
		}
		
		/**
		 * Sends data to the TTS engine and plays sound file upon receiving.
		 * 
		 * @param	sentence	<String> The sentence to speak.
		 * @param	voice		<String> The voice to use when speaking (if supported in engine).
		 */
		public function speak(sentence:String, voice:String = ""):void
		{
			_sentence = sentence;
			_voice = voice;
			getMp3();
		}
		
		/**
		 * Gets the available voices from the webserver hosting the TTS engine.
		 * 
		 * @param	serviceUri		<String> Uri of the webservice which returns available voices.
		 * @param	voiceNodeName	<String> Name of the node in the returned XML that contains each available voice.
		 * @return					<Array> An array containing all of the available voices.
		 */
		/*
		 public static function getAvailableVoices(serviceUri:String, voiceNodeName:String = "", requestMethod:String = URLRequestMethod.GET):Array
		{
			var returnArray:Array = new Array();
			var getRequest:URLRequest = new URLRequest(serviceUri);
			getRequest.method = requestMethod;
			var getDataLoader:URLLoader = new URLLoader(getRequest);
			//getDataLoader.
			//getDataLoader.addEventListener(Event.COMPLETE, availableVoicesLoaded);
		}*/
		
		private function availableVoicesLoaded(e:Event):void
		{
			
		}
		
		private function getMp3():void
		{
			var requestString:String = _sentenceVariable + "=" + _sentence + "&" + _voiceVariable + "=" + _voice;
			request = new URLRequest(_engineUri);
			requestVars = new URLVariables(requestString);
			request.data = requestVars;
			request.method = _requestMethod;

			speechSound = new Sound(request);
			speechSound.addEventListener(Event.COMPLETE, soundLoaded);
		}
		
		private function soundLoaded(e:Event):void
		{
			speechSound.play();
		}
	}
}