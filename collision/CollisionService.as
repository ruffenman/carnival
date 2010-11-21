package collision 
{
	import constants.GameplayConstants;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import service.Service;
	
	/**
	 * Allows implementers of the ICollider interface to register themselves in collision groups
	 * 	as well as add event listeners for collision events on specific collision groups. Also
	 * 	allows for setting interaction between groups
	 * @author jcapote
	 */
	public class CollisionService extends Service
	{			
		public function CollisionService() 
		{
			super();
			
			mGroups = new Array();
			mGroupCollidesWithFlags = new Array();
			
			for (var i : int = 0; i < CollisionGroups.NUM_GROUPS; ++i)
			{
				mGroups.push(new Array());
				mGroupCollidesWithFlags.push(0 as int);
			}
			
			mToDispatch = new Array();	
		}
		
		override public function Init():void 
		{
			super.Init();
		}
		
		override public function Update(pElapsedTime : Number, pTotalTime : Number) : void
		{	
			super.Update(pElapsedTime, pTotalTime);
			
			//create any new collision events
			
			UpdateBoxColliders();
			
			//dispatch any events
			DispatchCollisionEvents();
		}
		
		override public function ShutDown() : void
		{
			super.ShutDown();
			
			for each(var group : Array in mGroups)
			{
				group.splice(0);
			}
			
			mGroups.splice(0);
			
			mToDispatch.splice(0);
		}
		
		/**
		 * Sets the groups that one group collides with
		 * @param	pGroupFlags Flags of the groups to set collides-with flags for
		 * @param	pCollidesWithFlags Flags of groups that should be collided with
		 */
		public function SetCollisionGroupFlags(pGroupFlags : int, pCollidesWithFlags : int) : void
		{
			var mask : int = 1;
			
			for (var i : int = 0; i < CollisionGroups.NUM_GROUPS; ++i)
			{
				if (mask & pGroupFlags)
				{
					mGroupCollidesWithFlags[i] = pCollidesWithFlags;
				}
				
				mask = mask << 1;
			}
		}
		
		/**
		 * Register a collider in collision group(s)
		 * @param	pCollider The Collider to register
		 * @param	pCollisionGroupFlags The flags for the collision groups to be a part of
		 */
		public function RegisterCollider(pCollider : ICollider, pCollisionGroupFlags : int)
		{
			var mask : int = 1;
			
			for (var i : int = 0; i < CollisionGroups.NUM_GROUPS; ++i)
			{
				if (mask & pCollisionGroupFlags)
				{
					(mGroups[i] as Array).push(pCollider);
				}
				
				mask = mask << 1;
			}
		}
		
		/**
		 * Removes a collider from collision group(s)
		 * @param	pCollider The Collider to unregister
		 * @param	pCollisionGroupFlags The flags for the collision groups to be removed from
		 */
		public function UnregisterCollider(pCollider : ICollider, pCollisionGroupFlags : int)
		{
			var mask : int = 1;			
			
			for (var i : int = 0; i < CollisionGroups.NUM_GROUPS; ++i)
			{
				var group : Array = mGroups[i];
				
				if (mask & pCollisionGroupFlags)
				{
					for (var index:int = 0; index < group.length; ++index)
					{
						if (group[index] == pCollider)
						{
							group.splice(index, 1);
							
							break;
						}
					}
				}
				
				mask = mask << 1;
			}
		}	
		
		/**
		 * Set the DisplayObject that represents the terrain
		 * @param	pWall
		 */
		public function SetTerrain(pTerrain : DisplayObject) : void
		{
			mTerrain = pTerrain;
		}
		
		/**
		 * Checks if a terrain collider's footprint collides with the terrain
		 * @param	pCollider The ICollider to be checked
		 */
		public function CheckTerrainCollider(pCollider : ICollider) : Boolean
		{
			var colliderBox : CollisionBox = pCollider.collisionBox;
			var colliderRect : Rectangle = colliderBox.getRect(MainStage.GetStage());
			var leftFootPoint : Point = new Point(colliderRect.x, colliderRect.bottom);
			var midFootPoint : Point 
				= new Point(colliderRect.x + 0.5 * colliderRect.width, colliderRect.bottom);
			var rightFootPoint : Point = colliderRect.bottomRight;
			
			var doesCollide : Boolean
				= mTerrain.hitTestPoint(leftFootPoint.x, leftFootPoint.y, true)
					|| mTerrain.hitTestPoint(midFootPoint.x, midFootPoint.y, true)
					|| mTerrain.hitTestPoint(rightFootPoint.x, rightFootPoint.y, true);
			
			return doesCollide;
		}
		
		public function UpdateBoxColliders() : void
		{
			var colliderGroupNum : int = 0;
			
			//create any new collision events from box colliders
			
			//for each collision group of colliders
			for each(var colliderGroup : Array in mGroups)
			{
				var mask : int = 1;
				var collideeGroupNum : int = 0;
				
				//for each collision group of potential collidees
				for each(var collideeGroup : Array in mGroups)
				{
					//if the collider group collides with the collidee group
					if (mask & mGroupCollidesWithFlags[colliderGroupNum])
					{
						//check for collisions between IColliders in the two groups
						for (var i : int = 0; i < colliderGroup.length; ++i)
						{
							for (var j : int = 0; j < collideeGroup.length; ++j)
							{
								//set collider variables
								var collider : ICollider = colliderGroup[i];
								var collidee : ICollider = collideeGroup[j];
								
								//get distance vector from collider to collidee
								var normal : Point 
									= collidee.position.subtract(collider.position);
								
								//get root collision boxes
								var colliderBox : CollisionBox = collider.collisionBox;
								var collideeBox : CollisionBox = collidee.collisionBox;							
								
								//get rectangles in world-space
								var colliderRect : Rectangle 
									= colliderBox.getRect(MainStage.GetStage());
								
								var collideeRect : Rectangle
									= colliderBox.getRect(MainStage.GetStage());							
								
								//if colliders intersect
								if (collideeRect.intersects(colliderRect))
								{									
									//create new collision event
									mToDispatch.push(
										new CollisionEvent(
											CollisionEvent.GROUP_EVENTS[collideeGroupNum],
											collider, 
											collidee, 
											normal,
											(1 << colliderGroupNum)
										)
									);
								}
							}
						}
					}
					
					mask = mask << 1;
					++collideeGroupNum;
				}
				
				++colliderGroupNum;
			}
		}
		
		//private members
		
		//helpers
		
		private function DispatchCollisionEvents() : void
		{		
			//for all collision events to dispatch
			for (var k : int = mToDispatch.length - 1; k >= 0; --k)
			{
				//pop event from list
				var toDispatch : CollisionEvent = mToDispatch.pop();
				
				//have collidee dispatch event
				toDispatch.Collidee.dispatchEvent(toDispatch);
			}
		}
		
		//member variables
		
		private var mGroups : Array;
		private var mToDispatch : Array;
		private var mGroupCollidesWithFlags : Array;
		private var mTerrain : DisplayObject;
	}

}