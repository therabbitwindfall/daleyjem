package com.daleyjem.as3.ui.nonflex
{
	import flash.display.LineScaleMode;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.BevelFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
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
		
		private static const CORNER_RADIUS:Number = 15;
		
		public function GenericButton(buttonLabel:String = "Click"):void
		{
			buttonMode = true;
			mouseChildren = false;
			
			_label = buttonLabel;
			
			bg = new Sprite();
			bg.graphics.beginFill(0xffffff, 1);
			bg.graphics.drawRoundRect(0, 0, 100, 100, CORNER_RADIUS, CORNER_RADIUS);
			bg.graphics.endFill();
			bg.scale9Grid = new Rectangle(CORNER_RADIUS, CORNER_RADIUS, bg.width - (CORNER_RADIUS * 2), bg.height - (CORNER_RADIUS * 2));
			
			bevelFilter = new BevelFilter();
			bevelFilter.blurX = bevelFilter.blurY = bevelFilter.distance = 20;
			bevelFilter.angle = 90;
			bevelFilter.strength = 0.25;
			var glowFilter:GlowFilter = new GlowFilter(0x000000, 0.4, 3, 3);
			var shadowFilter:DropShadowFilter = new DropShadowFilter();
			shadowFilter.blurX = shadowFilter.blurY = shadowFilter.distance = 5;
			shadowFilter.alpha = 0.4;
			
			filters = [bevelFilter, glowFilter, shadowFilter];
			
			addChild(bg);
			
			addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			addEventListener(MouseEvent.ROLL_OUT, onRollOut);
		}
		
		public override function set width(val:Number):void
		{
			bg.width = val;
			updateLayout();
		}
		
		public override function set height(val:Number):void
		{
			bg.height = val;
			updateLayout();
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
			
		}

		private function onRollOut(e:MouseEvent):void 
		{
			trace("roll out");
			bevelFilter.angle = 90;
		}
		
		private function onRollOver(e:MouseEvent):void 
		{
			trace("roll over");
			bevelFilter.angle = 270;
		}
	}
}