package com.daleyjem.as3.air
{
	import flash.filesystem.File;
	import flash.desktop.NativeApplication;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.desktop.Updater;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import com.daleyjem.as3.air.net.InternetFile;
	import com.daleyjem.as3.air.net.InternetFileEvent;
	import flash.net.URLRequestHeader;
	import com.dynamicflash.util.Base64;
	
	/**
	 * Checks for application updates.
	 * Update file should follow this syntax:
	 * 		<?xml version="1.0" encoding="utf-8"?>
	 *		<update>
	 *			<version>1.1</update>
	 *			<changelog>
	 *				<change>Started testing.</change>
	 *			</changelog>
	 *		</update>
	 * @author	Jeremy Daley
	 */
	public class ApplicationUpdate extends EventDispatcher
	{
		private var _uri:String;
		private var updater:Updater;
		
		public var version:ApplicationVersion;
		public var currentVersion:ApplicationVersion;
		public var changes:Array = new Array();
		public var hasUpdate:Boolean = false;
		public var tempAppDirectory:String;
		public var bytesTotal:uint;
		public var bytesLoaded:uint = 0;
		public var updatedAppFileURL:String;
		
		/**
		 * Instantiates new ApplicationUpdate object
		 * @param	applicationUpdateUri	<String> Url to XML file containing application info (version, changelog, etc.)
		 */
		public function ApplicationUpdate(applicationUpdateUri:String):void
		{
			_uri = applicationUpdateUri;
		}
		
		/**
		 * Checks remote server for update and dispatches <ApplicationUpdateEvent>
		 * @param	userName	<String> Username for authentication on server containing AIR file
		 * @param	password	<String> Password for authentication on server containing AIR file
		 * @param	authType	<String> Authorization type for authentication on server containing AIR file
		 */
		public function updateCheck(userName:String = null, password:String = null, authType:String = "Basic"):void
		{
			var urlRequest:URLRequest = new URLRequest(_uri);
			
			if (userName != null)
			{
				var encString:String = Base64.encode(userName + ":" + password);
				var authHeader:String = authType + " " + encString;
				var credsHeader:URLRequestHeader = new URLRequestHeader("Authorization", authHeader);
				urlRequest.requestHeaders.push(credsHeader);
			}
			
			var urlLoader:URLLoader = new URLLoader(urlRequest);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			urlLoader.addEventListener(Event.COMPLETE, onXMLLoaded);
		}
		
		/**
		 * Pulls down remote file to specified local <File> object
		 * @param	localFile	<File> Local file object to put installer update
		 */
		public function runUpdate(localFile:File):void 
		{
			updater =  new Updater();
			
			try
			{
				updater.update(localFile, version.major + "." + version.minor); // + "." + version.build + "." + version.revision);
				NativeApplication.nativeApplication.exit();
			}
			catch (e)
			{
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "May be testing locally"));
				NativeApplication.nativeApplication.exit();
			}
		}
		
		private function onIOError(e:IOErrorEvent):void 
		{
			dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "IO error"));
		}
		
		private function onXMLLoaded(e:Event):void 
		{
			// Get remote update information
			var remoteXML:XML = new XML((e.target as URLLoader).data);
			version = new ApplicationVersion(remoteXML..version[0]);
			updatedAppFileURL = remoteXML..url[0];
			for each (var changeNode:XML in remoteXML..changelog.change)
			{
				changes.push(changeNode);
			}
			
			// Get current version info
			var appXML:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace = appXML.namespace();
			var currVersion:String = appXML.ns::version;

			if (version.isGreaterThan(new ApplicationVersion(currVersion)))
			{
				hasUpdate = true;
			}

			currentVersion = new ApplicationVersion(currVersion);
			dispatchEvent(new ApplicationUpdateEvent(ApplicationUpdateEvent.UPDATE_CHECK_COMPLETE));
		}
	}
}