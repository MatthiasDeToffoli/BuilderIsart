package com.isartdigital.perle.ui.hud.building;

import com.isartdigital.perle.game.managers.RegionManager;
import com.isartdigital.perle.game.sprites.Building;
import com.isartdigital.perle.game.sprites.Phantom;
import com.isartdigital.perle.game.sprites.Tile;
import com.isartdigital.perle.game.virtual.VBuilding;
import com.isartdigital.perle.ui.hud.Hud.BuildingHudType;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.ui.smart.SmartButton;

/**
 * 
 * @author Emeline Berenguier
 */
class BHHarvest extends BuildingHud{
	
	private static var instance:BHHarvest;
	
	private var btnMove:SmartButton;
	private var btnDescription:SmartButton;
	private var btnClose:SmartButton;
	
	
	public static function getInstance (): BHHarvest {
		if (instance == null) instance = new BHHarvest();
		return instance;
	}	
	
	public function new() {
		super("BuiltContext");
	}
	
	override private function addListeners ():Void {
		btnMove = cast(getChildByName("MoveButton"), SmartButton);
		btnDescription = cast(getChildByName("EnterButton"), SmartButton);
		btnClose = cast(getChildByName("CloseButton"), SmartButton);
		btnMove.on(MouseEventType.CLICK, onClickMove);
		btnDescription.on(MouseEventType.CLICK, onClickDescription);
		btnClose.on(MouseEventType.CLICK, onClickClose);
	}
	
	private function onClickMove(): Void {
		BuildingHud.virtualBuilding.onClickMove();
		Hud.getInstance().changeBuildingHud(BuildingHudType.MOVING, BuildingHud.virtualBuilding);
	}
	
	private function onClickDescription(): Void {
		trace("info maison");
	}
	
	private function onClickClose(): Void {
		Hud.getInstance().hideBuildingHud();
	}
	
	override public function destroy():Void {
		instance = null;
		super.destroy();
	}
	
}