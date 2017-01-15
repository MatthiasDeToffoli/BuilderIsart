package com.isartdigital.perle.game.virtual.vBuilding.vHeaven;

import com.isartdigital.perle.game.managers.SaveManager.RegionType;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.virtual.vBuilding.VCollector;

/**
 * ...
 * @author de Toffoli Matthias
 */
class VCollectorHeaven extends VCollector
{

	public function new(pDescription:TileDescription) 
	{
		alignementBuilding = RegionType.eden;
		super(pDescription);
		
	}
	
}