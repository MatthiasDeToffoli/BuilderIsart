package com.isartdigital.perle.game.virtual.vBuilding;

import com.isartdigital.perle.game.managers.SaveManager.RegionType;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.virtual.VBuilding;

/**
 * ...
 * @author Alexis
 */
class VVicesBuilding extends VBuilding
{

	public function new(pDescription:TileDescription) 
	{
		super(pDescription);
		alignementBuilding = RegionType.styx;
		
	}
	
}