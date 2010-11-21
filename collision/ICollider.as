package collision 
{
	import entity.IEntity;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author jcapote
	 */
	public interface ICollider extends IEntity
	{
		function get position() : Point;
		function get collisionBox() : CollisionBox;
	}
	
}