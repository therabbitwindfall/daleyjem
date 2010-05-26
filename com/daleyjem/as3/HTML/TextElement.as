package com.daleyjem.as3.HTML
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class TextElement extends HTMLElement
	{
		private var _text:String;
		
		public var textField:TextField;
		
		public function TextElement():void
		{
			textField = new TextField();
			textField.autoSize = TextFieldAutoSize.LEFT;
		}
		
		public function get text():String
		{
			return _text;
		}
		public function set text(value:String):void
		{
			_text = value;
			textField.htmlText = _text;
		}
	}
}