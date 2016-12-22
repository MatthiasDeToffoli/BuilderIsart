package com.isartdigital.perle.ui.hud.building;

import com.isartdigital.perle.game.managers.RegionManager;
import com.isartdigital.perle.game.sprites.Building;
import com.isartdigital.perle.game.virtual.VBuilding;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.ui.smart.SmartButton;

/**
 * 
 * @author Emeline Berenguier
 */
class BHHarvest extends BuildingHud{
	
	
	// todo : faire singleton pour les trois buildinghud
	
	private var btnMove:SmartButton;
	private var btnDescription:SmartButton;
	private var btnHide:SmartButton;
	
	private var buildingRef:Building;
	public static var vBuildingRef:VBuilding;
	
	public function new() {
		super("BuiltContext");
	}
	
	/**
	 * @param	pVBuilding
	 */
	public function init ():Void {
		addListeners();
	}
	
	private function addListeners ():Void {
		btnMove = cast(getChildByName("MoveButton"), SmartButton);
		btnDescription = cast(getChildByName("EnterButton"), SmartButton);
		btnHide = cast(getChildByName("CloseButton"), SmartButton);
		btnMove.on(MouseEventType.CLICK, onClickMove);
		btnDescription.on(MouseEventType.CLICK, onClickDescription);
		btnHide.on(MouseEventType.CLICK, onClickHide);
	}
	
	/*
	 * Function to remove the building
	 */
	private function onClickMove(): Void {
		cast(BuildingHud.virtualBuilding.graphic, Building).setModeMove();
	}
	
	private function onClickDescription(): Void {
		trace("info maison");
	}
	
	/*
	 * Fonction pour cacher le menu
	 */
	private function onClickHide(): Void {
		Hud.getInstance().hideBuildingHud();
	}
	
	/* useless todo : enlever
	public static function removeToRegionBuilding():Void{
		RegionManager.removeToRegionBuilding(BuildingHud.virtualBuilding);
	}*/
	
	// useless
	/*override public function destroy():Void {
		super.destroy();
	}*/
}