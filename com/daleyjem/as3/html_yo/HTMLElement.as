package com.daleyjem.as3.HTML
{
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	public class HTMLElement extends Sprite
	{
		public var htmlNode:XML;
		public var props:Object = new Object();
		public var ignorePosition:Boolean = false;
		
		public function HTMLElement(_htmlNode:XML):void
		{
			htmlNode = _htmlNode;
			
			var currY:Number = 0;
			for each (var childNode:XML in htmlNode.children())
			{
				var childElement:HTMLElement = addItem(childNode);
				if (childElement == null) continue;
				
				addChild(childElement);
				childElement.applyAttributes();
				
				if (!childElement.ignorePosition)
				{
					childElement.y += currY;
					currY = childElement.y + childElement.height;
				}	
			}
		}
		
		private function addItem(_htmlNode:XML):HTMLElement
		{
			if (_htmlNode.name() == null) return null;
			//trace(_htmlNode.name());
			switch (_htmlNode.name().toString())
			{
				case "div":
					return new Div(_htmlNode);
					break;
				case "img":
					return new Img(_htmlNode);
					break;
				case "p":
					return new P(_htmlNode);
					break;
			}
			
			return new HTMLElement(_htmlNode);
		}
		
		public function applyAttributes():void
		{
			var _alpha:Number = 0;
			var bgColor:Number = 0;
			var _width:Number = width;
			var _height:Number = height;

			if (htmlNode.@bgColor.length() > 0)
			{
				_alpha = 1;
				bgColor = parseInt(htmlNode.@bgColor.toString().split("#").join(""), 16);
			}
			if (htmlNode.@bgGradient.length() > 0)
			{
				_alpha = 1;
				var bgGradVal:String = htmlNode.@bgGradient.toString();
				var bgGradColors:Array = bgGradVal.substr(bgGradVal.indexOf("(") + 1).split(")").join("").split("#").join("").split(",");
				for (var i:uint = 0; i < bgGradColors.length; i++)
				{
					bgGradColors[i] = parseInt(bgGradColors[i], 16);
				}
			}
			if (htmlNode.@width.length() > 0) _width = Number(htmlNode.@width);
			if (htmlNode.@height.length() > 0) _height = Number(htmlNode.@height);
			
			if (bgGradVal != null)
			{
				var matr:Matrix = new Matrix();
				matr.createGradientBox(_width, _height);
				graphics.beginGradientFill(GradientType.LINEAR, bgGradColors, [1, 1], [0, 255], matr);
			}
			else
			{
				graphics.beginFill(bgColor, _alpha);
			}
			graphics.drawRect(0, 0, _width, _height);
			graphics.endFill();
			
			if (htmlNode.@marginLeft.length() > 0) x += Number(htmlNode.@marginLeft);
			if (htmlNode.@marginTop.length() > 0) y += Number(htmlNode.@marginTop);
			
			if (htmlNode.@x.length() > 0)
			{
				ignorePosition = true;
				x = Number(htmlNode.@x);
			}
			
			if (htmlNode.@y.length() > 0)
			{
				ignorePosition = true;
				y = Number(htmlNode.@y);
			}
			
			if (htmlNode.@align.length() > 0)
			{
				switch (htmlNode.@align.toString())
				{
					case "right":
						x = parent.width - width;
						trace(this, parent.width);
						break;
				}
			}
		}
	}
}