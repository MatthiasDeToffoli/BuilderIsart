package com.isartdigital.utils.ui.smart;

import com.isartdigital.utils.game.StateGraphic;
import com.isartdigital.utils.game.factory.FlumpMovieAnimFactory;

/**
 * ...
 * @author Mathieu Anthoine
 */
class UIMovie extends StateGraphic
{

	public function new(pAssetName:String) 
	{
		super();
		assetName = pAssetName;
		factory = new FlumpMovieAnimFactory();
		setState(DEFAULT_STATE,true);
	}
	
}