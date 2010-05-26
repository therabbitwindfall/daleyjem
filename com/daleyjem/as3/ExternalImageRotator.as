package com.daleyjem.as3
{
	import flash.display.Sprite;
	
	public class ExternalImageRotator extends Sprite
	{
		private var _transition:ExternalImageRotatorTransition;
		
		public var images:Array; 
		
		public function ExternalImageRotator():void
		{
			
		}
		
		public function get transition():ExternalImageRotatorTransition
		{
			return _transition;
		}
		public function set transition(value:ExternalImageRotatorTransition):void
		{
			_transition = value;
		}
		
		public function addImage(image:ExternalImage):void
		{
			image.alpha = 0;
			addChild(image);
			images.push(image);
		}
		
		public function start():void
		{
			transition.start();
		}
		
		public function gotoPath(imagePath:String):void
		{
			transition.gotoPath(imagePath);
		}
	}
}