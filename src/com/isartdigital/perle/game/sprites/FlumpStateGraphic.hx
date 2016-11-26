package com.isartdigital.perle.game.sprites;

import com.isartdigital.utils.game.StateGraphic;
import com.isartdigital.utils.game.factory.FlumpMovieAnimFactory;

/**
 * ...
 * @author COQUERELLE Killian
 */

class FlumpStateGraphic extends StateGraphic
{

	public function new(pAsset:String=null) 
	{
		super();
		if (pAsset != null) assetName = pAsset;
	}
	
	override public function start():Void 
	{
		factory = new FlumpMovieAnimFactory();
		super.start();
		setState(DEFAULT_STATE);
	}
	
}