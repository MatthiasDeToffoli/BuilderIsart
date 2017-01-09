package com.isartdigital.perle.game.virtual.vBuilding.vHeaven;

import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.virtual.vBuilding.VHouse;

/**
 * ...
 * @author de Toffoli Matthias
 */
class VHouseHeaven extends VHouse
{

	public function new(pDescription:TileDescription) 
	{
		super(pDescription);
		alignementBuilding = Alignment.heaven;
	}
	
}