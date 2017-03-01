package com.isartdigital.perle.game.sprites.building.hell;
import com.isartdigital.perle.game.managers.AnimationManager;
import com.isartdigital.perle.game.sprites.Building;


/**
 * ...
 * @author de Toffoli Matthias
 */
class InternHouseHell extends Building
{

	public function new(?pAssetName:String) 
	{
		super(pAssetName);
	}
	
	override public function setStateConstruction():Void 
	{
		assetName = AssetName.BUILDING_HELL_HOUSE;
		super.setStateConstruction();
		assetName = AssetName.BUILDING_INTERN_HELL_HOUSE;
	}
	
}