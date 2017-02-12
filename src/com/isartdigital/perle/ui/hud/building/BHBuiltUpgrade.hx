package com.isartdigital.perle.ui.hud.building;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.managers.UnlockManager;
import com.isartdigital.perle.game.virtual.vBuilding.VBuildingUpgrade;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.ui.smart.SmartButton;

/**
 * ...
 * @author Alexis
 */
class BHBuiltUpgrade extends BHBuilt
{
	
	private var btnUpgrade:SmartButton;
	private var vBuildingIsUpgradable:Bool;

	public function new(pID:String=null) 
	{
		vBuildingIsUpgradable = haveUpgradeBtn();
		super(pID);
		
	}
	
	override function findElements():Void 
	{
		super.findElements();
		if (vBuildingIsUpgradable && haveUpgradeBtn()) {
			btnUpgrade = cast(getChildByName("ButtonUpgradeBuilding"), SmartButton);
		}
	}
	
	private function haveUpgradeBtn():Bool {
		return checkLevelPlayerToUpgrade();
	}
	
	override function removeButtonsChange():Void 
	{
		super.removeButtonsChange();
		if(vBuildingIsUpgradable) btnUpgrade.removeAllListeners();
	}
	
	override public function setOnSpawn():Void 
	{
		if (vBuildingIsUpgradable) Interactive.addListenerClick(btnUpgrade, onClickUpgrade);

		super.setOnSpawn();
	}
	
	private function checkLevelPlayerToUpgrade():Bool {
		var lBuidling:TileDescription = cast(BuildingHud.virtualBuilding, VBuildingUpgrade).getTileDesc();
		return UnlockManager.checkIfUnlocked(lBuidling.buildingName, lBuidling.level + 1);
	}
	
	private function onClickUpgrade(): Void {
		removeButtonsChange();
		removeListenerGameContainer();
		cast(BuildingHud.virtualBuilding, VBuildingUpgrade).onClickUpgrade();
		Hud.getInstance().hideBuildingHud();
	}
	
	override public function destroy():Void 
	{
		if (vBuildingIsUpgradable)
			Interactive.removeListenerClick(btnUpgrade, onClickUpgrade);
		super.destroy();
	}
	
}