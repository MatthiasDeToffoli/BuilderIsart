package com.isartdigital.perle.game.virtual.vBuilding;

import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.virtual.VBuilding;

/**
 * ...
 * @author de Toffoli Matthias
 */
class VMarket extends VBuilding
{

	public function new(pDescription:TileDescription) 
	{
		alignementBuilding = Alignment.neutral;
		super(pDescription);
		
	}
	
}