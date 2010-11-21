package collision 
{
	/**
	 * ...
	 * @author jcapote
	 */
	public class CollisionGroups
	{
		public static const NUM_GROUPS : int = 8;
		
		public static const GROUP_NONE : int = 0;
		
		//player group
		public static const GROUP_0 : int = 1;
		
		//enemy group
		public static const GROUP_1 : int = 2;
		
		//projectile group
		public static const GROUP_2 : int = 4;		
		
		//powerup group
		public static const GROUP_3 : int = 8;
		
		public static const GROUP_4 : int = 16;
		
		public static const GROUP_5 : int = 32;
		
		public static const GROUP_6 : int = 64;
		
		public static const GROUP_7 : int = 128;
		
		public static const GROUP_ALL : int = 255;
	}
}