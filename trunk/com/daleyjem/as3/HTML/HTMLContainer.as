package com.daleyjem.as3.HTML
{
	import flash.display.Sprite;
	
	public class HTMLContainer extends Sprite
	{
		public var node:XML;
		public var props:Object = new Object();
		
		public function HTMLContainer(_node:XML):void
		{
			node = _node;
			for each (var childNode:XML in node.children())
			{
				
			}
		}
	}
}