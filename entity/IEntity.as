package carnival.entity 
{
	import flash.events.IEventDispatcher;
	
	/**
	 * ...
	 * @author jcapote
	 */
	public interface IEntity extends IEventDispatcher
	{
		function Init(... args) : void;
		
		function Update(pElapsedTime : Number, pTotalTime : Number) : void;
		
		function ShutDown() : void;
		
		function Destroy() : void;
		
		//accessors
		
		function get doesExist() : Boolean;
		
		function get entityID() : int;
	}
	
}