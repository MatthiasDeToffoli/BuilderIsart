package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import eventemitter3.EventEmitter;

/**
 * ...
 * @author de Toffoli Matthias
 */
class BoostManager
{

	public static var  boostEvent:EventEmitter;
	private static var quantityBoost:Map<Alignment,Float>;
	
	public static inline var BOOST_EVENT_NAME:String = "BOOST";
	public function new() 
	{
		
	}
	
	public static function awake(){
		boostEvent = new EventEmitter();
		quantityBoost = new Map<Alignment,Float>();
		quantityBoost[Alignment.heaven] = 0;
		quantityBoost[Alignment.hell] = 0;
		quantityBoost[Alignment.neutral] = 0;
	}
	
	public static function callEvent(pType:Alignment):Void {
		quantityBoost[pType] += 4;
		
		if (pType == Alignment.heaven) quantityBoost[Alignment.hell] = Math.max(quantityBoost[Alignment.hell] - 1, 0);
		if (pType == Alignment.hell) quantityBoost[Alignment.heaven] = Math.max(quantityBoost[Alignment.heaven] - 1, 0);
		boostEvent.emit(BOOST_EVENT_NAME);
	}
	
	public static function getBoost(pType:Alignment):Float {
		return quantityBoost[pType];
	}
	
}