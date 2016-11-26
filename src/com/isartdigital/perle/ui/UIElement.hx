package com.isartdigital.perle.ui;

import com.isartdigital.utils.game.factory.MovieClipAnimFactory;
import com.isartdigital.utils.game.StateGraphic;

/**
 * ...
 * @author ambroise
 */
class UIElement extends StateGraphic{

	public function new(pAssetName:String) {
		super();
		factory = new MovieClipAnimFactory();
		assetName = pAssetName;
		setState(DEFAULT_STATE);
	}
}