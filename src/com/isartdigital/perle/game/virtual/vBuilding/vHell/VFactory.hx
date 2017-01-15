package com.isartdigital.perle.game.virtual.vBuilding.vHell;

import com.isartdigital.perle.game.managers.SaveManager.Alignment;

import com.isartdigital.perle.game.sprites.Building;

/**
 * ...
 * @author de Toffoli Matthias
 */
class VFactory extends Building
{

	public function new(?pAssetName:String) 
	{
		alignementBuilding = Alignment.hell;
		super(pAssetName);
		
	}
	
}