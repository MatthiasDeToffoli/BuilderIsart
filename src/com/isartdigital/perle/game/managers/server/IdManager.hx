package com.isartdigital.perle.game.managers.server;
import com.isartdigital.perle.game.managers.SaveManager.TimeDescription;
import com.isartdigital.perle.game.virtual.VBuilding;
import com.isartdigital.perle.game.virtual.vBuilding.VTribunal;
import com.isartdigital.utils.Debug;

/**
 * Imitate a DataBase ID
 * Each timer, Resource, building should have an unique ID !
 * Each of them can contains reference to the other by using his unique ID.
 * It's used to identify the building in server callback (see SynchroManager)
 * @author ambroise
 */
class IdManager{

	public static var idHightest(default, null):Int = 0;
	
	public static function newId ():Int {
		return idHightest++;
	}
	
	/**
	 * Not used yet. (more for debug purpose)
	 * @param	pRef
	 * @param	pSave
	 * @return  An array of TileDescription
	 */
	/*public static function searchByRef (pRef:Int, pSave:Save):Array<TileDescription> {
		var result:Array<TileDescription> = new Array<TileDescription>();
		var lLength:Int = pSave.building.length;
		
		for (i in 0... lLength)
			if (pSave.building[i].refTimer == pRef)
				result.push(pSave.building[i]);
				
		lLength = pSave.ground.length;
		for (i in 0...lLength)
			if (pSave.ground[i].refResource == pRef)
				result.push(pSave.ground[i]);
				
		return result;
	}*/
	
	/**
	 * not used, debug purpose only ?
	 * @param	pId
	 * @param	pSave
	 * @return
	 */
	public static function searchById (pId:Int):Dynamic {
		var result:Array<Dynamic> = [];
		
		if (searchVBuildingById != null)
			result.push(searchVBuildingById(pId));
		
		if (result.length > 1)
			Debug.error("DUPLICATED id : "+pId+".");
		
		return result[0];
	}
	
	/**
	 * Used at server callback -> synchroManager
	 * @param	pInt
	 */
	public static function searchVBuildingById (pId:Int):VBuilding {
		// faire un tableau stockant id et référence ? folie de l'optimisation ?
		for (regionX in RegionManager.worldMap.keys()) {
			for (regionY in RegionManager.worldMap[regionX].keys()) {
				for (x in RegionManager.worldMap[regionX][regionY].building.keys()) {
					for (y in RegionManager.worldMap[regionX][regionY].building[x].keys()) {
						if (RegionManager.worldMap[regionX][regionY].building[x][y].tileDesc.id == pId)
							return RegionManager.worldMap[regionX][regionY].building[x][y];
					}
				}
			}
		}
		Debug.warn(pId + " id (client) not found in worldMap.");
		return null;
	}
	
	public static function searchTimeBuildingProductionById (pId:Int):TimeDescription {
		var lLength:Int = TimeManager.listProduction.length;
		for (i in 0...lLength) {
			if (TimeManager.listProduction[i].refTile == pId)
				return TimeManager.listProduction[i];
		}
		
		Debug.warn(pId + " id (client) not found in TimeManager.listProduction.");
		return null;
	}
	
}