package carnival.util 
{
	/**
	 * Custom Math utility functions
	 * @author jcapote
	 */
	public final class JCMath
	{		
		/**
		 * Generates a random whole number n where pMin <= n <= pMax
		 * @param	pMin
		 * @param	pMax
		 * @return
		 */
		public static function RangedRandom(pMin : int, pMax : int) : int
		{
			return (int(Math.random() * (1 + pMax - pMin)) + pMin);
		}	
	}

}