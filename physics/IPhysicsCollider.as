package physics 
{
	import collision.ICollider;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author jcapote
	 */
	public interface IPhysicsCollider extends ICollider
	{
		function get velocity() : Point;
		function get acceleration() : Point;
		function get isGrounded() : Boolean;
		function set isGrounded(value : Boolean) : void;
	}
	
}