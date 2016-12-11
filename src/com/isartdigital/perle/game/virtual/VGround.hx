package com.isartdigital.perle.game.virtual;
import com.isartdigital.perle.game.managers.RegionManager;
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
		
		RegionManager.addToRegionGround(this);
	}
	
	override public function activate():Void {

		super.activate();
		myInstance = Ground.createGround(tileDesc);
		linkVirtual();
	}
}