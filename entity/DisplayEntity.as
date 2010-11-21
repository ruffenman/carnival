package carnival.entity 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author jcapote
	 */
	public class DisplayEntity extends Entity implements IPlaceable
	{		
		public function DisplayEntity()
		{
			super();			
			
			mPosition = new Point();
		}
		
		/**
		 * Initializes a DisplayEntity with its displayobject class
		 * @param	...args [pAsset : Class (class that inherits from DisplayObject and represents
		 * 	the entity's asset)]
		 */
		override public function Init(...args) : void
		{
			super.Init();
			
			if (!args[0] is DisplayObject || !args[0] is Class)
			{
				throw new Error("Tried to initialize DisplayEntity with non DisplayObject");
			}
			
			mAssetClass = args[0] as Class;
			
			//create asset immediately
			CreateAsset();
		}
		
		override public function ShutDown():void 
		{
			super.ShutDown();
			
			if (mAsset.parent != null)
			{
				
				mAsset.parent.removeChild(mAsset);
			}
		}
		
		public function CreateAsset() : void
		{
			mAsset = new mAssetClass();	
		}
		
		public function SetVisible(visible:Boolean) : void
		{
			mAsset.visible = visible;
		}
		
		public function SetEnabled(enabled:Boolean) : void
		{			
			if (mAsset is DisplayObjectContainer)
			{
				(mAsset as DisplayObjectContainer).mouseEnabled = enabled;
				(mAsset as DisplayObjectContainer).mouseChildren = enabled;
			}
			
			if (mAsset is MovieClip)
			{
				(mAsset as MovieClip).enabled = enabled;
			}
		}
		
		/* IPlaceable interface */

		public function get position() : Point
		{
			var position : Point = mPosition.clone();
			
			return position;
		}
		
		public function set position(pPosition : Point) : void
		{			
			mPosition.x = pPosition.x;
			mPosition.y = pPosition.y;
			
			//change position of asset
			if (mAsset != null)
			{
				//if object is centered, center asset on position
				if (mCentered)
				{
					var assetRect : Rectangle = mAsset.getBounds(mAsset);					
					
					var offset : Point = new Point();
					offset.x = -(assetRect.width * 0.5) - assetRect.x;
					offset.y = -(assetRect.height * 0.5) - assetRect.y;
					
					//compensate for any scaling on the asset
					offset.x *= mAsset.scaleX;
					offset.y *= mAsset.scaleY;
					
					pPosition = pPosition.add(offset);
				}
				
				mAsset.x = pPosition.x;
				mAsset.y = pPosition.y;
			}
		}
		
		public function get asset() : DisplayObject
		{
			return mAsset;
		}
		
		public function get centered() : Boolean
		{
			return mCentered;
		}
		
		public function set centered(pCentered : Boolean) : void
		{
			mCentered = pCentered;
		}
		
		//private members
		
		//member variables
		
		private var mAsset : DisplayObject;
		private var mAssetClass : Class;
		private var mPosition : Point;
		private var mCentered : Boolean;
	}

}