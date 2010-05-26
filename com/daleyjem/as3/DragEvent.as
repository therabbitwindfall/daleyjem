package com.daleyjem.as3
{
	import flash.events.Event;
	
	public final class DragEvent extends Event
	{
		public static const DRAG_PICKUP:String			= "dragPickup";
		public static const DRAG_DROP:String			= "dragDrop";
		public static const DROP_OUTSIDE_TARGET:String	= "dropOutsideTarget";
		public static const DROP_INSIDE_TARGET:String	= "dropInsideTarget";
		public static const DRAG:String					= "drag";
		
		public var draggableObject:DraggableObject;
		
		public function DragEvent(object:DraggableObject, type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			draggableObject = object;
			super(type, bubbles, cancelable);
		}
	}
}