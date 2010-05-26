package com.daleyjem.as3
{
	import fl.transitions.easing.None;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	public class ToolTip extends Sprite
	{
		private var _text:String;
		private var _textColor:Number;
		private var _borderColor:Number;
		private var _displayObject:DisplayObject;
		private var _bgColor:Number;
		
		private var container:Sprite;					// <Sprite> object that contains the border & background graphics
		private var textField:TextField;				// <TextField> object to apply Tooltip text to in constructor
		private var clip:DisplayObject;					// <DisplayObject> object to apply Tooltip behaviors to in constructor
		private var alphaTween:Tween;					// <Tween> object for controlling Tooltip's fading in/out
		private var timer:Number;						// <Number> object used for setTimeout calls
		private var textBlankFilter:DropShadowFilter;	// Fake filter (can be any filter type) for allowing non-embedded text to fade
		private var dropShadow:DropShadowFilter;		// Tooltip's dropshadow
		
		private const TIMER_OFFSET:Number = 500;		// Delay in milliseconds before Tooltip appears after mouseover
		private const FADE_DURATION:Number = .25;		// Time in seconds of fade in/out transition duration
		private const OFFSET_Y:Number = 25;				// Pixels added to mouseY position to place Tooltip
		private const OFFSET_X:Number = 15;				// Pixels added to mouseX position to place Tooltip
		private const VISIBLE_DURATION:Number = 5000;	// Time in milliseconds for Tooltip to stay visible while mouse is still over
		
		/**
		 * Creates a Windows-like Tooltip to appear when a user mouses over
		 * the indicated DisplayObject
		 * 
		 * @param	displayObject	<DisplayObject> The DisplayObject to activate ToolTip on mouseover
		 * @param	tipText			<String> HTML formatted text to display within the ToolTip
		 * @param	bgColor			<Number> Color for Tooltip background (default is vanilla colored)
		 * @param	borderColor		<Number> Color for 1-pixel border (default is black)
		 * @param	textColor		<Number> Color for Tooltip text (default is black)
		 */
		public function ToolTip(displayObject:DisplayObject, tipText:String, bgColor:Number = 0xffffcc, borderColor:Number = 0, textColor:Number = 0):void
		{
			_displayObject = displayObject;
			_text = tipText;
			_borderColor = borderColor;
			_textColor = textColor;
			_bgColor = bgColor;
			
			clip = displayObject;
			
			dropShadow = new DropShadowFilter(4, 45, 0, .4);
			textBlankFilter = new DropShadowFilter(0, 0, 0, 0);
			
			alpha = 0;
			visible = false;
			filters = [dropShadow];
			
			clip.stage != null ? clip.stage.addChild(this) : clip.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			clip.addEventListener(MouseEvent.ROLL_OVER, rollOver);
			clip.addEventListener(MouseEvent.ROLL_OUT, rollOut);
			
			renderTooltip();
		}
		
		public function get text():String
		{
			return _text;
		}
		public function set text(value:String):void
		{
			clear();
			_text = value;
			renderTooltip();
		}
		
		private function clear():void
		{
			var childCount:Number = numChildren;
			for (var childIndex:Number = 0; childIndex < childCount; childIndex++)
			{
				removeChildAt(0);
			}
		}
		
		private function renderTooltip():void
		{
			textField = new TextField();
			textField.wordWrap = false;
			textField.multiline = true;
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.htmlText = _text;
			textField.setTextFormat(new TextFormat("Arial", 11, _textColor));
			textField.filters = [textBlankFilter];
			
			container = new Sprite();
			container.graphics.lineStyle(1, _borderColor);
			container.graphics.beginFill(_bgColor);
			container.graphics.lineTo( 0, textField.height);
			container.graphics.lineTo( textField.width, textField.height);
			container.graphics.lineTo( textField.width, 0);
			container.graphics.lineTo( 0, 0);
			container.graphics.endFill();
			
			addChild(container);
			addChild(textField);
		}
		
		private function addedToStage(e:Event):void
		{
			clip.stage.addChild(this);
		}
		
		private function rollOver(e:MouseEvent):void
		{
			!visible ? timer = setTimeout(fadeIn, TIMER_OFFSET) : fadeIn();
		}
		
		private function rollOut(e:MouseEvent):void
		{
			if (visible) fadeOut();
			clearTimeout(timer);
		}
		
		private function fadeIn():void
		{
			stage.setChildIndex(this, stage.numChildren - 1);
			if (!visible)
			{
				(clip.stage.mouseX + width + OFFSET_X > clip.stage.stageWidth) ? (x = clip.stage.stageWidth - width) : (x = clip.stage.mouseX + OFFSET_X);
				(clip.stage.mouseY + height + OFFSET_Y > clip.stage.stageHeight) ? (y = clip.stage.stageHeight - height) : (y = clip.stage.mouseY + OFFSET_Y);
				trace(clip.stage.mouseX, clip.stage.mouseY);
				visible = true;
			}
			
			if (alphaTween != null)
			{
				alphaTween.removeEventListener(TweenEvent.MOTION_FINISH, hide);
				alphaTween.stop();
			}
			
			alphaTween = new Tween(this, "alpha", None.easeNone, this.alpha, 1, FADE_DURATION, true);
			timer = setTimeout(fadeOut, VISIBLE_DURATION);
		}
		
		private function fadeOut():void
		{
			if (alphaTween != null) alphaTween.stop();
			alphaTween = new Tween(this, "alpha", None.easeNone, this.alpha, 0, FADE_DURATION, true);
			alphaTween.addEventListener(TweenEvent.MOTION_FINISH, hide);
		}
		
		private function hide(e:TweenEvent):void
		{
			this.visible = false;
		}
	}
}