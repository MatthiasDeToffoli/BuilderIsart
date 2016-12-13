package com.isartdigital.perle.game.virtual;
import com.isartdigital.perle.game.managers.RegionManager;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.sprites.Building;
import com.isartdigital.perle.game.sprites.FlumpStateGraphic;

/**
 * Will contains every action that the building do whitout being displayed at screen (like giving money)
 * Will be used for save
 * Will be used for Clipping
 * @author ambroise
 */
class VBuilding extends VTile{
	
	public function new(pDescription:TileDescription) {
		super(pDescription);
		
		RegionManager.addToRegionBuilding(this);
	}
	
	override public function activate():Void {
		super.activate();
		graphic = cast(Building.createBuilding(tileDesc), FlumpStateGraphic);
		linkVirtual();
	}	
}