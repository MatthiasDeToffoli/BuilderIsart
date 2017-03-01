package com.isartdigital.perle.game.sprites.building.heaven;
import com.isartdigital.perle.game.sprites.Building;


/**
 * ...
 * @author de Toffoli Matthias
 */
class InternHouseHeaven extends Building
{

	public function new(?pAssetName:String) 
	{
		super(pAssetName);
		
	}
	
	override public function setStateConstruction():Void 
	{
		assetName = AssetName.BUILDING_HEAVEN_HOUSE;
		super.setStateConstruction();
		assetName = AssetName.BUILDING_INTERN_HEAVEN_HOUSE;
	}
	
}