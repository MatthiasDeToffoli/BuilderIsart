package com.isartdigital.perle.ui.hud.building;

import com.isartdigital.perle.game.managers.RegionManager;
import com.isartdigital.perle.game.sprites.Building;
import com.isartdigital.perle.game.sprites.Phantom;
import com.isartdigital.perle.game.sprites.Tile;
import com.isartdigital.perle.game.virtual.VBuilding;
import com.isartdigital.perle.game.virtual.vBuilding.VBuildingUpgrade;
import com.isartdigital.perle.game.virtual.vBuilding.VTribunal;
import com.isartdigital.perle.ui.hud.Hud.BuildingHudType;
import com.isartdigital.perle.ui.popin.InfoBuilding;
import com.isartdigital.perle.ui.popin.TribunalPopin;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.ui.smart.SmartButton;
import js.Browser;

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
		btnDescription.on(MouseEventType.CLICK, onClickDescription);
		
	}
	
	/**
	 * function to set when the WF is openned
	 */
	public static function setOnSpawn():Void {
		GameStage.getInstance().getGameContainer().interactive = true;
		GameStage.getInstance().getGameContainer().on(MouseEventType.MOUSE_DOWN, onClickExit);
		BHHarvest.getInstance().setUpgradeButton();
		BHHarvest.getInstance().setMoveAndDestroy();
		
	}
	
	/**
	 * listen click on destroy and move if building is not the tribunal
	 */
	public function setMoveAndDestroy():Void{
		if(Std.is(BuildingHud.virtualBuilding,VTribunal)){
			btnMove.alpha = 0.5;
			btnDestroy.alpha = 0.5;
		} else{
			btnMove.on(MouseEventType.CLICK, onClickMove);		
			btnDestroy.on(MouseEventType.CLICK, onClickDestroy);
		}
	}
	
	private function setUpgradeButton():Void {
		if (Std.is(BuildingHud.virtualBuilding, VBuildingUpgrade)){
				var myVBuilding:VBuildingUpgrade = cast(BuildingHud.virtualBuilding, VBuildingUpgrade);
				if (myVBuilding.canUpgrade()) {
					btnUpgrade.on(MouseEventType.CLICK, onClickUpgrade);
				}
				else
					btnUpgrade.alpha = 0.5;
			}
		else
			btnUpgrade.alpha = 0.5;
	}
	
	private function removeButtonsChange():Void {
			
		btnMove.off(MouseEventType.CLICK, onClickMove);		
		btnDestroy.off(MouseEventType.CLICK, onClickDestroy);
		btnUpgrade.removeAllListeners();
		btnUpgrade.alpha = 1;
		btnMove.alpha = 1;
		btnDestroy.alpha = 1;
	}
	
	private function removeListenerGameContainer():Void {
		GameStage.getInstance().getGameContainer().interactive = false;	
	}
	
	private function onClickMove(): Void {
		removeButtonsChange();
		removeListenerGameContainer();
		BuildingHud.virtualBuilding.onClickMove();
		Hud.getInstance().changeBuildingHud(BuildingHudType.MOVING, BuildingHud.virtualBuilding);
		//trace(cast(BuildingHud.virtualBuilding.graphic, Building).getAssetName());
	}
	
	private function onClickDescription(): Void {
		removeButtonsChange();
		removeListenerGameContainer();
		if(Std.is(BuildingHud.virtualBuilding,VTribunal)) UIManager.getInstance().openPopin(TribunalPopin.getInstance()); 
		else UIManager.getInstance().openPopin(InfoBuilding.getInstance());
		onClickExit();
	}
	
	private function onClickDestroy(): Void {
		removeButtonsChange();
		UIManager.getInstance().openPopin(BuildingDestroyPoppin.getInstance());
		removeListenerGameContainer();
	}
	
	private function onClickUpgrade(): Void {
		removeButtonsChange();
		removeListenerGameContainer();
		InfoBuilding.getInstance().onClickUpgrade();
		Hud.getInstance().hideBuildingHud();
	}
	
	private static function onClickExit():Void { 
		BHHarvest.getInstance().removeButtonsChange();
		GameStage.getInstance().getGameContainer().interactive = false;
		Hud.getInstance().hideBuildingHud();
	}
	
	override public function destroy():Void {
		removeListenerGameContainer();
		instance = null;
		super.destroy();
	}
	
}