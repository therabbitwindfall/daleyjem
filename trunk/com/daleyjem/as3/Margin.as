package com.daleyjem.as3
{
	public class Margin
	{
		private var _top:Number;
		private var _right:Number;
		private var _bottom:Number;
		private var _left:Number;
		
		/**
		 * Creates an array for holding numeric margin position data of an object.
		 * 
		 * @param	topMargin		<Number> The top margin.
		 * @param	rightMargin		<Number> The right margin.
		 * @param	bottomMargin	<Number> The bottom margin.
		 * @param	leftMargin		<Number> The left margin.
		 */
		public function Margin(topMargin:Number = 0, rightMargin:Number = 0, bottomMargin:Number = 0, leftMargin:Number = 0):void
		{
			top = topMargin;
			right = rightMargin;
			bottom = bottomMargin;
			left = leftMargin;
		}
		
		/**
		 * Gets or sets the top margin.
		 */
		public function get top():Number
		{
			return _top;
		}
		public function set top(value:Number):void
		{
			_top = value;
		}
		
		/**
		 * Gets or sets the right margin.
		 */
		public function get right():Number
		{
			return _right;
		}
		public function set right(value:Number):void
		{
			_right = value;
		}
		
		/**
		 * Gets or sets the bottom margin.
		 */
		public function get bottom():Number
		{
			return _bottom;
		}
		public function set bottom(value:Number):void
		{
			_bottom = value;
		}
		
		/**
		 * Gets or sets the left margin.
		 */
		public function get left():Number
		{
			return _left;
		}
		public function set left(value:Number):void
		{
			_left = value;
		}
	}
}