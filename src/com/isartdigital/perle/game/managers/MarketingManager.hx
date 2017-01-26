package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.game.virtual.vBuilding.VTribunal;

/**
 * ...
 * @author de Toffoli Matthias
 */
class MarketingManager
{
	/**
	 * number of VMarketing house
	 */
	private static var numberAdMen:Int;
	private static var campainFactor:Int;
	private static inline var NUMBERADMENFACTOR:Int = 2;
	
	public static function awake():Void {
		numberAdMen = 0;
		campainFactor = 0;
	}
	
	public static function increaseNumberAdMen():Void {
		numberAdMen++;
		updateTribunal();
	}
	
	public static function decreaseNumberAdMen():Void {
		numberAdMen--;
		updateTribunal();
	}
	
	private static function updateTribunal():Void {
		trace(1 + (NUMBERADMENFACTOR + campainFactor) * numberAdMen);
		VTribunal.getInstance().updateGenerator(1 + (NUMBERADMENFACTOR + campainFactor) * numberAdMen); 
	}
	
}