package com.isartdigital.perle.ui.hud;

import com.isartdigital.perle.game.managers.RegionManager;
import com.isartdigital.utils.game.factory.FlumpMovieAnimFactory;
import com.isartdigital.utils.ui.Button;
import pixi.core.math.Point;
import pixi.interaction.EventTarget;

/**
 * ...
 * @author de Toffoli Matthias
 */
class ButtonRegion extends Button
{

	private var firstCasePos:Point;
	private var worldMapPos:Point;
	
	public function new(pPos:Point,pWorldPos:Point) 
	{

		
		factory = new FlumpMovieAnimFactory();
		//@TODO change this for add a asset name for a simple button. This is for test !
		assetName = "Villa";
		super();
		firstCasePos = pPos;
		worldMapPos = pWorldPos;
	}
	
	override function _mouseDown(pEvent:EventTarget):Void {
		super._mouseDown(pEvent);
		
		// todo destroy()
		
		RegionManager.activeRegion(
			firstCasePos,
			{
				x: cast(worldMapPos.x, Int),
				y: cast(worldMapPos.y, Int)
			}
		);
		
		destroy();
		
	}
	
	override public function destroy():Void 
	{
		RegionManager.getButtonContainer().removeChild(this);
		super.destroy();
	}
	
}