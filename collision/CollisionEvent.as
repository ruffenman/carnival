package collision 
{
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author jcapote
	 */
	public class CollisionEvent extends Event
	{		
		//Array of CollisionEvent types that correspond to the collision groups
		public static const GROUP_EVENTS : Array = 
		[  
			"CollisionGroup0Event",
			"CollisionGroup1Event",
			"CollisionGroup2Event",
			"CollisionGroup3Event",
			"CollisionGroup4Event",
			"CollisionGroup5Event",
			"CollisionGroup6Event",
			"CollisionGroup7Event"			
		];
		
		public static const WALL_EVENT : String = "WallCollisionEvent";
		
		/**
		 * Creates a new collision event
		 * @param	type The type of collision event (group)
		 * @param	pCollider The ICollider initiating collision
		 * @param	pCollidee The ICollider being collided with
		 * @param	pNormal The normal vector of the collision with magnitude of penetration
		 * @param	pGroup The collision group flag constant
		 * @param	bubbles
		 * @param	cancelable
		 */
		public function CollisionEvent(type:String, pCollider : ICollider, pCollidee : ICollider, 
			pNormal : Point, pGroup : int, bubbles:Boolean = false, cancelable:Boolean = false) 
		{
			super(type, bubbles, cancelable);
			
			mCollider = pCollider;
			mCollidee = pCollidee;
			mGroup = pGroup;				
		}
		
		/**
		 * The ICollider that initiated the collision
		 */
		public function get Collider() : ICollider
		{
			return mCollider;
		}
		
		/**
		 * The ICollider who was collided with
		 */
		public function get Collidee() : ICollider
		{
			return mCollidee;
		}
		
		/**
		 * Returns an enumeration for the collision group constant from CollisionGroups
		 */
		public function get CollisionGroup() : int
		{
			return mGroup;
		}
		
		/**
		 * Returns the direction vector of the collision with a magnitude of the the collider's 
		 * 	penetration into the collidee
		 */
		public function get CollisionNormal() : Point
		{
			return mNormal;
		}
		
		private var mCollider : ICollider;
		private var mCollidee : ICollider;
		private var mGroup : int;
		private var mNormal : Point;
	}

}