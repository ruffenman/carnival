package carnival.entity 
{
	import carnival.service.ServiceManager;
	
	/**
	 * ...
	 * @author jcapote
	 */
	public class EntityRef 
	{		
		public function EntityRef(pEntityID : int) 
		{
			mEntityID = pEntityID;
		}
		
		public function get ent() : Entity
		{
			var entitySvc : EntityService
				= ServiceManager.GetInstance().GetService(EntityService) as EntityService;
			
			var toReturn : Entity = entitySvc.GetEntity(mEntityID);
			
			if (toReturn == null)
			{
				throw new Error("Tried to dereference an invalid entity reference");
			}
		}
		
		private var mEntityID : int;
	}

}