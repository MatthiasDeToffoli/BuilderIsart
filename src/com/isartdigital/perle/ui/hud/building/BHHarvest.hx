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
	
	
	private var btnRemove:SmartButton;
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
		//addListeners(); todo : créer une erreur
	}
	
	private function addListeners ():Void {
		btnRemove = cast(getChildByName("Button_MoveBuilding"), SmartButton);
		btnDescription = cast(getChildByName("Button_EnterBuilding"), SmartButton);
		btnHide = cast(getChildByName("Button_CancelSelection"), SmartButton);
		btnRemove.on(MouseEventType.CLICK, onClickRemove);
		btnDescription.on(MouseEventType.CLICK, onClickDescription);
		btnHide.on(MouseEventType.CLICK, onClickHide);
	}
	
	/*
	 * Function to remove the building
	 */
	private function onClickRemove(): Void {
		//BuildingHud.virtualBuilding.graphic.setModeMove(BuildingHud.virtualBuilding);
	
	}
	
	private function onClickDescription(): Void {
		trace("onClickCenter");
	}
	
	/*
	 * Fonction pour cacher le menu
	 */
	private function onClickHide(): Void {
		destroy();
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