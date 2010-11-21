package carnival.util 
{
	import carnival.entity.Entity;
	import fl.motion.easing.Linear;
	
	/**
	 * ...
	 * @author jcapote
	 */
	public class Easer
	{		
		public function Easer(pEaseFunc : Function) 
		{
			mEaseFunc = pEaseFunc;
			mEndValue = 1;
			mDuration = 1;
			mComplete = true;
		}
		
		public function Update(pElapsedTime:Number, pTotalTime:Number):void 
		{			
			mCurrTime += pElapsedTime;
			mComplete = false;
			
			if (mCurrTime > mDuration)
			{				
				mCurrTime = mDuration;
				mComplete = true;
			}
		}
		
		public function get complete() : Boolean
		{
			return mComplete;
		}
		
		public function get currentValue() : Number
		{
			return mEaseFunc(mCurrTime, mStartValue, mValueDelta, mDuration);
		}
		
		public function set startValue(pStartValue : Number) : void
		{
			mStartValue = pStartValue;
			
			mValueDelta = mEndValue - mStartValue;
		}
		
		public function set endValue(pEndValue : Number) : void
		{
			mEndValue = pEndValue;
			
			mValueDelta = mEndValue - mStartValue;
		}
		
		public function set easeFunc(pEaseFunc : Function) : void
		{
			mEaseFunc = pEaseFunc;
		}
		
		public function set duration(pDuration : Number) : void
		{
			mDuration = pDuration;
		}
		
		public function resetTime() : void
		{
			mCurrTime = 0;
		}
		
		private var mDuration : Number;
		private var mStartValue : Number;
		private var mEndValue : Number;
		private var mValueDelta : Number;
		private var mEaseFunc : Function;
		private var mCurrValue : Number;
		private var mCurrTime : Number;
		private var mComplete : Boolean;
	}

}