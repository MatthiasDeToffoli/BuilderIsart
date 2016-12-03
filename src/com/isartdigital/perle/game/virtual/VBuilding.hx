package com.isartdigital.perle.game.virtual;
import com.isartdigital.perle.game.managers.SaveManager;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.sprites.Building;

/**
 * Will contains every action that the building do whitout being displayed at screen (like giving money)
 * Will be used for save
 * Will be used for Clipping
 * @author ambroise
 */
class VBuilding extends VTile{
	
	public function new(pDescription:TileDescription) {
		super(pDescription);
		if (VTile.currentRegion.building == null)
			VTile.currentRegion.building = new Map<Int, Map<Int, VBuilding>>();
		if (VTile.currentRegion.building[positionClippingMap.x] == null)
			VTile.currentRegion.building[positionClippingMap.x] = new Map<Int, VBuilding>();
		
		VTile.currentRegion.building[positionClippingMap.x][positionClippingMap.y] = this;
	}
	
	override public function activate():Void {
		super.activate();
		myInstance = Building.createBuilding(tileDesc);
		linkVirtual();
	}	
}