package carnival.util 
{
	import flash.events.TimerEvent;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author jcapote
	 */
	public class JCTimer extends Timer
	{		
		public function JCTimer(pDelay:Number = 1000, repeatCount:int = 0) 
		{
			super(pDelay, repeatCount);
			mStartTime = 0;
			mStopTime = 0;
			mInitDelay = pDelay;
			mStarted = false;
			
			this.addEventListener(TimerEvent.TIMER, OnTimer);
			this.addEventListener(TimerEvent.TIMER_COMPLETE, OnTimerComplete);
		}
		
		override public function start() : void 
		{
			if (!mStarted)
			{
				mStarted = true;
			}
			
			if (mStartTime == 0)
			{
				mStartTime = getTimer();
				
				if (TRACE_MESSAGES)
				{
					trace("TIMER: started at", mStartTime);
				}
			}
			else
			{
				this.delay = mInitDelay - (mStopTime - mStartTime);
				
				if (TRACE_MESSAGES)
				{
					trace("TIMER: started at", mStartTime, 
						"delay set to remaining time in interrupted repetition", this.delay);
				}
			}
			
			super.start();
		}
		
		override public function stop() : void 
		{
			super.stop();
			
			mStopTime = getTimer();
			
			if (TRACE_MESSAGES)
			{
				trace("TIMER: stopped at", mStopTime);
			}
		}
		
		override public function reset() : void 
		{
			super.reset();
			
			mStartTime = 0;
			
			if (TRACE_MESSAGES)
			{
				trace("TIMER: reset at", getTimer());
			}
		}
		
		override public function get delay():Number 
		{
			return super.delay; 
		}
		
		override public function set delay(value:Number):void 
		{
			super.delay = value;
			
			if (!mStarted)
			{
				mInitDelay = value;
			}
		}
		
		public function get count() : int
		{
			return getTimer() - mStartTime;
		}
		
		private function OnTimer(pEvent : TimerEvent) : void
		{
			mStartTime = getTimer();
			
			if (TRACE_MESSAGES)
			{
				trace("TIMER: repetition complete");
			}
			
			if (this.delay != mInitDelay)
			{
				this.delay = mInitDelay;
				
				if (TRACE_MESSAGES)
				{
					trace("TIMER: reset delay to initial", mInitDelay);
				}
			}
		}
		
		private function OnTimerComplete(pEvent : TimerEvent) : void
		{
			mStartTime = 0;			
			
			if (TRACE_MESSAGES)
			{
				trace("TIMER: timer complete");
			}
			
			if (this.delay != mInitDelay)
			{
				this.delay = mInitDelay;
				
				if (TRACE_MESSAGES)
				{
					trace("TIMER: reset delay to initial", mInitDelay);
				}
			}
		}
		
		private static const TRACE_MESSAGES : Boolean = false;
		
		private var mStartTime : int;
		private var mStopTime : int;
		private var mInitDelay : int;
		private var mStarted : Boolean;
	}

}