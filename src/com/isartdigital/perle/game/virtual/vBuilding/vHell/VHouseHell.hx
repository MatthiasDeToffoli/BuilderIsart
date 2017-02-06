package com.isartdigital.perle.game.virtual.vBuilding.vHell;

import com.isartdigital.perle.game.managers.ResourcesManager;
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
		alignementBuilding = Alignment.hell;
		super(pDescription);
		
		UpgradeAssetsList = [AssetName.BUILDING_HELL_HOUSE, AssetName.BUILDING_HELL_HOUSE_LEVEL2, AssetName.BUILDING_HELL_HOUSE_LEVEL3];
		UpgradeGoldValuesList = ["600", "20 000"];
		UpgradeMaterialsValuesList = ["200", "4000"];
		
		
		addPopulation(5);
		mapMaxPopulation[AssetName.BUILDING_HELL_HOUSE] = 5;
		mapMaxPopulation[AssetName.BUILDING_HELL_HOUSE_LEVEL2] = 15;
		mapMaxPopulation[AssetName.BUILDING_HELL_HOUSE_LEVEL3] = 40;
	}
	
	public function addForFtue():Void {
		myPopulation.quantity = myPopulation.max;	
		ResourcesManager.updatePopulation(myPopulation, alignementBuilding);
		ResourcesManager.increaseResources(myGenerator, myGenerator.desc.max);
		myGenerator = {desc:ResourcesManager.getGenerator(tileDesc.id, myGeneratorType)};
	}
	
	override function addGenerator():Void 
	{
		valuesWin = [1, 1.5, 3];
		super.addGenerator();
	}
	
}