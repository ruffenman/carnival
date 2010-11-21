package carnival.ui 
{
	import carnival.entity.DisplayEntity;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import carnival.util.JCTimer;
	
	/**
	 * ...
	 * @author jcapote
	 */
	public class PopUpEntity extends DisplayEntity
	{
		public static const EVENT_POP_UP_DESTROYED : String = "Pop-up Destroyed";
		
		public function PopUpEntity() 
		{
			super();
			
			mDisplayTimer = new JCTimer();
		}
		
		/**
		 * 
		 * @param	...args [pAsset : Class (class that inherits from DisplayObject and represents
		 * 	the entity's asset), pPopUpTime : Number = -1(number of seconds to display pop up)]
		 */
		override public function Init(...args):void 
		{
			super.Init(args[0]);
			
			var pPopUpTime : Number;
			
			if (args.length == 2)
			{
				if (!(args[1] is Number))
				{
					throw new Error("tried to create a PopUpEntity without a pop up time");
				}
				
				pPopUpTime = args[1] as Number;
			}
			else
			{
				pPopUpTime = -1;
			}			
			
			mPopUpTime = pPopUpTime;
			
			//if custom popup time was set
			if (mPopUpTime != -1)
			{				
				mDisplayTimer.delay = pPopUpTime * 1000;
				mDisplayTimer.addEventListener(TimerEvent.TIMER, OnTimer);
				
				//start timer right away on initialization
				mDisplayTimer.start();
			}
		}
		
		private function OnTimer(pEvent : TimerEvent) : void
		{
			//remove listener from timer and reset
			mDisplayTimer.removeEventListener(TimerEvent.TIMER, OnTimer);
			mDisplayTimer.reset();
			
			//destroy entity
			this.Destroy();
		}
		
		override public function Update(pElapsedTime:Number, pTotalTime:Number):void 
		{
			super.Update(pElapsedTime, pTotalTime);
			
			if (mPopUpTime == -1 
				&& (this.asset as MovieClip).currentFrame == (this.asset as MovieClip).totalFrames)
			{
				//destroy entity
				this.Destroy();
			}
		}
		
		override public function Destroy():void 
		{
			dispatchEvent(new Event(EVENT_POP_UP_DESTROYED));
			
			super.Destroy();	
		}
		
		private var mDisplayTimer : JCTimer;
		private var mPopUpTime : Number;
	}

}