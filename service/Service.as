package carnival.service 
{
	import flash.events.EventDispatcher;
	
	/**
	 * Base class for any service, should be treated as abstract. Services are expected to be
	 * 	initialized when registered and shut down when the service manager shuts down. They may be
	 * 	started, paused, and stopped as many times as needed as long as they are ready to be shut
	 * 	down when the service manager is shut down.
	 * @author jcapote
	 */
	public class Service extends EventDispatcher
	{		
		//public members	
		
		public function Service()
		{
			//update state
			mServiceState = ServiceState.PRE_INIT;
		}
		
		/**
		 * Initializes the service to be startable. Called when a service is registered.
		 */
		public function Init() : void
		{	
			var serviceMgr : ServiceManager = ServiceManager.GetInstance();
			
			for each(var serviceClass : Class in dependsOn)
			{
				if (serviceMgr.GetService(serviceClass) == null)
				{
					throw new Error("Tried to register a service before a depended upon service");
				}	
			}
			
			if (mServiceState != ServiceState.PRE_INIT)
			{
				throw new Error(
					"Tried to initialize a service that was unready for initialization"
				);
			}
			
			//update state
			mServiceState = ServiceState.INITIALIZED;
		}
		
		/**
		 * Updates the service if it is runnning
		 * @param	pElapsedTime
		 * @param	pTotalTime
		 */
		public function Update(pElapsedTime : Number, pTotalTime : Number) : void
		{
			if (mServiceState != ServiceState.RUNNING)
			{
				throw new Error("Tried to update an unstarted Service");
			}
		}
		
		/**
		 * Shut down the service. Called when the service manager is shut down.
		 */
		public function ShutDown() : void
		{
			//stop service if it is still running
			if (mServiceState == ServiceState.RUNNING)
			{
				StopService();
			}
			else if (mServiceState == ServiceState.PRE_INIT)
			{
				throw new Error("Tried to shut down a service that was not initialized");
			}
			
			//update state
			mServiceState = ServiceState.PRE_INIT;
		}
		
		/**
		 * Starts the service.
		 */
		public function StartService() : void
		{
			var serviceMgr : ServiceManager = ServiceManager.GetInstance();
			
			for each(var serviceClass : Class in dependsOn)
			{
				if (serviceMgr.GetService(serviceClass).serviceState != ServiceState.RUNNING)
				{
					throw new Error("Tried to start service before a depended upon service");
				}	
			}
			
			//throw error if service is not initialized or paused
			if (mServiceState != ServiceState.INITIALIZED)
			{
				throw new Error("Tried to start a service in an invalid state");
			}
			
			mServiceState = ServiceState.RUNNING;
		}
		
		/**
		 * Pause a service's updating
		 */
		public function PauseService() : void
		{
			//if service is running, put it in a paused state
			if (mServiceState == ServiceState.RUNNING)
			{
				mServiceState = ServiceState.PAUSED;
			}
			else
			{
				throw new Error("Tried to pause a service that wasn't running");
			}			
		}
		
		/**
		 * Resume service from pause
		 */
		public function ResumeService() : void
		{
			if (mServiceState != ServiceState.PAUSED)
			{
				throw new Error("Tried to resume a service that was not paused");
			}
			
			mServiceState = ServiceState.RUNNING;
		}
		
		/**
		 * Stop a service
		 */
		public function StopService() : void
		{
			//if service is running, stop it and reinitialize it
			if (mServiceState == ServiceState.RUNNING)
			{
				mServiceState = ServiceState.INITIALIZED;					
			}
			else
			{
				throw new Error("Tried to stop a service that wasn't running");
			}
		}
		
		//properties		
		
		/**
		 * Returns the current ServiceState of the Service
		 */
		public function get serviceState() : ServiceState
		{
			return mServiceState;
		}
		
		public function get dependsOn() : Array
		{
			return [];
		}
		
		//private members
		
		private var mServiceState : ServiceState;
	}
	
}