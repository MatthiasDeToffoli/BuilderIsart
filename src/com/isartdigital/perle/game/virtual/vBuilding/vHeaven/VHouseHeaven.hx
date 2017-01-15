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
		alignementBuilding = Alignment.heaven;
		super(pDescription);
		
		
		UpgradeAssetsList = [AssetName.BUILDING_HEAVEN_HOUSE, AssetName.BUILDING_HEAVEN_BUILD_1, AssetName.BUILDING_HEAVEN_BUILD_2];
		UpgradeGoldValuesList = ["200", "1000", "30 000"];
		UpgradeMaterialsValuesList = ["0", "340", "5340"];
		
		addPopulation(2);
		mapMaxPopulation[AssetName.BUILDING_HEAVEN_HOUSE] = 2;
		mapMaxPopulation[AssetName.BUILDING_HEAVEN_BUILD_1] = 6;
		mapMaxPopulation[AssetName.BUILDING_HEAVEN_BUILD_2] = 16;
	}
	
	override function addGenerator():Void 
	{
		valuesWin = [2.5, 3.75, 7.5];
		super.addGenerator();
	}
	
}