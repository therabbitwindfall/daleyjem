package com.daleyjem.as3
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	/**
	 * ...
	 * @author Jeremy Daley
	 */
	public class Tracer extends Sprite
	{
		private var _params:Object =  new Object();
		private var bg:Sprite;
		private var txtTrace:TextField;
		
		private static const DEF_WIDTH:Number = 100;
		private static const DEF_HEIGHT:Number = 100;
		private static const DEF_MARGIN:Number = 10;
		
		public function Tracer(params:Object):void
		{
			bgTransparency = .8;
			bgColor = 0xffffff;
			
			for (var tester:Object in params)
			{
				try
				{
					_params[tester] = params[tester];
					this[tester] = params[tester] as Object;
				}
				catch (e:Error)
				{
					trace(e.getStackTrace());
				}
			}
			
			bg = new Sprite();
			bg.graphics.beginFill(bgColor, bgTransparency);
			bg.graphics.drawRoundRect(0, 0, (params["width"]) ? (params["width"]) : (DEF_WIDTH), (params["height"]) ? (params["height"]) : (DEF_HEIGHT), 17, 14);
			bg.graphics.endFill();
			addChild(bg);
			
			width = bg.width;
			height = bg.height;
			
			txtTrace = new TextField();
			txtTrace.type = TextFieldType.INPUT;
			txtTrace.x = 10;
			txtTrace.y = 10;
			txtTrace.width = bg.width - (txtTrace.x * 2);
			txtTrace.height = bg.height - (txtTrace.y * 2);
			txtTrace.multiline = true;
			addChild(txtTrace);
		}
		
		public function write(value:String):void
		{
			txtTrace.text = value + "\n";
		}
		
		public function get right():Number
		{
			return _params["right"];
		}
		public function set right(value:Number):void
		{
			_params["right"] = value;
		}
		
		public function get bgColor():Number
		{
			return _params["bgColor"];
		}
		public function set bgColor(value:Number):void
		{
			_params["bgColor"] = value;
		}
		
		public function get bgTransparency():Number
		{
			return _params["bgTransparency"];
		}
		public function set bgTransparency(value:Number):void
		{
			_params["bgTransparency"] = value;
		}
	}
	
}