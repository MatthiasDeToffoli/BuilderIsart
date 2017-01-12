package com.isartdigital.perle.game.virtual.vBuilding;

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
	}
	
	public function canUpgrade():Bool {
		return UpgradeAssetsList.indexOf(tileDesc.assetName) < UpgradeAssetsList.length - 1;
	}
}