package com.isartdigital.perle.game.sprites;

import com.isartdigital.perle.game.managers.PoolingManager;
import com.isartdigital.perle.game.virtual.VCell;
import com.isartdigital.utils.game.BoxType;
import com.isartdigital.utils.game.factory.MovieClipAnimFactory;
import com.isartdigital.perle.game.iso.IsoManager;
import com.isartdigital.utils.game.StateGraphic;
import pixi.core.math.Point;

/**
 * ...
 * @author ambroise
 */
class Tile extends StateGraphic
{ 
	public static inline var TILE_WIDTH:Float = 200;
	public static inline var TILE_HEIGHT:Float = 100;
	
	/**
	 * Reference usable to destroy VCell an so by the same way from Save
	 * Still, the best choice would be to destroy VCell first and then just update Clipping
	 * Unused for now (you can't destroy buidings for now, the only way is to destroy Save !)
	 */
	private var linkedVirtualCell:VCell;
	
	public static function initClass():Void {
		IsoManager.init(TILE_WIDTH, TILE_HEIGHT);
		Ground.initClass();
		Building.initClass();
	}
	
	private function positionTile(pGridX:Int, pGridY:Int):Void {
		position = IsoManager.modelToIsoView(new Point(pGridX, pGridY));
	}
	
	public function new(?pAssetName:String) {
		super();
		if (pAssetName != null)
			assetName = pAssetName;
	}
	
	public function linkVirtualCell(lVCell:VCell):Void {
		linkedVirtualCell = lVCell;
	}
	
	public function init():Void {
		if (factory == null)
			factory = new MovieClipAnimFactory();
		boxType = BoxType.SELF;
		setState(DEFAULT_STATE);
	}
	
	public function getAssetName():String {
		return assetName;
	}
	
	// implement recycle ? pas nécessaire ! pr l'instant, bah poolingo non plus..
	public function recycle():Void {
		linkedVirtualCell = null;
		setModeVoid();
		parent.removeChild(this);
		// => Type.getClassName(Type.getClass(this)) ? (if you want className)
		PoolingManager.addToPool(this, assetName);
	}
	
	/**
	 * If you want to remove the tile (from save) you need to destroy the VCell
	 */
	override public function destroy():Void {
		linkedVirtualCell.removeLink();
		linkedVirtualCell = null;
		setModeVoid();
		parent.removeChild(this);
	}
}