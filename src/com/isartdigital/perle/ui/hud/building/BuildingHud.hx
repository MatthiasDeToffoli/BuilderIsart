package com.isartdigital.perle.ui.hud.building;
import com.isartdigital.perle.game.virtual.VBuilding;
import com.isartdigital.perle.ui.hud.Hud.BuildingHudType;
import com.isartdigital.utils.ui.smart.SmartComponent;

/**
 * ...
 * @author ambroise
 */
class BuildingHud extends SmartComponent {
	
	
	
	public static var VBUILDING_STATE_TO_BH_TYPE(default, never):Map<VBuildingState, BuildingHudType> = [
		VBuildingState.isBuilt => BuildingHudType.HARVEST,
		VBuildingState.isBuilding => BuildingHudType.CONSTRUCTION,
		VBuildingState.isMoving => BuildingHudType.MOVING
	];
	
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
	

	public function init ():Void {
		addListeners();
	}
	
	private function addListeners ():Void { }
	
}