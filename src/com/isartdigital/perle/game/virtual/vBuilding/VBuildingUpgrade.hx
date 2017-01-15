package com.isartdigital.perle.game.virtual.vBuilding;

import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.managers.TimeManager;
import com.isartdigital.perle.game.virtual.VBuilding;
import com.isartdigital.perle.ui.hud.building.BuildingHud;

/**
 * Class for the building'upgrade
 * @author Emeline Berenguier
 */
class VBuildingUpgrade extends VBuilding
{

	private var UpgradeAssetsList:Array<String>;
	public var UpgradeGoldValuesList:Array<String>;
	public var UpgradeMaterialsValuesList:Array<String>;
	
	public var indexLevel:Int;
	
	public function new(pDescription:TileDescription) 
	{
		super(pDescription);
		indexLevel = 0;
		
	}
	
	public function onClickUpgrade():Void{
		desactivate();
		
		var lAssetName = tileDesc.assetName;
		
		if (indexLevel <= 3){
			indexLevel++;
			tileDesc.assetName = UpgradeAssetsList[indexLevel];
		}
		
		var tTime:Float = Date.now().getTime();
		tileDesc.timeDesc = { refTile:tileDesc.id,  end: tTime + 20000, progress: 0, creationDate: tTime };
		currentState = TimeManager.getBuildingStateFromTime(tileDesc);
		TimeManager.addConstructionTimer(tileDesc.timeDesc);
		if (currentState == VBuildingState.isBuilding) TimeManager.eConstruct.on(TimeManager.EVENT_CONSTRUCT_END, endOfConstruction);
		
		activate();
		addExp();		
		myGenerator = ResourcesManager.UpdateResourcesGenerator(myGenerator, 20, 8000); //@TODO : mettre de vrais valeur...
		
		SaveManager.save();	
	}
	
	public function canUpgrade():Bool {
		return UpgradeAssetsList.indexOf(tileDesc.assetName) < UpgradeAssetsList.length - 1;
	}
	
	//public function getLevel():Int{
		//return UpgradeAssetsList.indexOf(tileDesc.assetName);
	//}
}