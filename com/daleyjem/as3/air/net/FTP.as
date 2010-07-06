package com.daleyjem.as3.air.net
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.Socket;
	import flash.utils.ByteArray;

	[Event(name = "connected", type = "com.daleyjem.as3.air.net.FTPEvent")]
	[Event(name = "uploadComplete", type = "com.daleyjem.as3.air.net.FTPEvent")]
	public class FTP extends EventDispatcher
	{
		private var socket:Socket;
		private var dataSocket:Socket;
		private var host:String;
		private var port:int;
		private var user:String;
		private var pass:String;
		private var path:String;
		private var file:File;
		private var fileName:String;
		private var dataIP:String;
		private var dataPort:int;
		private var fileSize:int = 0;
		
		public var isUploading:Boolean = false;
		
		private static const RESPONSE_CONNECTED:String 			= "220";
		private static const RESPONSE_PASS_ACCEPTED:String		= "230";
		private static const RESPONSE_USER_ACCEPTED:String		= "331";
		private static const RESPONSE_CURRENT_DIRECTORY:String	= "250";
		private static const RESPONSE_CONNECTION_ACCEPT:String	= "150";
		private static const RESPONSE_ENTERING_PASSIVE:String	= "227";
		private static const RESPONSE_TYPE_CHANGE:String		= "200";
		private static const RESPONSE_SIZE:String				= "213";
		private static const RESPONSE_FILE_XFER_SUCCESS:String	= "226";
		
		public function FTP() 
		{
			socket = new Socket();
			socket.addEventListener(Event.CONNECT, onSocketConnect);
			socket.addEventListener(IOErrorEvent.IO_ERROR, onSocketIOError);
			socket.addEventListener(Event.CLOSE, onSocketClose);
			socket.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
		}
		
		public function connect(_host:String, _user:String = "", _pass:String = "", _port:int = 21):void
		{
			host = _host;
			user = _user;
			pass = _pass;
			port = _port;
			
			socket.connect(_host, _port);
		}
		
		public function upload(_file:File, _fileName:String, _path:String = "/"):void
		{
			isUploading = true;
			fileName = _fileName;
			path = _path;
			file = _file;
			sendCommand(socket, "CWD " + path);
		}
		
		public function close():void
		{
			if (dataSocket.connected) dataSocket.close();
			if (socket.connected) socket.close();
			
			dataSocket = null;
			socket = null;
			
			trace("FTP: Client socket closed");
		}
		
		private function sendCommand(_socket:Socket, command:String):void
		{
			var commandTrace:String = command;
			if (commandTrace.indexOf("PASS ") > -1) commandTrace = passify(commandTrace);
			trace(commandTrace);
			_socket.writeUTFBytes(command + "\r\n");
			_socket.flush();
		}
		
		private function writeToServer(_file:File):void
		{
			var fileStream:FileStream = new FileStream();
			fileStream.open(_file, FileMode.READ);
			var byteArray:ByteArray = new ByteArray();
			fileSize = fileStream.bytesAvailable;
			fileStream.readBytes(byteArray, 0, fileSize)

			dataSocket.writeBytes(byteArray, 0, byteArray.bytesAvailable);
			dataSocket.flush();
			dataSocket.close();
			
			fileStream.close();
			fileStream = null;
		}
		
		private function passify(command:String):String
		{
			var password:String = command.split(" ")[1];
			return "PASS " + password.split(/\S/).join("*");
		}
		
		private function onSocketData(e:ProgressEvent):void 
		{
			var _socket:Socket = e.target as Socket;
			var response:String = socket.readUTFBytes(socket.bytesAvailable);
			var code:String = response.substr(0, 3);
			trace(response);
			
			switch (code)
			{
				case RESPONSE_CONNECTED:
					sendCommand(_socket, "USER " + user);
					break;
				case RESPONSE_USER_ACCEPTED:
					sendCommand(_socket, "PASS " + pass);
					break;
				case RESPONSE_PASS_ACCEPTED:
					dispatchEvent(new FTPEvent(FTPEvent.CONNECTED));
					break;
				case RESPONSE_CURRENT_DIRECTORY:
					if (isUploading)
					{
						sendCommand(_socket, "TYPE I");
					}
					break;
				case RESPONSE_TYPE_CHANGE:
					if (isUploading)
					{
						sendCommand(_socket, "PASV");
					}
					break;
				case RESPONSE_ENTERING_PASSIVE:
					if (isUploading)
					{
						sendCommand(_socket, "STOR " + fileName);
						
						var temp:Object = response.substring(response.indexOf("(") + 1, response.indexOf(")"));
						var splitter:Object = temp.split(",");
						dataIP = splitter.slice(0, 4).join(".");
						dataPort = parseInt(splitter[4]) * 256 + int(splitter[5]);

						dataSocket = new Socket(dataIP, dataPort);
						dataSocket.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
						dataSocket.addEventListener(Event.CLOSE, onSocketClose);
					}
					break;
				case RESPONSE_CONNECTION_ACCEPT:
					if (isUploading)
					{
						writeToServer(file);
					}
					break;
				case RESPONSE_FILE_XFER_SUCCESS:
					isUploading = false;
					dispatchEvent(new FTPEvent(FTPEvent.UPLOAD_COMPLETE));
					break;
			}
		}
		
		private function onSocketClose(e:Event):void 
		{
			trace("FTP: Socket closed");
		}
		
		private function onSocketIOError(e:IOErrorEvent):void 
		{
			trace("FTP: IO error");
		}
		
		private function onSocketConnect(e:Event):void 
		{
			trace("FTP: Socket connected");
		}
		
		/*
		private function checkFilesize():void
		{
			sendCommand(dataSocket, "SIZE " + fileName);
		}
		*/
	}
}