package com.isartdigital.perle.game.sprites.building.heaven;

import com.isartdigital.perle.game.managers.AnimationManager;
import com.isartdigital.perle.game.sprites.Building;

/**
 * ...
 * @author de Toffoli Matthias
 */
class HouseHeaven extends Building
{

	public function new(?pAssetName:String) 
	{
		super(pAssetName);
	}
	
	override public function setStateConstruction():Void {
		//trace(assetName);
		setState(AssetName.CONSTRUCT);
	}
	
	override public function setStateEndConstruction():Void {
		setState(AssetName.CONSTRUCT + AssetName.ANIM);
		setAnimation();
		AnimationManager.manage(this);
	}
}