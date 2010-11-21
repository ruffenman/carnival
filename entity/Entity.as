package carnival.entity 
{
	import flash.events.EventDispatcher;
	import carnival.service.ServiceManager;
	
	/**
	 * ...
	 * @author jcapote
	 */
	public class Entity extends EventDispatcher implements IEntity
	{		
		public function Entity() 
		{
			super();			
		}
		
		public function Init(... args) : void 
		{
			mDoesExist = true;
		}
		
		public function Update(pElapsedTime : Number, pTotalTime : Number) : void
		{
			
		}
		
		public function ShutDown() : void
		{
			
		}
		
		public function Destroy() : void
		{
			mDoesExist = false;
		}
		
		//accessors
		
		public function get doesExist() : Boolean
		{
			return mDoesExist;
		}
		
		public function get entityID() : int
		{
			return mID;
		}
		
		//internal members for use within package
		
		internal function SetEntityID(pID : int) : void
		{
			mID = pID;
		}
		
		//private members
		
		private var mDoesExist : Boolean;
		private var mID : int;
	}

}