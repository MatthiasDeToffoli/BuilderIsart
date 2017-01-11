package com.isartdigital.perle.game.virtual.vBuilding.vHell;

import com.isartdigital.perle.game.managers.SaveManager;
import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.virtual.VBuilding;
import com.isartdigital.perle.game.virtual.vBuilding.VHouse;

/**
 * ...
 * @author de Toffoli Matthias
 */
class VHouseHell extends VHouse
{
	public function new(pDescription:TileDescription) 
	{
		super(pDescription);
		alignementBuilding = Alignment.hell;
		UpgradeAssetsList = [AssetName.BUILDING_HELL_HOUSE, AssetName.BUILDING_HELL_BUILD_1, AssetName.BUILDING_HELL_BUILD_2];
	}
	
	override public function onClickUpgrade(pBuilding:VBuilding):Void 
	{
		super.onClickUpgrade(pBuilding);
		var lAssetName = pBuilding.tileDesc.assetName;
		
		for (i in 0...UpgradeAssetsList.length){
			if (lAssetName == UpgradeAssetsList[i] && lAssetName != UpgradeAssetsList[UpgradeAssetsList.length - 1]){
				pBuilding.tileDesc.assetName = UpgradeAssetsList[i + 1];
				break;
			}
		}
		
		activate();
		SaveManager.save();
	}
	
}