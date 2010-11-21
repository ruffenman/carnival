package game 
{
	import collision.CollisionService;
	import entity.EntityService;
	import flash.events.EventDispatcher;
	import service.ServiceManager;
	import ui.InputService;
	
	/**
	 * ...
	 * @author JCapote
	 */
	public class Game extends EventDispatcher
	{
		public static const QUIT_GAME_EVENT : String = "Quit Game";
		
		public function Game() 
		{
			
		}
		
		public function Init() : void
		{			
			//create service manager
			ServiceManager.CreateInstance();
			
			var svcMgr : ServiceManager = ServiceManager.GetInstance();
			
			//create services
			svcMgr.RegisterService(EntityService);
			svcMgr.RegisterService(InputService);
			svcMgr.RegisterService(CollisionService);
		}
		
		public function Update(pElapsedTime : Number, pTotalTime : Number) : void
		{
			//update service manager
			ServiceManager.GetInstance().Update(pElapsedTime, pTotalTime);
		}
		
		public function ShutDown() : void
		{
			ServiceManager.GetInstance().ShutDown();
		}		
	}

}