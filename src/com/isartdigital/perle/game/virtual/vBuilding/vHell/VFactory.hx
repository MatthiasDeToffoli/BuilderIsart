package com.isartdigital.perle.game.virtual.vBuilding.vHell;

import com.isartdigital.perle.game.sprites.Building;

/**
 * ...
 * @author de Toffoli Matthias
 */
class VFactory extends Building
{

	public function new(?pAssetName:String) 
	{
		super(pAssetName);
		alignementBuilding = VBuilding.ALIGNEMENT_HELL;
	}
	
}