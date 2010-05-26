package com.daleyjem.as3.net
{
	import com.daleyjem.as3.Utils.Uri;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.OutputProgressEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.Socket;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLStream;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	import com.dynamicflash.util.Base64;
	
	/**
	 * @author Jeremy Daley
	 */
	[Event(name = "progress", type = "flash.events.ProgressEvent")]
	[Event(name = "metaDataReady", type = "com.daleyjem.as3.net.InternetFileEvent")]
	[Event(name = "fileDownloadComplete", type = "com.daleyjem.as3.net.InternetFileEvent")]
	[Event(name = "fileWriteComplete", type = "com.daleyjem.as3.net.InternetFileEvent")]
	[Event(name = "headerPollComplete", type = "com.daleyjem.as3.net.InternetFileEvent")]
	public class InternetFile extends EventDispatcher
	{
		private var fileStream:FileStream;
		private var urlStream:URLStream;
		private var _url:String;
		private var uri:Uri;
		private var socket:Socket;
		private var accumHeaders:String = "";
		
		public var status:String;
		public var headers:Object;
		public var bytesLoaded:uint = 0;
		public var bytesTotal:uint;
		public var localFile:File;
		public var headerBytes:uint = 0;
		
		public static const SOCKET_STATUS_OK:String 	= "ok";
		public static const SOCKET_STATUS_ERROR:String 	= "error";
		
		public function InternetFile(url:String):void
		{
			_url = url;
			uri = new Uri(_url);
		}
		
		public function download(localUri:String, userName:String = null, password:String = null, authType:String = "Basic"):void
		{
			localFile = new File(localUri);
			fileStream = new FileStream();
			fileStream.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			fileStream.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS, onFileOutputProgress);
			fileStream.openAsync(localFile, FileMode.WRITE);
			
			var urlRequest:URLRequest = new URLRequest(_url);
			
			if (userName != null)
			{
				var encString:String = Base64.encode(userName + ":" + password);
				var authHeader:String = authType + " " + encString;
				var credsHeader:URLRequestHeader = new URLRequestHeader("Authorization", authHeader);
				urlRequest.requestHeaders.push(credsHeader);
			}
			
			urlStream = new URLStream();
			urlStream.load(urlRequest);
			urlStream.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, onHTTPResponse);
			urlStream.addEventListener(ProgressEvent.PROGRESS, onStreamProgress);
			urlStream.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			urlStream.addEventListener(Event.COMPLETE, onDownloadComplete);
		}
		
		public function getFilesize():void
		{
			socket = new Socket();
			socket.addEventListener(Event.CONNECT, onSocketConnect);
			socket.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
			socket.addEventListener(IOErrorEvent.IO_ERROR, onSocketError);
			socket.addEventListener(Event.CLOSE, onSocketClose);
			socket.connect(uri.host, 80);
		}
		
		private function onSocketClose(e:Event):void 
		{
			
		}
		
		private function onSocketError(e:IOErrorEvent):void 
		{
			status = SOCKET_STATUS_ERROR;
			if (socket.connected) socket.close();
			dispatchEvent(new InternetFileEvent(this, InternetFileEvent.HEADER_POLL_COMPLETE, true));
		}
		
		private function onSocketConnect(e:Event):void 
		{			
			trace("socket connected on:", uri.host);
			trace("send header for:", uri.trail);

			socket.removeEventListener(Event.CONNECT, onSocketConnect);
			socket.writeUTFBytes("GET " + uri.trail + " HTTP/1.1\r\n");
			socket.writeUTFBytes("Host: " + uri.host + "\r\n");
			socket.writeUTFBytes("Keep-Alive: 300\r\n");
			socket.writeUTFBytes("Connection: Close\r\n\r\n");
			socket.flush();
		}
		
		private function onSocketData(e:ProgressEvent):void 
		{
			var header:String = socket.readUTFBytes(socket.bytesAvailable);
			accumHeaders += header;
			if (accumHeaders.toLowerCase().indexOf("connection: close") > -1)
			{
				var splitter:Array = accumHeaders.split("\r\n");
				var tempStatus:String = splitter[0].toLowerCase();
				if (tempStatus.indexOf("200 ok") > -1)
				{
					status = SOCKET_STATUS_OK;
				}
				else
				{
					status = SOCKET_STATUS_ERROR;
				}
				for each (var line:String in splitter)
				{
					if (line.toLowerCase().indexOf("content-length") > -1)
					{
						headerBytes = uint(line.split(":")[1].split(" ").join(""));
						break;
					}
				}
				if (socket.connected) socket.close();
				dispatchEvent(new InternetFileEvent(this, InternetFileEvent.HEADER_POLL_COMPLETE, true));
			}
		}
		
		private function onDownloadComplete(e:Event):void 
		{
			urlStream.close();
			dispatchEvent(new InternetFileEvent(this, InternetFileEvent.FILE_DOWNLOAD_COMPLETE));
		}
		
		private function onFileOutputProgress(e:OutputProgressEvent):void 
		{
			if (e.bytesTotal == bytesTotal)
			{
				fileStream.removeEventListener(OutputProgressEvent.OUTPUT_PROGRESS, onFileOutputProgress);
				fileStream.close();
				dispatchEvent(new InternetFileEvent(this, InternetFileEvent.FILE_WRITE_COMPLETE));
			}
		}
		
		private function onStreamProgress(e:ProgressEvent):void 
		{
			var byteArray:ByteArray = new ByteArray();
			urlStream.readBytes(byteArray, 0, urlStream.bytesAvailable);
			fileStream.writeBytes(byteArray, 0, byteArray.length);
			
			bytesLoaded = e.bytesLoaded;
			bytesTotal = e.bytesTotal;

			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, bytesLoaded, bytesTotal));
		}
		
		private function onIOError(e:IOErrorEvent):void 
		{
			trace(e.text);
		}
		
		private function onHTTPResponse(e:HTTPStatusEvent):void 
		{
			headers = new Object();
			for each (var header:URLRequestHeader in e.responseHeaders)
			{
				headers[header.name] = header.value;
			}
			dispatchEvent(new InternetFileEvent(this, InternetFileEvent.META_DATA_READY));
		}
	}
}