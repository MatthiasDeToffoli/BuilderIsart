package com.isartdigital.perle.ui.hud;

import com.isartdigital.perle.game.managers.RegionManager;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.managers.ServerManager;
import com.isartdigital.perle.game.sprites.Tile;
import com.isartdigital.perle.game.virtual.VTile;
import com.isartdigital.utils.Debug;
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
	private var regionType:Alignment;
	
	public function new(pPos:Point,pWorldPos:Point) 
	{
		
		factory = new FlumpMovieAnimFactory();
		assetName = "RegionButton";
		super();
		firstCasePos = pPos;
		worldMapPos = pWorldPos;
		regionType = (pPos.x < 0) ? Alignment.heaven: Alignment.hell;
	}
	
	override function _mouseDown(pEvent:EventTarget):Void {
		super._mouseDown(pEvent);	
		if (RegionManager.haveMoneyForBuy(worldMapPos, regionType)){
			RegionManager.createRegion(regionType, firstCasePos, VTile.pointToIndex(worldMapPos));
			destroy();
		}
		//ServerManager.addRegionToDataBase(regionType.getName(), VTile.pointToIndex(worldMapPos), VTile.pointToIndex(firstCasePos), this);		
	}
	
	override public function destroy():Void 
	{
		RegionManager.getButtonContainer().removeChild(this);
		super.destroy();
	}
	
}