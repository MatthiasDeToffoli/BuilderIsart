package com.isartdigital.perle.game.virtual.vBuilding.vHell;

import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.virtual.vBuilding.VHouse;

/**
 * ...
 * @author de Toffoli Matthias
 */
class VHouseHell extends VHouse
{

	public function new(pDescription:TileDescription) 
	{
		super(pDescription);
		alignementBuilding = Alignment.hell;
	}
	
}