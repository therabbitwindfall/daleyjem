package com.daleyjem.as3.ui.nonflex
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import com.daleyjem.as3.ui.nonflex.GenericButton;
	import flash.text.TextFormat;
	
	/**
	 * A login prompt
	 * @author Jeremy Daley
	 */
	public class LoginPrompt extends Prompt
	{
		public var userName:String;
		public var password:String;
		
		private var txtUser:TextField;
		private var txtPassword:TextField;
		private var btnSubmit:GenericButton;
		
		public function LoginPrompt()
		{
			super("Login");
			
			txtUser = new TextField();
			txtUser.borderColor = 0x666666;
			txtUser.border = true;
			txtUser.type = TextFieldType.INPUT;
			txtUser.defaultTextFormat = new TextFormat("Arial", 40, 0x333333);
			txtUser.width = 300;
			txtUser.height = txtUser.textHeight + 10;
			
			txtPassword = new TextField();
			txtPassword.borderColor = 0x666666;
			txtPassword.border = true;
			txtPassword.type = TextFieldType.INPUT;
			txtPassword.displayAsPassword = true;
			txtPassword.defaultTextFormat = new TextFormat("Arial", 40, 0x333333);
			txtPassword.width = 300;
			txtPassword.height = txtPassword.textHeight + 10;
			
			btnSubmit = new GenericButton("Submit");
			btnSubmit.addEventListener(MouseEvent.CLICK, onSubmitClick);
			btnSubmit.height = 80;
			
			addItem(txtUser);
			addItem(txtPassword);
			addItem(btnSubmit);
		}
		
		private function onSubmitClick(e:MouseEvent):void 
		{
			userName = txtUser.text;
			password = txtPassword.text;
			
			dispatchEvent(new Event(Event.CONNECT));
		}
	}
}