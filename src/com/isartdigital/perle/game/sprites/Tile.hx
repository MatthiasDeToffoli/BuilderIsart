package com.isartdigital.perle.game.sprites;

import com.isartdigital.perle.game.iso.IsoManager;
import com.isartdigital.perle.game.managers.PoolingManager;
import com.isartdigital.perle.game.virtual.Virtual;
import com.isartdigital.perle.game.virtual.Virtual.HasVirtual;
import com.isartdigital.perle.game.virtual.VTile;
import pixi.core.math.Point;


/**
 * ...
 * @author ambroise
 */
class Tile extends FlumpStateGraphic implements HasVirtual
{ 
	public static inline var TILE_WIDTH:Float = 200;
	public static inline var TILE_HEIGHT:Float = 100;
	
	/**
	 * Reference usable to destroy VCell an so by the same way from Save
	 * Still, the best choice would be to destroy VCell first and then just update Clipping
	 * Unused for now (you can't destroy buidings for now, the only way is to destroy Save !)
	 */
	public var linkedVirtualCell:VTile;
	
	public static function initClass():Void {
		IsoManager.init(TILE_WIDTH, TILE_HEIGHT);
		FootPrint.initClass();
		Ground.initClass();
		Building.initClass();
	}
	
	private function positionTile(pTileX:Int, pTileY:Int):Void { // todo :opti
		position = IsoManager.modelToIsoView(new Point(
			pTileX,
			pTileY
		));
	}
	
	
	public function new(?pAssetName:String) {
		super(pAssetName);
	}
	
	public function linkVirtual(pVirtual:Virtual):Void {
		linkedVirtualCell = cast(pVirtual, VTile);
	}
	
	public function getAssetName():String {
		return assetName;
	}
	
	// implement recycle ? pas nécessaire ! pr l'instant, bah poolingo non plus..
	public function recycle():Void {
		linkedVirtualCell = null;
		setModeVoid();
		
		if (parent != null) parent.removeChild(this);
		//parent.removeChild(this);
		// => Type.getClassName(Type.getClass(this)) ? (if you want className)
		PoolingManager.addToPool(this, assetName);
	}
	
	/**
	 * If you want to remove the tile (from save) you need to destroy the VCell
	 */
	override public function destroy():Void {
		if (linkedVirtualCell != null) // only happen for phantom !
			linkedVirtualCell.removeLink();
		linkedVirtualCell = null;
		setModeVoid();
		parent.removeChild(this);
	}
}