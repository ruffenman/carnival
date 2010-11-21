package carnival.enum 
{
	/**
	 * Type-safe enumeration class.
	 * @author jcapote
	 * @usage Create a new class and copy the contents from this one. Rename all the "Enum" with 
	 * 	your own custom enum type. Enumeration values are declared in a your Enum class as follows:
	 * 		public static const MY_FIRST_ENUM : MyEnumType = newEnumValue;
	 */
	public class Enum
	{		
		/**
		 * Constructor that should only be used internally
		 * @param	pKey
		 * @param	pValue
		 */
		public function Enum(pKey : String)
		{
			if (pKey != sConstructorKey)
			{
				throw new Error("Tried to instantiate Enum class incorrectly");
			}
		}
		
		/**
		 * Returns a new enumeration
		 * @param	pValue The value to give the enumeration
		 * @return
		 */
		private static function get newEnumValue() : Enum
		{
			return new Enum(sConstructorKey);
		}
		
		private static const sConstructorKey : String = "qazwsxedcrfvtgbyhnujm";
	}

}