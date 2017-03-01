package com.isartdigital.perle.game.sprites.building.heaven;

import com.isartdigital.perle.game.sprites.Building;

/**
 * ...
 * @author de Toffoli Matthias
 */
class MarketingHouse extends Building
{

	public function new(?pAssetName:String) 
	{
		super(pAssetName);
	}
	
	override public function setStateConstruction():Void 
	{
		assetName = AssetName.BUILDING_HEAVEN_HOUSE;
		super.setStateConstruction();
		assetName = AssetName.MARKETING_HOUSE;
	}
	
}