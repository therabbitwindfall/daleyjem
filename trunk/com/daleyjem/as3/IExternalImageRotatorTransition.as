package com.daleyjem.as3
{
	import flash.display.Sprite;
	
	public interface IExternalImageRotatorTransition
	{
		public function start():void;
		public function next():void;
		public function previous():void;
		public function gotoPath(imagePath:String):void;
	}
}