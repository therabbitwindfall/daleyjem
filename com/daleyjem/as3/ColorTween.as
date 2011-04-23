﻿package com.daleyjem.as3
{
	import flash.events.EventDispatcher;
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	import flash.events.Event;
	import com.daleyjem.as3.ColorTweenEvent;
	
	[Event(name="progress", type="com.daleyjem.as3.ColorTweenEvent")]
	[Event(name="complete", type="com.daleyjem.as3.ColorTweenEvent")]
	public class ColorTween extends EventDispatcher
	{		
		public var color:Number;
		public var frameDuration:Number;
		
		private var theClip:DisplayObject;
		private var startColor:Array = new Array();
		private var endColor:Array = new Array();
		private var currFrame:Number = 0;
		private var durFrame:Number = 0;
		private var _pSeconds:Number;
	
		public function ColorTween(pTheClip:DisplayObject, pStartColor:Number, pEndColor:Number, pSeconds:Number):void
		{
			_pSeconds = pSeconds;
			color = pStartColor;
			theClip = pTheClip;
			startColor = HexToRGB(pStartColor);
			endColor = HexToRGB(pEndColor);
			
			if (pSeconds <= 0)
			{
				SetColor(pEndColor);
				return;
			}
			
			if (theClip.stage == null) 
			{
				theClip.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			}
			else
			{
				onAddedToStage();
			}
		}
		
		private function onAddedToStage(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			theClip.addEventListener(Event.ENTER_FRAME, incrementColor);
			durFrame = theClip.stage.frameRate * _pSeconds;
		}
		
		public function stop():void
		{
			if (theClip.hasEventListener(Event.ENTER_FRAME)) theClip.removeEventListener(Event.ENTER_FRAME, incrementColor); // incrementTimer.stop();
		}
		
		private function incrementColor(e:Event):void
		{
			currFrame++;
			
			dispatchEvent(new ColorTweenEvent("progress"));
			
			if (currFrame >= durFrame)
			{
				theClip.removeEventListener(Event.ENTER_FRAME, incrementColor);
				currFrame = durFrame;
				dispatchEvent(new ColorTweenEvent("complete"));
			}
			
			var framePercentage:Number = currFrame / durFrame;
			var rChange:Number = Math.round((endColor.r - startColor.r) * framePercentage);
			var gChange:Number = Math.round((endColor.g - startColor.g) * framePercentage);
			var bChange:Number = Math.round((endColor.b - startColor.b) * framePercentage);
			var newColor:Number = RGBToHex(startColor.r + rChange, startColor.g + gChange, startColor.b + bChange);
			
			SetColor(newColor);
		}
		
		public static function getColorInRangePercentage(_tempStartColor:Number, _tempEndColor:Number, _tempPercentage:Number):Number
		{
			var tempStartColor:Array = HexToRGB(_tempStartColor);
			var tempEndColor:Array = HexToRGB(_tempEndColor);
			var rChange:Number = Math.round((tempEndColor.r - tempStartColor.r) * _tempPercentage);
			var gChange:Number = Math.round((tempEndColor.g - tempStartColor.g) * _tempPercentage);
			var bChange:Number = Math.round((tempEndColor.b - tempStartColor.b) * _tempPercentage);
			var newColor:Number = RGBToHex(tempStartColor.r + rChange, tempStartColor.g + gChange, tempStartColor.b + bChange);
			
			return newColor;
		}
		
		private function SetColor(myNewColor:Number):void
		{
			var myCT:ColorTransform = theClip.transform.colorTransform;
			myCT.color = myNewColor;
			color = myNewColor;
			theClip.transform.colorTransform = myCT;
		}
		
		private static function HexToRGB(hex:Number):Array
		{
			var newHex:Array = new Array();
			newHex.r = (hex & 0xff0000) >> 16;
			newHex.g = (hex & 0x00ff00) >> 8;
			newHex.b = hex & 0x0000ff;
			return newHex;
		}
		
		private static function RGBToHex(r:Number, g:Number, b:Number):Number
		{
			return r << 16 ^ g << 8 ^ b;
		}
	}
}