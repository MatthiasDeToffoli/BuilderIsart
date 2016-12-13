package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.game.managers.SaveManager.Save;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.managers.TimeManager.TimeElement;

/**
 * Imitate a DataBase
 * Each timer, Resource, building should have an unique ID !
 * Each of them can contains reference to the other by using his unique ID.
 * @author ambroise
 */
class IdManager{

	public static var idHightest(default, null):Int;
	
	
	public static function buildWhitoutSave ():Void {
		idHightest = 0;
	}
	
	public static function buildFromSave (pSave:Save):Void {
		idHightest = pSave.idHightest;
	}
	
	public static function newId ():Int {
		return ++idHightest;
	}
	
	/**
	 * Not used yet. (more for debug purpose)
	 * @param	pRef
	 * @param	pSave
	 * @return  An array of TileDescription
	 */
	public static function searchByRef (pRef:Int, pSave:Save):Array<TileDescription> {
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
	}
	
	/**
	 * Not used yet. (more for debug purpose)
	 * @param	pId
	 * @param	pSave
	 * @return
	 */
	public static function searchById (pId:Int, pSave:Save):TileDescription {
		var result:TileDescription = null;
		var lLength:Int = pSave.building.length;
		
		for (i in 0... lLength) {
			if (pSave.building[i].id == pId && result == null)
				result = pSave.building[i];
			else
				throw("duplicated id : " + pId);
		}
				
		lLength = pSave.ground.length;
		
		for (i in 0...lLength)
			if (pSave.ground[i].id == pId && result == null)
				result = pSave.ground[i];
			else
				throw("duplicated id : " + pId);
				
		return result;
	}
	
	/**
	 * Find the corresponding TimeElement whit an BuildingId
	 * @param	pBuildingId
	 * @return
	 */
	public static function getBuildingTimeElement (pBuildingId:Int):TimeElement {
		var lLength:Int = TimeManager.list.length;
		
		for (i in 0...lLength) {
			if (pBuildingId == TimeManager.list[i].desc.refTile)
				return TimeManager.list[i];
		}
		
		return null;
	}
	
	public function new() {
		
	}
	
}