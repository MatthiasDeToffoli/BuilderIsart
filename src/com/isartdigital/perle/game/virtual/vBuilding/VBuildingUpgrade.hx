package com.isartdigital.perle.game.virtual.vBuilding;

import com.isartdigital.perle.game.managers.ResourcesManager;
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
	private var indexLevel:Int;
	
	public function new(pDescription:TileDescription) 
	{
		super(pDescription);
		indexLevel = 0;
		
	}
	
	public function onClickUpgrade():Void{
		desactivate();
		
		var lAssetName = tileDesc.assetName;
		
		if (indexLevel != 2){
			indexLevel++;
			tileDesc.assetName = UpgradeAssetsList[indexLevel];
		}
		
		activate();
		addExp();
		myGenerator = ResourcesManager.UpdateResourcesGenerator(myGenerator, 20, 8000); //@TODO : mettre de vrais valeur...
		SaveManager.save();
		
	}
	
	public function canUpgrade():Bool {
		return UpgradeAssetsList.indexOf(tileDesc.assetName) < UpgradeAssetsList.length - 1;
	}
}