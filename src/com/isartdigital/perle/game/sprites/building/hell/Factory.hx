package com.isartdigital.perle.game.sprites.building.hell;

import com.isartdigital.perle.game.sprites.Building;

/**
 * ...
 * @author de Toffoli Matthias
 */
class Factory extends Building
{
	//et ouais on en a une aussi :D
	public function new(?pAssetName:String) 
	{
		super(pAssetName);
	}
	
	override public function setStateConstruction():Void 
	{
		assetName = AssetName.BUILDING_HELL_HOUSE;
		super.setStateConstruction();
		assetName = AssetName.BUILDING_FACTORY;
	}
	
}