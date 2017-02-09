package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.game.GameConfig.TableTypeBuilding;

/**
 * manage any limit building in the world map or in a region
 * @author de Toffoli Matthias
 */
class BuildingLimitManager
{

	private static var mapNumbersBuildingPerRegion:Map<Int,Map<Int,Map<String,Int>>>;
	private static var mapNumbersBuilding:Map<String,Int>;
	private static var limits:Map<String,Int>;
	
	
	public static function awake():Void {
		mapNumbersBuildingPerRegion = new Map<Int,Map<Int,Map<String,Int>>>();
		mapNumbersBuilding = new Map<String,Int>();
		limits = new Map<String,Int>();
		
		//setLimits();
	}
	
	private static function setLimits():Void {
		var arrayTypeBuildings:Array<TableTypeBuilding> = GameConfig.getBuilding();
		var typeBuilding:TableTypeBuilding;
		
		for (typeBuilding in arrayTypeBuildings) {
			if (typeBuilding.limitPerRegion != null) {
				limits[typeBuilding.name] = typeBuilding.limitPerRegion;
			}
		}
	}
	
	/**
	 * increment the number of building per region
	 * @param	regionX the position x of the region in the mapWorld
	 * @param	regionY the position y of the region in the mapWorld
	 * @param	pName the building name
	 */
	public static function incrementMapNumbersBuildingPerRegion(regionX:Int, regionY:Int, pName:String):Void {
		if (!mapNumbersBuildingPerRegion.exists(regionX)) mapNumbersBuildingPerRegion[regionX] = new Map<Int,Map<String,Int>>();
		if (!mapNumbersBuildingPerRegion[regionX].exists(regionY)) mapNumbersBuildingPerRegion[regionX][regionY] = new Map<String,Int>();
		if (!mapNumbersBuildingPerRegion[regionX][regionY].exists(pName)) mapNumbersBuildingPerRegion[regionX][regionY][pName] = 0;
		
		mapNumbersBuildingPerRegion[regionX][regionY][pName]+= 1;
	}
	
	/**
	 * decrement the number of building per region
	 * @param	regionX the position x of the region in the mapWorld
	 * @param	regionY the position y of the region in the mapWorld
	 * @param	pName the building name
	 */
	public static function decrementMapNumbersBuildingPerRegion(regionX:Int, regionY:Int, pName:String):Void {		
		mapNumbersBuildingPerRegion[regionX][regionY][pName] = Std.int(Math.max(mapNumbersBuildingPerRegion[regionX][regionY][pName] - 1, 0));
	}
	
	/**
	 * decrement the number total of building
	 * @param	pName the building name
	 */
	public static function decrementMapNumbersBuilding(pName:String):Void {		
		mapNumbersBuilding[pName] = Std.int(Math.max(mapNumbersBuilding[pName]-1,0));
	}
	
	/**
	 * increment the number total of building
	 * @param	pName the building name
	 */
	public static function incrementMapNumbersBuilding(pName:String):Void {
		if (!mapNumbersBuilding.exists(pName)) mapNumbersBuilding[pName] = 0;
		
		mapNumbersBuilding[pName]+= 1;
	}
	
	/**
	 * test if we havn't pass the building limit in the region
	 * @param	regionX the position x of the region in the mapWorld
	 * @param	regionY the position y of the region in the mapWorld
	 * @param	pName the building name
	 * @return a boolean said if we can add the building in the region want
	 */
	public static function canIPastThisBuildingInThisRegion(regionX:Int, regionY:Int, pName:String):Bool {

		if (!mapNumbersBuildingPerRegion.exists(regionX)) return true;
		else if (!mapNumbersBuildingPerRegion[regionX].exists(regionY)) return true;
		else if (!mapNumbersBuildingPerRegion[regionX][regionY].exists(pName)) return true;
		
		return limits.exists(pName) ? mapNumbersBuildingPerRegion[regionX][regionY][pName] < limits[pName]:true;
	}
	
	/**
	 * test if we havn't pass the building limit in the region
	 * @param	pName the building name
	 * @return a boolean said if we can add the building
	 */
	public static function canIPastThisBuilding(pName:String):Bool {
		if (!mapNumbersBuilding.exists(pName)) return true;
		return limits.exists(pName) ? mapNumbersBuilding[pName] < limits[pName]:true;
	}
}