package physics 
{
	import collision.CollisionService;
	import constants.GameplayConstants;
	import entity.EntityRef;
	import flash.geom.Point;
	import service.Service;
	import service.ServiceManager;
	
	/**
	 * ...
	 * @author jcapote
	 */
	public class PhysicsService extends Service 
	{		
		public function PhysicsService() 
		{
			super();
		}		
		
		override public function Init():void 
		{
			super.Init();
		}
		
		override public function StartService() : void 
		{
			super.StartService();
		}
		
		override public function PauseService() : void 
		{
			super.PauseService();
		}
		
		override public function ResumeService() : void 
		{
			super.ResumeService();
		}
		
		override public function StopService() : void 
		{
			super.StopService();
		}
		
		override public function Update(pElapsedTime:Number, pTotalTime:Number) : void 
		{
			super.Update(pElapsedTime, pTotalTime);
			
			//for each physics object
			for each(var collider : IPhysicsCollider in mPhysicsColliders)
			{
				//apply gravitational forces' acceleration
				
				//if object is grounded
				if (collider.isGrounded)
				{
					collider.acceleration.y += 0;
				}
				else //object is not grounded
				{					
					collider.acceleration.y += GameplayConstants.GRAVITY;
				}
				
				//apply force
				
				var impulse : Point = collider.acceleration.add(Point());
				impulse.normalize(pElapsedTime);
				
				//add impulse to velocity
				collider.velocity.x += impulse.x;
				collider.velocity.y += impulse.y;
				
				//clear out force acceleration
				collider.acceleration.x = 0;
				collider.acceleration.y = 0;
				
				//get distance to move
				var distance : Point = collider.velocity.add(Point());
				distance.normalize(pElapsedTime);
				
				//move distance
				collider.position.x += distance.x;
				collider.position.y += distance.y;
				
				var colliSvc : CollisionService
					= ServiceManager.GetInstance().GetService(CollisionService) as CollisionService;
				
				//if collider is now colliding with terrain, undo movement
				if (colliSvc.CheckTerrainCollider(collider))
				{
					collider.position.x -= distance.x;
					collider.position.y -= distance.y;
				}
			}
		}
		
		override public function ShutDown() : void 
		{
			super.ShutDown();
		}
		
		public function RegisterPhysicsCollider(pNewCollider : IPhysicsCollider) : void
		{
			mPhysicsColliders.push(pNewCollider);
		}
		
		private var mPhysicsColliders : Array;
	}

}