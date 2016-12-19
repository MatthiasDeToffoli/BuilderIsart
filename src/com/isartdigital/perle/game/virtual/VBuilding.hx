package com.isartdigital.perle.game.virtual;
import com.isartdigital.perle.game.managers.RegionManager;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.managers.TimeManager;
import com.isartdigital.perle.game.managers.TimeManager.TimeElementResource;
import com.isartdigital.perle.game.sprites.Building;
import com.isartdigital.perle.game.sprites.FlumpStateGraphic;

/**
 * Used for clipping.
 * Contain everything that's not just graphic.
 * @author ambroise
 */
class VBuilding extends VTile {
	
	//if we do a legacy of VBuilding, we have to give the right type
	private var myGenerator:Dynamic;
	
	public function new(pDescription:TileDescription) {
		super(pDescription);
		RegionManager.addToRegionBuilding(this);
		
		//for the test (let this for kiki)
		myGenerator = ResourcesManager.addSoftGenerator(tileDesc.id, 10);
	}
	
	override public function activate():Void {
		super.activate();
		var myBuilding:Building = Building.createBuilding(tileDesc);
		graphic = cast(myBuilding, FlumpStateGraphic);
		linkVirtual();
		
		myBuilding.goldBtn.setMyGenerator();
	}
	
	public function getGenerator():Dynamic {
		return myGenerator;
	}
	
}