package carnival.service 
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	
	/**
	 * Service manager class. Registers service classes that are instantiated upon registration.
	 * 	They are stored and can be accessed by their service name which is a static String that
	 * 	should be overridden for each concrete service.
	 * @author jcapote
	 */
	public class ServiceManager extends EventDispatcher
	{		
		public function ServiceManager(target:IEventDispatcher = null) 
		{
			super(target);
			
			if (sInstance)
			{
				throw new Error("ServiceManager was instantiated incorrectly");
			}
			else
			{
				//construct members
				mServiceList = new Object();
			}
		}
		
		public static function CreateInstance() : void
		{
			if (sInstance == null)
			{
				sInstance = new ServiceManager();
			}
		}
		
		public static function GetInstance() : ServiceManager
		{
			return sInstance;
		}
		
		/**
		 * Initialized the service manager before it is used
		 */
		public function Init() : void
		{
			
		}
		
		/**
		 * Register a new service class that the service manager should manage
		 * @param	pServiceClass
		 */
		public function RegisterService(pServiceClass : Class) : void
		{	
			var baseName : String = getQualifiedSuperclassName(pServiceClass);
			
			if (baseName == "carnival.service::Service")
			{
				var serviceName : String = getQualifiedClassName(pServiceClass);
				
				var newService : Service = new pServiceClass();
				
				newService.Init();
				
				if (mServiceList[serviceName] != null)
				{
					throw new Error("Tried to register a service that has already been registered");
				}
				
				mServiceList[serviceName] = newService;
			}
			else
			{
				throw new Error("Tried to register an invalid class as a service" + pServiceClass);
			}
		}
		
		/**
		 * Get the instance of a registered service by Class
		 * @param	pServiceClass
		 * @return Reference to the service instance or null if it does not exist
		 */
		public function GetService(pServiceClass : Class) : Service
		{
			var serviceName : String = getQualifiedClassName(pServiceClass);
			
			return mServiceList[serviceName] as Service;
		}
		
		public function Update(pElapsedTime : Number, pTotalTime : Number) : void
		{
			for each(var currService : Service in mServiceList)
			{
				if (currService.serviceState == ServiceState.RUNNING)
				{
					currService.Update(pElapsedTime, pTotalTime);
				}
			}
		}
		
		public function ShutDown() : void
		{
			for(var serviceName : String in mServiceList)
			{
				//shut down service
				mServiceList[serviceName].ShutDown();
				
				//release memory
				delete(mServiceList[serviceName]);
			}
		}
		
		private static var sInstance : ServiceManager;
		
		private var mServiceList : Object;
	}

}