package carnival.service 
{	
	/**
	 * States of services
	 * @author jcapote
	 */
	public final class ServiceState
	{
		public static const INVALID : ServiceState = newEnumValue;
		public static const PRE_INIT : ServiceState = newEnumValue;
		public static const INITIALIZED : ServiceState = newEnumValue;
		public static const RUNNING : ServiceState = newEnumValue;
		public static const PAUSED : ServiceState = newEnumValue;
		
		/**
		 * Constructor that should only be used internally
		 * @param	pKey
		 * @param	pValue
		 */
		public function ServiceState(pKey : String)
		{
			if (pKey != sConstructorKey)
			{
				throw new Error("Tried to instantiate ServiceState class incorrectly");
			}
		}
		
		/**
		 * Returns a new enumeration
		 * @param	pValue The value to give the enumeration
		 * @return
		 */
		private static function get newEnumValue() : ServiceState
		{
			return new ServiceState(sConstructorKey);
		}
		
		private static const sConstructorKey : String = "qazwsxedcrfvtgbyhnujm";
	}
}