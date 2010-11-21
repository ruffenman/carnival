package carnival.entity 
{
	import flash.geom.Point;
	
	/**
	 * Allows position to be set by Point objects
	 * @author jcapote
	 */
	public interface IPlaceable 
	{
		function get position() : Point;
		function set position(pPosition : Point) : void;
	}
	
}