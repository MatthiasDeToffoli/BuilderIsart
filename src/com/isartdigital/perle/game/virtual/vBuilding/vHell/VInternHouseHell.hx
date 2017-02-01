package com.isartdigital.perle.game.virtual.vBuilding.vHell;

import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.virtual.vBuilding.VInternHouse;

/**
 * ...
 * @author de Toffoli Matthias
 */
class VInternHouseHell extends VInternHouse
{

	public function new(pDescription:TileDescription) 
	{
		trace("vInternHouseHell");
		alignementBuilding = Alignment.hell;
		super(pDescription);
		

	}
	
}