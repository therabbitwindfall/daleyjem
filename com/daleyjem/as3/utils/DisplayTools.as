﻿package com.daleyjem.as3.utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	
	public class DisplayTools
	{
		/**
		 * Returns the x/y coordinate as a Point for a given
		 * DisplayObject with it's position relative to the stage.
		 * @param	displayObject	<DisplayObject> The DisplayObject.
		 * @return
		 */
		public static function getStagePoint(displayObject:DisplayObject):Point
		{
			var currX:Number = displayObject.x;
			var currY:Number = displayObject.y;
			
			if (displayObject.parent != displayObject.stage)
			{
				var point:Point = getStagePoint(displayObject.parent);
				currX += point.x;
				currY += point.y;
			}
			return new Point(currX, currY);
		}
		
		public static function drawBorder(sprite:Sprite):void
		{
			sprite.graphics.lineStyle(1);
			sprite.graphics.drawRect(0, 0, sprite.width, sprite.height);
		}
		
		public static function removeChildrenByType(object:DisplayObjectContainer, definitionName:String, callforward:Function = null, nullifyOnRemove:Boolean = false):void
		{
			var items:Array = new Array();
			var childCount:uint = object.numChildren;
			for (var childIndex:uint = 0; childIndex < childCount; childIndex++)
			{
				var child:DisplayObject = object.getChildAt(childIndex) as DisplayObject;
				if (getQualifiedClassName(child).indexOf(definitionName) > -1) items.push(child);
			}
			for each (var item:DisplayObject in items)
			{
				if (callforward != null) callforward(item);
				object.removeChild(item);
				if (nullifyOnRemove) item = null;
			}
		}
		
		public static function addChildToFit(parentObject:DisplayObjectContainer, childObject:DisplayObjectContainer):void
		{
			if (parentObject.width > parentObject.height)
			{
				childObject.height = (parentObject.width * childObject.height) / childObject.width;
				childObject.width = parentObject.width;
				childObject.y = -((childObject.height - parentObject.height) / 2)
			}
			else
			{
				childObject.width = (parentObject.height * childObject.width) / childObject.height;
				childObject.height = parentObject.height;
				childObject.x = -((childObject.width - parentObject.width) / 2)
			}
			
			parentObject.addChild(childObject);
		}
		
		public static function centerWithin(displayObject:DisplayObject, areaWidth:uint, areaHeight:uint):void
		{
			displayObject.x = (areaWidth / 2) - (displayObject.width / 2);
			displayObject.y = (areaHeight / 2) - (displayObject.height / 2);
		}
		
		public static function centerXWithin(displayObject:DisplayObject, areaWidth:uint):void
		{
			displayObject.x = (areaWidth / 2) - (displayObject.width / 2);
		}
		
		public static function centerYWithin(displayObject:DisplayObject, areaHeight:uint):void
		{
			displayObject.y = (areaHeight / 2) - (displayObject.height / 2);
		}
		
		public static function getPointAtScale(displayObject:DisplayObject, newScale:Number = 1):Point
		{
			var newX:Number = (displayObject.x + (displayObject.width / 2)) - ((displayObject.width * newScale) / 2);
			var newY:Number = (displayObject.y + (displayObject.height / 2)) - ((displayObject.height * newScale) / 2);
			return new Point(newX, newY);
		}
		
		public static function centerWithinSibling(displayObject:DisplayObject, siblingObject:DisplayObject):void
		{
			displayObject.x = (siblingObject.x + (siblingObject.width / 2)) - (displayObject.width / 2);
			displayObject.y = (siblingObject.y + (siblingObject.height / 2)) - (displayObject.height / 2);
		}
		
		/**
		 * Scales the DisplayObject to the first x/y edge with no bleed. Pillar- or letter-boxing will occur.
		 * @param	displayObject
		 * @param	maxWidth
		 * @param	maxHeight
		 */
		public static function scaleToFirstEdge(displayObject:DisplayObject, maxWidth:Number, maxHeight:Number):void
		{
			if (displayObject.width / displayObject.height > maxWidth / maxHeight)
			{
				var newHeight:Number = (maxWidth * displayObject.height) / displayObject.width;
				displayObject.width = maxWidth;
				displayObject.height = newHeight;
			}
			else
			{
				var newWidth:Number = (maxHeight * displayObject.width) / displayObject.height;
				displayObject.height = maxHeight;
				displayObject.width = newWidth;
			}
		}
		
		/**
		 * Scales the DisplayObject to the second x/y edge where the remainder bleeds outside.
		 * @param	displayObject
		 * @param	minWidth
		 * @param	minHeight
		 */
		public static function scaleToSecondEdge(displayObject:DisplayObject, minWidth:Number, minHeight:Number):void
		{
			if (displayObject.width / displayObject.height > minWidth / minHeight)
			{
				var newWidth:Number = (minHeight * displayObject.width) / displayObject.height;
				displayObject.height = minHeight;
				displayObject.width = newWidth;
			}
			else
			{
				var newHeight:Number = (minWidth * displayObject.height) / displayObject.width;
				displayObject.width = minWidth;
				displayObject.height = newHeight;
			}
		}
	}
}