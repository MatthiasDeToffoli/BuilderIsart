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
		alignementBuilding = Alignment.hell;
		super(pDescription);
		
		UpgradeAssetsList = [AssetName.BUILDING_HELL_HOUSE, AssetName.BUILDING_HELL_BUILD_1, AssetName.BUILDING_HELL_BUILD_2];
		
		addPopulation(5);
		mapMaxPopulation[AssetName.BUILDING_HELL_HOUSE] = 5;
		mapMaxPopulation[AssetName.BUILDING_HELL_BUILD_1] = 15;
		mapMaxPopulation[AssetName.BUILDING_HELL_BUILD_2] = 40;
	}
	
	override function addGenerator():Void 
	{
		valuesWin = [1, 1.5, 3];
		super.addGenerator();
	}
	
}