package com.isartdigital.perle.game.virtual;
import com.isartdigital.perle.game.managers.SaveManager;

import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.sprites.Ground;

/**
 * Will be used for save
 * Will be used for Clipping
 * @author ambroise
 */
class VGround extends VCell {
	
	public function new(pDescription:TileDescription) {
		super(pDescription);
	}
	
	override public function activate():Void {
		super.activate();
		myInstance = Ground.createGround(tileDesc);
		linkVirtual();
	}
}