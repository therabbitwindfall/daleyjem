package com.daleyjem.as3
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	
	public class Shadows extends Sprite
	{
		private var objects:Array;
		private var clip:MovieClip;
		private var theStage:Stage;
				
		public function Shadows(_clip:MovieClip):void
		{
			clip = _clip;
			theStage = clip.stage;
			theStage.addEventListener(MouseEvent.MOUSE_MOVE, applyShadows);
			applyShadows();
		}
		
		private function applyShadows(e:MouseEvent = null):void
		{
			var count:Number = clip.numChildren;
			for (var objIndex:Number = 0; objIndex < count; objIndex++)
			{
				var obj:MovieClip = clip.getChildAt(objIndex) as MovieClip;
				var isMovieClip:Boolean = true;
				try
				{
					var tester:Number = obj.x;
				}
				catch (e)
				{
					isMovieClip = false;
				}
				if (isMovieClip == false) continue;
				var dx:Number = ((obj.x + (obj.width / 2)) + clip.x) - theStage.mouseX;
				var dy:Number = ((obj.y + (obj.height / 2)) + clip.y) - theStage.mouseY;

				var angle:Number = (180 * Math.atan(dy/dx)) / Math.PI;
				if(dx < 0){
					angle += 180;
				}
	
				var distance:Number = Math.sqrt(dy*dy + dx*dx)/10;
				var dropAlpha:Number = 10/distance;
				var blurX:Number = Math.abs(dx/20);
				var blurY:Number = Math.abs(dy/20);
	
				var drop:DropShadowFilter = new DropShadowFilter(distance, angle, 0, dropAlpha, blurX, blurY);
				obj.filters = [drop];
				
			}
		}
		
	}
}