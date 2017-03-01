package com.isartdigital.perle.game.sprites.building.hell;
import com.isartdigital.perle.game.managers.AnimationManager;
import com.isartdigital.perle.game.sprites.Building;
import com.isartdigital.perle.game.virtual.VBuilding;
import com.isartdigital.perle.ui.hud.building.BuildingHud;

/**
 * ...
 * @author de Toffoli Matthias
 */
class CollectorHell extends Building
{

	public function new(?pAssetName:String) 
	{
		super(pAssetName);
		
	}
	
	override public function setStateConstruction():Void 
	{
		assetName = AssetName.BUILDING_HELL_HOUSE;
		super.setStateConstruction();
		
		if (myDesc.level < 2) assetName = AssetName.BUILDING_HELL_COLLECTOR_LEVEL1;
		else assetName = AssetName.BUILDING_HELL_COLLECTOR_LEVEL2;
	}
	
}