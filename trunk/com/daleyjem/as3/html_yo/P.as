package com.daleyjem.as3.HTML
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	public class P extends HTMLElement
	{
		private var textField:TextField;
		
		public function P(_html):void
		{
			super(_html);
			
			textField = new TextField();
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.multiline = true;
			textField.htmlText = htmlNode;
			
			addChild(textField);
		}
	}
	
}