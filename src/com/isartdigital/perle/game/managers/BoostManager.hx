package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.virtual.VTile.Index;
import eventemitter3.EventEmitter;

 /**
  * information than every element link to the boost need
  */
 typedef BoostInfo =  {
	 var regionPos:Index;
	 var casePos:Index;
	 @:optional var buildingRef:Int;
	 @:optional var type:Alignment;
 }
 
 /**
 * manage all event link to boost
 * @author de Toffoli Matthias
 */
class BoostManager
{

	/**
	 * event call when a new altar is past
	 */
	public static var  boostAltarEvent:EventEmitter;
	
	/**
	 * event call when a new building is past
	 */
	public static var boostBuildingEvent:EventEmitter;
	
	public static inline var ALTAR_EVENT_NAME:String = "ALTAR_CALL";
	public static inline var BUILDING_ON_EVENT_NAME:String = "BUILDING_ENTER_ZONE";
	public static inline var BUILDING_OFF_EVENT_NAME:String = "BUILDING_OUT_ZONE";
	
	
	/**
	 * Initialisation of the class
	 */
	public static function awake():Void{
		boostAltarEvent = new EventEmitter();
		boostBuildingEvent = new EventEmitter();

	}
	
	/**
	 * call when altar is past check if every case of the altar zone have a building
	 * @param	regionPos the position of the region to check
	 * @param	casePos the position of case to check
	 */
	public static function altarCheckIfHasBuilding(regionPos:Index, casePos:Index):Void {
		boostAltarEvent.emit(ALTAR_EVENT_NAME, {casePos:casePos, regionPos:regionPos});
	}
	
	/**
	 * add the building ref to an altar
	 * @param	regionPos the region of the building
	 * @param	casePos the position of the case of the Altar's zone
	 * @param	pRef the building ref
	 * @param	pType the type of the building
	 */
	public static function buildingIsInAltarZone(toAdd:Bool, pRef:Int, pType:Alignment,regionPos:Index, ?casePos:Index):Void{
		if (toAdd) boostBuildingEvent.emit(BUILDING_ON_EVENT_NAME, {casePos:casePos, regionPos:regionPos, buildingRef:pRef, type:pType});
		else boostBuildingEvent.emit(BUILDING_OFF_EVENT_NAME, {regionPos:regionPos, buildingRef:pRef, type:pType});
	}
	
}