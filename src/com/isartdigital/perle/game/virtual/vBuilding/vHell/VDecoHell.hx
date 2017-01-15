package com.isartdigital.perle.game.virtual.vBuilding.vHell;

import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.virtual.vBuilding.VDeco;

/**
 * ...
 * @author Alexis
 */
class VDecoHell extends VDeco
{

	public function new(pDescription:TileDescription) 
	{
		alignementBuilding = Alignment.hell;
		super(pDescription);
		
	}
	
}