package com.isartdigital.perle.ui.hud;

import com.isartdigital.utils.game.factory.FlumpMovieAnimFactory;
import com.isartdigital.utils.ui.Button;
import pixi.interaction.EventTarget;

/**
 * ...
 * @author de Toffoli Matthias
 */
class ButtonRegion extends Button
{

	public function new() 
	{

		factory = new FlumpMovieAnimFactory();
		//@TODO change this for add a asset name for a simple button. This is for test !
		assetName = "Villa";
		super();
		
	}
	
	override function _mouseDown(pEvent:EventTarget):Void {
		super._mouseDown(pEvent);
		trace("Create a region");
	}
	
}