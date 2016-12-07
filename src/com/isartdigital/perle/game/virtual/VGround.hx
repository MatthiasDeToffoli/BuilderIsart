package com.isartdigital.perle.game.virtual;
import com.isartdigital.perle.game.managers.SaveManager;

import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.sprites.Ground;

/**
 * Will be used for save
 * Will be used for Clipping
 * @author ambroise
 */
class VGround extends VTile {
	
	public function new(pDescription:TileDescription) {
		super(pDescription);
		
		if (VTile.currentRegion.ground == null)
			VTile.currentRegion.ground = new Map<Int, Map<Int, VGround>>();
		if (VTile.currentRegion.ground[positionClippingMap.x] == null)
			VTile.currentRegion.ground[positionClippingMap.x] = new Map<Int, VGround>();
		
		VTile.currentRegion.ground[positionClippingMap.x][positionClippingMap.y] = this;
	}
	
	override public function activate():Void {

		super.activate();
		myInstance = Ground.createGround(tileDesc);
		linkVirtual();
	}
}