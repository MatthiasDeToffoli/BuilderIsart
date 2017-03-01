package com.isartdigital.perle.game.sprites.building.heaven;
import com.isartdigital.perle.game.sprites.Building;
import com.isartdigital.perle.ui.hud.building.BuildingHud;

/**
 * ...
 * @author de Toffoli Matthias
 */
class CollectorHeaven extends Building
{

	public function new(?pAssetName:String) 
	{
		super(pAssetName);
	}
	
	override public function setStateConstruction():Void 
	{
		assetName = AssetName.BUILDING_HEAVEN_HOUSE;
		super.setStateConstruction();		
		
		if (myDesc.level < 2) assetName = AssetName.BUILDING_HEAVEN_COLLECTOR_LEVEL1;
		else assetName = AssetName.BUILDING_HEAVEN_COLLECTOR_LEVEL2;
	}
	
}