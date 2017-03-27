package com.isartdigital.perle.game.virtual.vBuilding.vHell;

import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.sprites.Intern;
import com.isartdigital.perle.game.virtual.VBuilding.VBuildingState;
import com.isartdigital.perle.game.virtual.vBuilding.VInternHouse;

/**
 * ...
 * @author de Toffoli Matthias
 */
class VInternHouseHell extends VInternHouse
{

	public function new(pDescription:TileDescription) 
	{
		alignementBuilding = Alignment.hell;
		super(pDescription);
		if (currentState == VBuildingState.isBuilt) Intern.incrementeInternHouses(alignementBuilding);
		
	}
	
	override public function destroy(){
		Intern.decrementeInternHouses(Alignment.hell);
	}
	
}