package com.isartdigital.utils.ui.smart;

import com.isartdigital.utils.game.StateGraphic;
import com.isartdigital.utils.game.factory.FlumpMovieAnimFactory;
import pixi.flump.Movie;

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
		setState(DEFAULT_STATE, true);
	}
	
	public function goToAndStop(i:Int):Void {
		cast(anim, Movie).gotoAndStop(i);
	}
	
}