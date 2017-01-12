package com.isartdigital.perle.game.virtual.vBuilding.vHeaven;

import com.isartdigital.perle.game.managers.SaveManager;
import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.virtual.vBuilding.VHouse;

/**
 * ...
 * @author de Toffoli Matthias
 */
class VHouseHeaven extends VHouse
{	
	public function new(pDescription:TileDescription) 
	{
		super(pDescription);
		alignementBuilding = Alignment.heaven;
		UpgradeAssetsList = [AssetName.BUILDING_HEAVEN_HOUSE, AssetName.BUILDING_HEAVEN_BUILD_1, AssetName.BUILDING_HEAVEN_BUILD_2];
	}
	
	override public function onClickUpgrade():Void 
	{
		super.onClickUpgrade();
	}
	
}