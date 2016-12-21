package com.isartdigital.perle.ui.hud.building;
import com.isartdigital.perle.game.virtual.VBuilding;
import com.isartdigital.utils.ui.smart.SmartComponent;

/**
 * ...
 * @author ambroise
 */
class BuildingHud extends SmartComponent{

	public static var virtualBuilding:VBuilding;

	public static function linkVirtualBuilding (pVBuilding:VBuilding):Void {
		virtualBuilding = pVBuilding;
	}
	
	public static function unlinkVirtualBuilding (pVBuilding:VBuilding):Void {
		if (virtualBuilding.tileDesc.id == pVBuilding.tileDesc.id)
			virtualBuilding = null;
	}
	
	public function new(pID:String=null) {
		super(pID);
	}
	
	
	
}