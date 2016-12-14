package com.isartdigital.perle.ui.hud;

import com.isartdigital.perle.game.managers.RegionManager;
import com.isartdigital.perle.game.managers.SaveManager.RegionType;
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
	private var regionType:RegionType;
	
	public function new(pPos:Point,pWorldPos:Point) 
	{

		
		factory = new FlumpMovieAnimFactory();
		//@TODO change this for add a asset name for a simple button. This is for test !
		assetName = "RegionButton";
		super();
		firstCasePos = pPos;
		worldMapPos = pWorldPos;
		regionType = RegionType.hell;
	}
	
	override function _mouseDown(pEvent:EventTarget):Void {
		super._mouseDown(pEvent);
		
		// todo destroy()
		
		RegionManager.createRegion(
			regionType,
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