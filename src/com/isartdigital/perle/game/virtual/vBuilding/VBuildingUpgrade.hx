package com.isartdigital.perle.game.virtual.vBuilding;

import com.isartdigital.perle.game.managers.SaveManager;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.virtual.VBuilding;

/**
 * Class for the building'upgrade
 * @author Emeline Berenguier
 */
class VBuildingUpgrade extends VBuilding
{

	private var UpgradeAssetsList:Array<String>;
	
	public function new(pDescription:TileDescription) 
	{
		super(pDescription);
		
	}
	
	public function onClickUpgrade(pBuilding:VBuilding):Void{
		desactivate();
		
		var lAssetName = tileDesc.assetName;
		
		for (i in 0...UpgradeAssetsList.length){
			if (lAssetName == UpgradeAssetsList[i] && lAssetName != UpgradeAssetsList[UpgradeAssetsList.length - 1]){
				pBuilding.tileDesc.assetName = UpgradeAssetsList[i + 1];
				break;
			}
		}
		
		activate();
		addExp();
		SaveManager.save();
		
	}
	
	public function canUpgrade():Bool {
		return UpgradeAssetsList.indexOf(tileDesc.assetName) < UpgradeAssetsList.length - 1;
	}
}