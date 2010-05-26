package com.daleyjem.as3.html
{
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class Link extends TextElement
	{
		private var _href:String;
		private var _window:String;
		
		public function Link(__text:String, __href:String, __window:String = "_self"):void
		{
			buttonMode = true;
			mouseChildren = false;
			
			href = __href;
			text = __text;
			window = __window;
			
			/* Set default link attributes */
			setAttribute(TextAttribute.COLOR, 0x0000ff);
			setAttribute(TextAttribute.UNDERLINE, true);
			
			addChild(textField);
			
			addEventListener(MouseEvent.CLICK, navigateTo);
			addEventListener(MouseEvent.ROLL_OVER, hover);
			addEventListener(MouseEvent.ROLL_OUT, unHover);
		}
		
		public function get href():String
		{
			return _href
		}
		public function set href(value:String):void
		{
			_href = value;
		}
		
		public function get window():String
		{
			return _window;
		}
		public function set window(value:String):void
		{
			_window = value;
		}
		
		private function navigateTo(e:MouseEvent):void
		{
			navigateToURL(new URLRequest(href), window);
		}
		
		private function hover(e:MouseEvent):void
		{
			if (getAttribute(LinkAttribute.HOVER_UNDERLINE) as Boolean)
			{
				text = "<u>" + text.replace(/(<u>|<U>)/, "").replace(/(<\/u>|<\/U>)/, "") + "</u>";
			}
			else
			{
				text = text.replace(/(<u>|<U>)/, "").replace(/(<\/u>|<\/U>)/, "");
			}
			
			if (getAttribute(LinkAttribute.HOVER_COLOR) != null)
			{
				textField.textColor = getAttribute(LinkAttribute.HOVER_COLOR) as uint;
			}
		}
		
		private function unHover(e:MouseEvent):void
		{
			if (getAttribute(TextAttribute.UNDERLINE) as Boolean)
			{
				text = "<u>" + text.replace(/(<u>|<U>)/, "").replace(/(<\/u>|<\/U>)/, "") + "</u>";
			}
			else
			{
				text = text.replace(/(<u>|<U>)/, "").replace(/(<\/u>|<\/U>)/, "");
			}
			
			textField.textColor = getAttribute(TextAttribute.COLOR) as uint;
		}
	}
}