package carnival.util 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author jcapote
	 */
	public class DisplayUtils
	{		
		public static function MovieClipIsLoaded(pClip : MovieClip) : Boolean
		{
			var isLoaded : Boolean = true;
			
			if (pClip.framesLoaded < pClip.totalFrames)
			{
				isLoaded = false;
			}
			
			for (var i : int = 0; i < pClip.numChildren; ++i)
			{
				var object : DisplayObject = pClip.getChildAt(i);
				
				if (object is MovieClip)
				{
					isLoaded = isLoaded && MovieClipIsLoaded(object as MovieClip);
				}
			}
			
			return isLoaded;
		}		
	}

}