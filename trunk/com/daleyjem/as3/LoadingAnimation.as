package
{
	import flash.display.MovieClip;
	import fl.motion.Color;
	
	public class LoadingAnimation extends MovieClip
	{
		public function LoadingAnimation(color:Number = 0x000000):void
		{
			var loadColor:Color = new Color();
			loadColor.setTint(color, 1);
			this.transform.colorTransform = loadColor;
		}
	}
}