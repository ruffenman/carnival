package carnival.entity 
{
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedSuperclassName;
	import carnival.service.Service;
	
	/**
	 * Maintains a list of game entities and handles the assigning of their entity id's, calling
	 * 	update, and calling ShutDown upon destruction
	 * @author jcapote
	 */
	public class EntityService extends Service
	{			
		public function EntityService() 
		{
			super();
			
			mEntityList = new Array();
		}	
		
		/**
		 * Initialize the EntityService
		 */
		override public function Init():void 
		{
			super.Init();
		}	
		
		override public function StartService():void 
		{
			super.StartService();
			
			mUnusedID = 0;
		}
		
		override public function Update(pElapsedTime:Number, pTotalTime:Number):void 
		{
			super.Update(pElapsedTime, pTotalTime);
			
			//remove / shut down entities that no longer exist
			var toRemove:Array = mEntityList.filter(NotExists);
			
			for each (var temp : Entity in toRemove)
			{
				RemoveEntity(temp);
			}
			
			//update entities that exist
			var toUpdate:Array = mEntityList.filter(Exists);
			
			for each(temp in toUpdate)
			{
				temp.Update(pElapsedTime, pTotalTime);
			}
			
			//remove / shut down entities that no longer exist
			toRemove = mEntityList.filter(NotExists);
			
			for each (temp in toRemove)
			{
				RemoveEntity(temp);
			}
		}
		
		override public function StopService():void 
		{
			super.StopService();
			
			ClearEntities();
		}
		
		override public function ShutDown():void 
		{
			super.ShutDown();
		}
		
		public function GetEntityCount():int 
		{
			return mEntityList.length;
		}		
		
		/**
		 * Registers an entity (that has already been created and initialized) with the entity
		 * 	service. If the Entity has not been initialized, it is removed on the next update
		 * @param	pEntity
		 *
		public function RegisterExistingEntity(pEntity : Entity) : void
		{
			pEntity.SetEntityID(mUnusedID);
			
			++mUnusedID;
			
			mEntityList.push(pEntity);
		}	
		*/
		
		
		public function CreateEntity(pEntityType : Class, ... args) : Entity
		{
			var baseClass : Class 
				= getDefinitionByName(getQualifiedSuperclassName(pEntityType)) as Class;
			
			while (baseClass != Entity && baseClass != Object)
			{
				baseClass = getDefinitionByName(getQualifiedSuperclassName(baseClass)) as Class;
			}
			
			if (baseClass == Object)
			{
				throw new Error("Tried to create a non-entity typed object");
			}
			
			//create a new instance of the requested type of entity
			var newEntity : Entity = new pEntityType();
			
			//set entity id
			newEntity.SetEntityID(mUnusedID);
			
			++mUnusedID;
			
			//store entity
			mEntityList.push(newEntity);
			
			//initialize entity
			newEntity.Init.apply(newEntity, args);
			
			return newEntity;
		}	
		
		internal function GetEntity(pEntityID : int) : Entity
		{
			//binary search for entity with id
			var foundEntity : Entity;
			
			var low : int = 0;
			var high : int = mEntityList.length - 1;
			
			while (high >= low)
			{
				var mid : int = int((low + high) / 2);
				
				if (pEntityID < (mEntityList[mid] as Entity).entityID)
				{
					high = mid - 1;
				}
				else if (pEntityID > (mEntityList[mid] as Entity).entityID)
				{
					low = mid + 1;
				}
				else
				{
					foundEntity = mEntityList[mid] as Entity;
					break;
				}
			}
			
			return foundEntity;
		}
		
		//private members
		
		private function RemoveEntityAt(index:int):void
		{
			var currEntity:Entity = mEntityList[index];
			
			currEntity.ShutDown();
			
			mEntityList.splice(index, 1);
			
			//trace("ENTITIES REMAINING: " + mEntityList.length);
		}
		
		private function RemoveEntity(entity:Entity):void
		{
			for (var i:int = 0; i < mEntityList.length; ++i)
			{
				if (mEntityList[i] == entity)
				{
					RemoveEntityAt(i);
					
					break;
				}
			}
		}		
		
		/**
		 * Removes all entity instances from the game
		 */
		private function ClearEntities() : void
		{
			for each (var currEntity : Entity in mEntityList)
			{
				currEntity.Destroy();
			}		
			
			for (var i : int = mEntityList.length - 1; i >= 0; --i)
			{
				RemoveEntityAt(i);
			}
		}
		
		private function Exists(item:*, index:int, array:Array):Boolean
		{
			return (item as Entity).doesExist;
		}
		
		private function NotExists(item:*, index:int, array:Array):Boolean
		{
			return !(Exists(item, index, array));
		}
		
		private var mUnusedID : int;
		
		private var mEntityList : Array;
	}

}