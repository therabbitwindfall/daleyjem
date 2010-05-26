package 
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	public class BitmapComparison
	{
		public function BitmapComparison():void	{}
		
		/**
		 * Compares the BitmapData of 2 DisplayObjects (usually images) and returns a percentage of similarity.
		 * Process converts bitmap to black and white
		 * 
		 * @param	bitmap1		<DisplayObject> First bitmap to compare
		 * @param	bitmap2		<DisplayObject> Second bitmap to compare
		 * @param	cropEdges	<Boolean> Converted white edges are cropped for better alignment on differing aspect ratios. 
		 * @return				<Number> Percentage of similar pixel values
		 */
		public static function compare(bitmap1:DisplayObject, bitmap2:DisplayObject, cropEdges:Boolean = false):Number
		{
			var matrix1:Matrix = new Matrix();
			var matrix2:Matrix = new Matrix();
			
			if (bitmap1.width > bitmap2.width)
			{
				bitmap1.width	= bitmap2.width;
				bitmap1.height	= bitmap2.height;
				matrix1.scale(bitmap1.scaleX, bitmap1.scaleY);
			}
			else
			{
				bitmap2.width 	= bitmap1.width;
				bitmap2.height	= bitmap1.height;
				matrix2.scale(bitmap2.scaleX, bitmap2.scaleY);
			}
			
			var matchedPixels:Number = 0;
			var totalPixels:Number = bitmap1.width * bitmap1.height;
			
			var bitmapData1:BitmapData = new BitmapData(bitmap1.width, bitmap1.height, false);
			bitmapData1.draw(bitmap1, matrix1);
			bitmapData1.threshold(bitmapData1, new Rectangle(0, 0, bitmapData1.width, bitmapData1.height), new Point(0, 0), ">", 0xFF808080, 0xFFFFFFFF, 0xFFFFFFFF);
			bitmapData1.threshold(bitmapData1, new Rectangle(0, 0, bitmapData1.width, bitmapData1.height), new Point(0, 0), "<=", 0xFF808080, 0xFF000000, 0xFFFFFFFF);
			
			var bitmapData2:BitmapData = new BitmapData(bitmap2.width, bitmap2.height, false);
			bitmapData2.draw(bitmap2, matrix2);
			bitmapData2.threshold(bitmapData2, new Rectangle(0, 0, bitmapData2.width, bitmapData2.height), new Point(0, 0), ">", 0xFF808080, 0xFFFFFFFF, 0xFFFFFFFF);
			bitmapData2.threshold(bitmapData2, new Rectangle(0, 0, bitmapData2.width, bitmapData2.height), new Point(0, 0), "<=", 0xFF808080, 0xFF000000, 0xFFFFFFFF);
			
			var hCount:Number = bitmap1.height;
			var wCount:Number = bitmap1.width;
			
			for (var heightIndex:Number = 0; heightIndex < hCount; heightIndex++)
			{
				for (var widthIndex:Number = 0; widthIndex < wCount; widthIndex++)
				{
					var colorVal1:Number = bitmapData1.getPixel(widthIndex, heightIndex);
					var colorVal2:Number = bitmapData2.getPixel(widthIndex, heightIndex);
					
					if (colorVal1 == colorVal2)
					{
						matchedPixels++;
					}
				}
			}
			
			return matchedPixels / totalPixels;
		}
		
	}
}