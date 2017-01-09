package com.isartdigital.perle.game.virtual.vBuilding.vHeaven;

import com.isartdigital.perle.game.managers.SaveManager.RegionType;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.virtual.VBuilding;

/**
 * ...
 * @author Rafired
 */
class VDecoHeaven extends VBuilding
{

	public function new(pDescription:TileDescription) 
	{
		super(pDescription);
		
		alignementBuilding = RegionType.eden;
	}
	
}