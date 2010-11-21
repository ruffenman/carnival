package carnival.ui 
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import carnival.service.Service;
	
	/**
	 * ...
	 * @author jcapote
	 */
	public class InputService extends Service
	{		
		public function InputService() 
		{
			super();
			
			mMousePos = new Point();
			mKeys = new Object();
			
			InputService.SetStage(MainManager.GetStage());
		}
		
		public static function SetStage(pStage : Stage) : void
		{
			sStage = pStage;
		}
		
		override public function StartService() : void 
		{
			super.StartService();
			
			if (sStage == null)
			{
				throw new Error("Tried to start input service before setting stage");
			}
			
			sStage.addEventListener(KeyboardEvent.KEY_DOWN, OnKeyDown);
			sStage.addEventListener(KeyboardEvent.KEY_UP, OnKeyUp);
		}
		
		override public function PauseService() : void 
		{
			super.PauseService();
			
			sStage.removeEventListener(KeyboardEvent.KEY_DOWN, OnKeyDown);
			sStage.removeEventListener(KeyboardEvent.KEY_UP, OnKeyUp);
		}
		
		override public function ResumeService() : void 
		{
			super.ResumeService();
			
			sStage.addEventListener(KeyboardEvent.KEY_DOWN, OnKeyDown);
			sStage.addEventListener(KeyboardEvent.KEY_UP, OnKeyUp);
		}
		
		override public function StopService() : void 
		{
			super.StopService();
			
			sStage.removeEventListener(KeyboardEvent.KEY_DOWN, OnKeyDown);
			sStage.removeEventListener(KeyboardEvent.KEY_UP, OnKeyUp);
		}
		
		override public function Update(pElapsedTime:Number, pTotalTime:Number):void 
		{
			super.Update(pElapsedTime, pTotalTime);
			
			//keep keyboard focus on stage
			sStage.stage.focus = sStage;
			
			//update mouse position
			mMousePos.x = sStage.mouseX;
			mMousePos.y = sStage.mouseY;
		}
		
		public function CheckKey(pKeyCode : uint) : Boolean
		{
			var toReturn : Boolean = false;
			
			if (mKeys.hasOwnProperty(pKeyCode))
			{
				toReturn = mKeys[pKeyCode];
			}
			
			return toReturn;
		}
		
		/**
		 * Clear any keys that have been set
		 */
		public function ResetKeys() : void
		{
			
		}
		
		//accessors
		
		public function get mousePosition() : Point
		{
			return new Point(mMousePos.x, mMousePos.y);
		}
		
		//private members
		
		//handlers
		
		private function OnKeyDown(pEvent : KeyboardEvent) : void
		{
			mKeys[pEvent.keyCode] = true;
			
			dispatchEvent(new KeyboardEvent(pEvent.keyCode.toString(), pEvent.bubbles, pEvent.cancelable, 
				pEvent.charCode, pEvent.keyCode, pEvent.keyLocation, pEvent.ctrlKey, pEvent.altKey, 
				pEvent.shiftKey));
		}
		
		private function OnKeyUp(pEvent : KeyboardEvent) : void
		{
			mKeys[pEvent.keyCode] = false;
			
			dispatchEvent(pEvent);
		}
		
		//member variables
		
		private static var sStage : Stage;
		
		//key flags
		private var mKeys : Object;
		private var mMousePos : Point;
	}

}