package com.isartdigital.perle.ui.hud;

import com.isartdigital.perle.game.managers.RegionManager;
import com.isartdigital.perle.game.sprites.Building;
import com.isartdigital.perle.game.virtual.VBuilding;
import com.isartdigital.perle.game.virtual.VTile;
import com.isartdigital.perle.ui.hud.HudContextual;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.ui.smart.SmartButton;
import pixi.core.display.Container;

/**
 * todo : leur faire une nomenclature >.<, pr le nom de la classe...
 * @author Emeline Berenguier
 */
class Menu_BatimentConstruit extends HudContextual{

	
	private var btnRemove:SmartButton;
	private var btnDescription:SmartButton;
	private var btnHide:SmartButton;
	
	private var buildingRef:Building;
	public static var vBuildingRef:VBuilding;
	
	public function new(pID:String=null) {
		super(pID);
	}
	
	/**
	 * @param	pVBuilding
	 */
	public function init (pBuilding:Building, pVBuilding:VBuilding):Void {
		
		x = pVBuilding.graphic.x / 2;
		y = pVBuilding.graphic.y / 2;
		
		buildingRef = pBuilding;
		vBuildingRef = pVBuilding;
		
		addListeners();
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
		buildingRef.setModeMove(vBuildingRef);
		destroy();
		//RegionManager.removeToRegionBuilding(vBuildingRef); 
		//Todo: not working here, I wanted to remove the building's presence temporarily
		//From the region manager to avoid the collision between the moving building and it ex-position
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
	
	public static function removeToRegionBuilding():Void{
		RegionManager.removeToRegionBuilding(vBuildingRef);
	}
	
	override public function destroy():Void {
		super.destroy();
	}
}