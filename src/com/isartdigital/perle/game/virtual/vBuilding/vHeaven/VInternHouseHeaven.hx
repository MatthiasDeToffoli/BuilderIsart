package com.isartdigital.perle.game.virtual.vBuilding.vHeaven;

import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.virtual.vBuilding.VInternHouse;

/**
 * ...
 * @author de Toffoli Matthias
 */
class VInternHouseHeaven extends VInternHouse
{

	public function new(pDescription:TileDescription) 
	{
		super(pDescription);
		alignementBuilding = VBuilding.ALIGNEMENT_HEAVEN;
		
	}
	
}