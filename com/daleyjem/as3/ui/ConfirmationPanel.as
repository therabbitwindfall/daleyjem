package com.daleyjem.as3.ui
{
	import com.daleyjem.as3.ui.GenericButton;
	import com.daleyjem.as3.utils.DisplayTools;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	
	[Event(name = "ok", type = "com.daleyjem.as3.ui.ConfirmationPanelEvent")]
	[Event(name = "cancel", type = "com.daleyjem.as3.ui.ConfirmationPanelEvent")]
	public class ConfirmationPanel extends MovieClip
	{
		private var overlay:Sprite;
		private var dropShadow:DropShadowFilter;
		private var buttonSpacing:Number = 35;
		private var type:String;
		private var _stageWidth:uint;
		private var _stageHeight:uint;
		
		public static const OK:String			= "ok";
		public static const OK_CANCEL:String	= "ok_cancel";
		
		public var title_txt:TextField;
		public var dialog_txt:TextField;
		public var buttonContainer_mc:MovieClip;
		
		public function ConfirmationPanel(_title:String = "Please Confirm", _dialog:String = "", _type:String = "ok_cancel", stageWidth:uint = 0, stageHeight:uint = 0):void
		{
			title_txt = getChildByName("title_txt") as TextField;
			dialog_txt = getChildByName("dialog_txt") as TextField;
			buttonContainer_mc = getChildByName("buttonContainer_mc") as MovieClip;
			
			_stageWidth = stageWidth;
			_stageHeight = stageHeight;
			
			visible = false;
			dropShadow = new DropShadowFilter(2, 45, 0, .2, 2, 2);
			filters = [dropShadow];
			
			removeCurrentButtons();
			
			title = _title;
			dialog = _dialog;
			type = _type;
			
			switch (type)
			{
				case OK_CANCEL:
					buildOkCancel();
					break;
				case OK:
					buildOk();
					break;
			}
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function get title():String
		{
			return title_txt.htmlText;
		}
		public function set title(value:String):void
		{
			title_txt.htmlText = value;
		}
		
		public function get dialog():String
		{
			return dialog_txt.htmlText;
		}
		public function set dialog(value:String):void
		{
			dialog_txt.htmlText = value;
		}
		
		private function removeCurrentButtons():void
		{
			var childCount:Number = buttonContainer_mc.numChildren;
			for (var childIndex:Number = 0; childIndex < childCount; childIndex++)
			{
				buttonContainer_mc.removeChildAt(0);
			}
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			overlay = new Sprite();
			overlay.graphics.beginFill(0, .5);
			overlay.graphics.drawRect(0, 0, _stageWidth, _stageHeight);
			overlay.graphics.endFill();
			
			stage.addChildAt(overlay, stage.numChildren - 1);
			stage.setChildIndex(this, stage.numChildren - 1);

			DisplayTools.centerWithin(this, _stageWidth, _stageHeight);
			
			visible = true;
		}
		
		private function buildOk():void
		{
			var btnOK:GenericButton = new GenericButton();
			btnOK.label = "OK";
			buttonContainer_mc.addChild(btnOK);
			
			buttonContainer_mc.x = (width / 2) - (buttonContainer_mc.width / 2);
			
			btnOK.addEventListener(MouseEvent.CLICK, onOkClick);
		}
		
		private function buildOkCancel():void
		{
			var currX:Number = 0;
			var btnOK:GenericButton = new GenericButton();
			btnOK.label = "OK";
			btnOK.x = currX;
			buttonContainer_mc.addChild(btnOK);
			currX += buttonSpacing + btnOK.width;
			var btnCancel:GenericButton = new GenericButton();
			btnCancel.label = "Cancel";
			btnCancel.x = currX;
			buttonContainer_mc.addChild(btnCancel);
			buttonContainer_mc.x = (width / 2) - (buttonContainer_mc.width / 2);
			
			btnCancel.addEventListener(MouseEvent.CLICK, onCancelClick);
			btnOK.addEventListener(MouseEvent.CLICK, onOkClick);
		}
		
		private function onOkClick(e:MouseEvent):void 
		{
			dispatchEvent(new ConfirmationPanelEvent(ConfirmationPanelEvent.OK));
			dispose();
		}
		
		private function onCancelClick(e:MouseEvent):void 
		{
			dispatchEvent(new ConfirmationPanelEvent(ConfirmationPanelEvent.CANCEL));
			dispose();
		}
		
		private function dispose():void
		{
			stage.removeChild(overlay);
			parent.removeChild(this);
			dispatchEvent(new Event(Event.CLOSE));
		}
	}
}