package com.isartdigital.perle.ui.hud.building;
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

	public function new(pID:String=null) 
	{
		super(pID);
		
	}
	
	override function findElements():Void 
	{
		super.findElements();
		if(haveUpgradeBtn()) btnUpgrade = cast(getChildByName("ButtonUpgradeBuilding"), SmartButton);
	}
	
	private function haveUpgradeBtn():Bool {
		return true;
	}
	override function removeButtonsChange():Void 
	{
		super.removeButtonsChange();
		if(haveUpgradeBtn()) btnUpgrade.removeAllListeners();
	}
	
	override public function setOnSpawn():Void 
	{
		if(haveUpgradeBtn()) Interactive.addListenerClick(btnUpgrade, onClickUpgrade);
		super.setOnSpawn();
	}
	
	private function onClickUpgrade(): Void {
		removeButtonsChange();
		removeListenerGameContainer();
		cast(BuildingHud.virtualBuilding, VBuildingUpgrade).onClickUpgrade();
		Hud.getInstance().hideBuildingHud();
	}
	
	override public function destroy():Void 
	{
		if(haveUpgradeBtn()) Interactive.removeListenerClick(btnUpgrade, onClickUpgrade);
		super.destroy();
	}
	
}