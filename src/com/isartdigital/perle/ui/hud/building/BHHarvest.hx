package com.isartdigital.perle.ui.hud.building;

import com.isartdigital.perle.game.managers.RegionManager;
import com.isartdigital.perle.game.sprites.Building;
import com.isartdigital.perle.game.sprites.Phantom;
import com.isartdigital.perle.game.sprites.Tile;
import com.isartdigital.perle.game.virtual.VBuilding;
import com.isartdigital.perle.ui.hud.Hud.BuildingHudType;
import com.isartdigital.perle.ui.popin.InfoBuilding;
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
	private var btnUpgrade:SmartButton;
	private var btnDestroy:SmartButton;
	
	
	public static function getInstance (): BHHarvest {
		if (instance == null) instance = new BHHarvest();
		return instance;
	}	
	
	private function new() {
		super("BuiltContext");
	}
	
	override private function addListeners ():Void {
		SmartCheck.traceChildrens(this);
		btnMove = cast(getChildByName("MoveButton"), SmartButton);
		btnDescription = cast(getChildByName("EnterButton"), SmartButton);
		btnUpgrade = cast(getChildByName("ButtonUpgradeBuilding"), SmartButton);
		btnDestroy = cast(getChildByName("ButtonDestroyBuilding"), SmartButton);
		btnMove.on(MouseEventType.CLICK, onClickMove);
		btnDescription.on(MouseEventType.CLICK, onClickDescription);
		btnUpgrade.on(MouseEventType.CLICK, onClickUpgrade);
		btnDestroy.on(MouseEventType.CLICK, onClickDestroy);
	}
	
	private function onClickMove(): Void {
		BuildingHud.virtualBuilding.onClickMove();
		Hud.getInstance().changeBuildingHud(BuildingHudType.MOVING, BuildingHud.virtualBuilding);
	}
	
	private function onClickDescription(): Void {
		UIManager.getInstance().openPopin(InfoBuilding.getInstance());
	}
	
	private function onClickDestroy(): Void {
		InfoBuilding.getInstance().onClickSell();
	}
	
	private function onClickUpgrade(): Void {
		InfoBuilding.getInstance().onClickUpgrade();
	}
	
	override public function destroy():Void {
		instance = null;
		super.destroy();
	}
	
}