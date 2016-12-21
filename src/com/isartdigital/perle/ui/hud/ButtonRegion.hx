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

 /**
  * button which add new region
  */
class ButtonRegion extends Button
{

	/**
	 * the first case of the region to add
	 */
	private var firstCasePos:Point;
	
	/**
	 * position of the region in world map
	 */
	private var worldMapPos:Point;
	
	/**
	 * the type of the region to add
	 */
	private var regionType:RegionType;
	
	public function new(pPos:Point,pWorldPos:Point) 
	{
		
		factory = new FlumpMovieAnimFactory();
		assetName = "RegionButton";
		super();
		firstCasePos = pPos;
		worldMapPos = pWorldPos;
		regionType = (pPos.x < 0) ? RegionType.eden: RegionType.hell;
	}
	
	override function _mouseDown(pEvent:EventTarget):Void {
		super._mouseDown(pEvent);
		
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