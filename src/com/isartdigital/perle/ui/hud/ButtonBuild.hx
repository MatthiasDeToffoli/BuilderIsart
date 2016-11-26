package com.isartdigital.perle.ui.hud;
import com.isartdigital.perle.game.sprites.Building;
import com.isartdigital.utils.game.factory.MovieClipAnimFactory;
import com.isartdigital.utils.ui.Button;
import pixi.interaction.EventTarget;

/**
 * ...
 * @author ambroise
 */
class ButtonBuild extends Button{

	
	
	public function new(?pAssetName:String) {
		factory = new MovieClipAnimFactory();
		// assetName before because the super() does start.
		if (pAssetName != null)
			assetName = pAssetName;	
		super();
	}
	
	// _mouseDown better then _click for drag and drop on smartphone
	override function _mouseDown(pEvent:EventTarget):Void {
		super._mouseDown(pEvent);
		Building.onClickHudBuilding(assetName.substring(assetName.indexOf("Button"),- 1));
	}
	
}