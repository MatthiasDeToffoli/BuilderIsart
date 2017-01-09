package com.isartdigital.perle.game.virtual.vBuilding.vHell;

import com.isartdigital.perle.game.managers.SaveManager.RegionType;
import com.isartdigital.perle.game.virtual.vBuilding.VGoldGeneratorBuilding;

/**
 * ...
 * @author de Toffoli Matthias
 */
class VSoulWell extends VGoldGeneratorBuilding
{

	public function new(?pAssetName:String) 
	{
		super(pAssetName);
		alignementBuilding = RegionType.hell;
	}
	
}