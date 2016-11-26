package com.isartdigital.utils.ui.smart;

import com.isartdigital.utils.game.factory.FlumpSpriteAnimFactory;
import com.isartdigital.utils.game.StateGraphic;

/**
 * ...
 * @author Mathieu Anthoine
 */
class UISprite extends StateGraphic
{

	public function new(pAssetName:String) 
	{
		super();
		assetName = pAssetName;
		factory = new FlumpSpriteAnimFactory();
		setState(DEFAULT_STATE);
	}
	
}