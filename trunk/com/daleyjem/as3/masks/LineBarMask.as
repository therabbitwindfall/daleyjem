package com.daleyjem.as3.masks
{
	import flash.display.Sprite;
	import flash.events.Event;
	import gs.easing.Linear;
	import gs.TweenLite;
	
	public class LineBarMask extends Sprite
	{
		private var lineCount:uint;
		private var _duration:Number;
		private var completeCount:uint = 0;
		
		public function LineBarMask(_width:Number, _height:Number, barHeight:Number, duration:Number):void
		{
			cacheAsBitmap = true;
			_duration = duration;
			lineCount = Math.ceil(_height / barHeight);
			for (var lineIndex:uint = 0; lineIndex < lineCount; lineIndex++)
			{
				var line:Sprite = new Sprite();
				line.graphics.beginFill(0xffffff, 1);
				line.graphics.drawRect(0, 0, _width, barHeight);
				line.graphics.endFill();
				line.y = lineIndex * barHeight;
				line.x = -line.width;
				addChild(line);
			}
		}
		
		public function start():void
		{
			for (var lineIndex:uint = 0; lineIndex < lineCount; lineIndex++)
			{
				var line:Sprite = getChildAt(lineIndex) as Sprite;
				var delay:Number = Math.random() * _duration;
				TweenLite.to(line, _duration, { x:0, delay:delay, ease:Linear.easeNone, onComplete:incrementComplete} );
			}
		}
		
		private function incrementComplete():void
		{
			completeCount++;
			if (completeCount == lineCount)
			{
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
	}
}