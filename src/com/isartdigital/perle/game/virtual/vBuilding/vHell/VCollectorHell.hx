package com.isartdigital.perle.game.virtual.vBuilding.vHell;

import com.isartdigital.perle.game.managers.SaveManager.RegionType;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.virtual.vBuilding.VCollector;

/**
 * ...
 * @author de Toffoli Matthias
 */
class VCollectorHell extends VCollector
{

	public function new(pDescription:TileDescription) 
	{
		super(pDescription);
		
		alignementBuilding = RegionType.hell;
	}
	
}