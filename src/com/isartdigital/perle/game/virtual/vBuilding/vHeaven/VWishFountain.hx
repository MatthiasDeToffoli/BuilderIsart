package com.isartdigital.perle.game.virtual.vBuilding.vHeaven;

import com.isartdigital.perle.game.managers.SaveManager.Alignment;w
import com.isartdigital.perle.game.virtual.vBuilding.VGoldGeneratorBuilding;

/**
 * ...
 * @author de Toffoli Matthias
 */
class VWishFountain extends VGoldGeneratorBuilding
{

	public function new(?pAssetName:String) 
	{
		alignementBuilding = Alignment.heaven;
		super(pAssetName);
		
		
	}
	
}