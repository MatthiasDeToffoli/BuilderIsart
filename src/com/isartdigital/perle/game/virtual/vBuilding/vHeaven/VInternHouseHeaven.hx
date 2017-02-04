package com.isartdigital.perle.game.virtual.vBuilding.vHeaven;

import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.sprites.Intern;
import com.isartdigital.perle.game.virtual.vBuilding.VInternHouse;

/**
 * ...
 * @author de Toffoli Matthias
 */
class VInternHouseHeaven extends VInternHouse
{

	public function new(pDescription:TileDescription) 
	{
		alignementBuilding = Alignment.heaven;
		Intern.incrementeInternHouses(alignementBuilding);
		super(pDescription);
		
	}
	
	override public function destroy(){
		Intern.decrementeInternHouses(Alignment.heaven);
	}
}