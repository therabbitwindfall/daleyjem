package com.daleyjem.as3.ui.nonflex
{
	import flash.display.LineScaleMode;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.BevelFilter;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Jeremy Daley
	 */
	public class GenericButton extends MovieClip
	{
		/* Getter/Setter vars */
		private var _label:String;
		private var _fontSize:Number;
		
		private var txtLabel:TextField;
		private var bg:Sprite;
		private var bevelFilter:BevelFilter;
		private var glowFilter:GlowFilter;
		private var shadowFilter:DropShadowFilter;
		
		private static const CORNER_RADIUS:Number = 15;
		private static const MIN_HORIZ_PADDING:Number = 20;
		//private static const MIN_VERT_PADDING:Number = 10;
		private static const DEFAULT_FONT:String = "Arial";
		private static const FONT_SIZE_RATIO:Number = 0.45;
		
		public function GenericButton(buttonLabel:String = "Click"):void
		{
			_label = buttonLabel;			
			
			bg = new Sprite();
			bg.graphics.beginFill(0xffffff, 1);
			bg.graphics.drawRoundRect(0, 0, 100, 100, CORNER_RADIUS, CORNER_RADIUS);
			bg.graphics.endFill();
			bg.scale9Grid = new Rectangle(CORNER_RADIUS, CORNER_RADIUS, bg.width - (CORNER_RADIUS * 2), bg.height - (CORNER_RADIUS * 2));
			
			bevelFilter = new BevelFilter();
			bevelFilter.blurX = bevelFilter.blurY = bevelFilter.distance = 25;
			bevelFilter.angle = 90;
			bevelFilter.strength = 0.15;
			
			glowFilter = new GlowFilter(0x000000, 0.4, 3, 3);
			
			shadowFilter = new DropShadowFilter();
			shadowFilter.blurX = shadowFilter.blurY = shadowFilter.distance = 5;
			shadowFilter.alpha = 0.4;
			
			txtLabel = new TextField();
			txtLabel.antiAliasType = AntiAliasType.ADVANCED;
			txtLabel.defaultTextFormat = new TextFormat(DEFAULT_FONT, 16, 0x555555);
			txtLabel.autoSize = TextFieldAutoSize.LEFT;
			txtLabel.text = _label;
			txtLabel.filters = [new BlurFilter(0, 0)];
			
			bg.width = txtLabel.width + (MIN_HORIZ_PADDING * 2);
			
			buttonMode = true;
			mouseChildren = false;
			filters = [bevelFilter, glowFilter, shadowFilter];
			
			addChild(bg);
			addChild(txtLabel);
			
			addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_UP, onRollOut);
			
			updateLayout();
		}
		
		public override function set width(val:Number):void
		{
			bg.width = val;
			updateLayout();
		}
		public override function get width():Number
		{
			return bg.width;
		}
		
		public override function set height(val:Number):void
		{
			bg.height = val;
			updateLayout();
		}
		public override function get height():Number
		{
			return bg.height;
		}
		
		public function get label():String
		{
			return _label;
		}
		public function set label(val:String):void
		{
			
		}
		
		public function get fontSize():Number
		{
			return _fontSize;
		}
		public function set fontSize(val:Number):void
		{
			
		}
		
		private function updateLayout():void
		{
			var newFontSize:Number = bg.height * FONT_SIZE_RATIO;
			txtLabel.setTextFormat(new TextFormat(DEFAULT_FONT, newFontSize));
			bg.width = txtLabel.width + (MIN_HORIZ_PADDING * 2)
			txtLabel.x = (bg.width / 2) - (txtLabel.textWidth / 2);
			txtLabel.y = (bg.height / 2) - (txtLabel.textHeight / 2);
		}

		private function onRollOut(e:MouseEvent):void 
		{
			bevelFilter.angle = 90;
			filters = [bevelFilter, glowFilter, shadowFilter];
		}
		
		private function onRollOver(e:MouseEvent):void 
		{
			
		}
		
		private function onMouseUp(e:MouseEvent):void 
		{
			
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			bevelFilter.angle = 270;
			filters = [bevelFilter, glowFilter, shadowFilter];
		}
	}
}