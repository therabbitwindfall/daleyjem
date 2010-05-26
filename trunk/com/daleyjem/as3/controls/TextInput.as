package com.daleyjem.as3.controls
{
	import flash.display.DisplayObject;
	import flash.display.LineScaleMode;
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	
	public class TextInput extends Sprite
	{
		public var textField:TextField;
		
		private var _bg:DisplayObject;
		private var _text:String = "";
		
		private static const MARGIN_LEFT:Number = 2;
		
		public function TextInput(bg:DisplayObject = null):void
		{	
			textField = new TextField();
			textField.wordWrap = false;
			textField.type = TextFieldType.INPUT;
			
			_bg = bg;
			
			if (_bg == null)
			{
				_bg = createGenericBorder();
				textField.y = 0;
			}
			else
			{
				textField.y = 2;
			}
			
			textField.x = MARGIN_LEFT;
			textField.height = _bg.height;
			
			addChild(_bg);
			addChild(textField);
			
			width = 100;
			
			textField.addEventListener(FocusEvent.FOCUS_OUT, onTextFocusOut);
		}
		
		override public function get width():Number
		{
			return _bg.width;
		}
		override public function set width(value:Number):void 
		{
			textField.width = value - (MARGIN_LEFT * 4);
			_bg.width = value;
		}
		
		public function set text(value:String):void
		{
			_text = value;
			textField.text = text;
		}
		public function get text():String
		{
			return _text;
		}
		
		private function createGenericBorder():Sprite
		{
			var newSprite:Sprite = new Sprite();
			newSprite.graphics.beginFill(0xffffff, 1);
			newSprite.graphics.lineStyle(1.25, 0x666666, 1);
			newSprite.graphics.lineTo(0, 20);
			newSprite.graphics.lineStyle(1.25, 0xcccccc, 1);
			newSprite.graphics.lineTo(30, 20);
			newSprite.graphics.lineStyle(1.25, 0xcccccc, 1);
			newSprite.graphics.lineTo(30, 0);
			newSprite.graphics.lineStyle(1.25, 0x666666, 1);
			newSprite.graphics.lineTo(0, 0);
			newSprite.graphics.endFill();
			
			var grid:Rectangle = new Rectangle(10, 5, 10, 10);
			newSprite.scale9Grid = grid;
			
			return newSprite;
		}
		
		private function onTextFocusOut(e:FocusEvent):void 
		{
			textField.scrollH = 0;
		}
	}
}