package com.daleyjem.as3.ui.nonflex
{
	import com.daleyjem.as3.utils.DisplayTools;
	import flash.display.DisplayObject;
	import flash.display.LineScaleMode;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.filters.BlurFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * Generic prompt window with no controls
	 * @author Jeremy Daley
	 */
	public class Prompt extends Sprite
	{
		private var currY:Number = 0;
		private var txtTitle:TextField;
		private var bg:Sprite;
		private var titleBG:Sprite;
		private var stageOverlay:Sprite;
		private var maxWidth:Number = 100;
		private var maxHeight:Number = 100;
		
		private static const ITEM_SPACING:Number = 30;
		
		public function Prompt(title:String)
		{			
			stageOverlay = new Sprite();
			stageOverlay.graphics.beginFill(0, 0.5);
			stageOverlay.graphics.drawRect(0, 0, maxWidth, maxHeight);
			stageOverlay.graphics.endFill();
			
			bg = new Sprite();
			bg.graphics.lineStyle(1, 0x666666, 1, true, LineScaleMode.NONE);
			bg.graphics.beginFill(0xffffff, 1);
			bg.graphics.drawRect(0, 0, maxWidth, maxHeight);
			bg.graphics.endFill();
			
			txtTitle = new TextField();
			txtTitle.x = 10;
			txtTitle.autoSize = TextFieldAutoSize.LEFT;
			txtTitle.selectable = false;
			txtTitle.defaultTextFormat = new TextFormat("Arial", 40, 0x333333, true);
			txtTitle.filters = [new BlurFilter(0, 0)];
			txtTitle.text = title;
			
			titleBG = new Sprite();
			titleBG.graphics.lineStyle(1, 0x666666, 1, true, LineScaleMode.NONE);
			titleBG.graphics.beginFill(0xcccccc);
			titleBG.graphics.drawRect(0, 0, maxWidth, txtTitle.height + 5);
			titleBG.graphics.endFill();
			
			currY += titleBG.y + titleBG.height + ITEM_SPACING;
			
			addChild(bg);
			addChild(titleBG);
			addChild(txtTitle);
		}
		
		public function open(_stage:Stage):void
		{
			stageOverlay.width = _stage.stageWidth;
			stageOverlay.height = _stage.stageHeight;
			
			DisplayTools.centerWithin(this, _stage.stageWidth, _stage.stageHeight);
			
			_stage.addChild(stageOverlay);
			_stage.addChild(this);
		}
		
		public function close():void
		{
			stage.removeChild(stageOverlay);
			stage.removeChild(this);
		}
		
		public function addItem(item:DisplayObject):void
		{
			item.y = currY
			item.x = ITEM_SPACING;
			currY += item.height + ITEM_SPACING;
			addChild(item);
			
			if (item.width > maxWidth) maxWidth = item.width + (ITEM_SPACING * 2);
			maxHeight = currY;
			
			updateLayout();
		}
		
		public function setWidth(val:Number):void
		{
			
		}
		
		private function updateLayout():void
		{
			bg.width = maxWidth;
			bg.height = maxHeight;
			titleBG.width = maxWidth - 1;
		}
	}
}