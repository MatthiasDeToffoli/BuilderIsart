package com.isartdigital.perle.game.sprites;

import com.isartdigital.utils.game.BoxType;
import com.isartdigital.utils.game.StateGraphic;
import com.isartdigital.utils.game.factory.FlumpMovieAnimFactory;

/**
 * ...
 * @author COQUERELLE Killian
 */

class FlumpStateGraphic extends StateGraphic
{

	public function new(?pAssetName:String) {
		super();
		if (pAssetName != null)
			assetName = pAssetName;
	}
	
	// dans init plutôt que start, intervient plus tôt (code de Tile.hx auparavant)
	public function init():Void {
		if (factory == null)
			factory = new FlumpMovieAnimFactory();
		boxType = BoxType.SELF;
		setState(DEFAULT_STATE);
	}
	
}