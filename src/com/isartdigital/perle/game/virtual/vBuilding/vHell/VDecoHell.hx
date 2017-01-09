package com.isartdigital.perle.game.virtual.vBuilding.vHell;

import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.virtual.vBuilding.VDeco;

/**
 * ...
 * @author Rafired
 */
class VDecoHell extends VDeco
{

	public function new(pDescription:TileDescription) 
	{
		super(pDescription);
		alignementBuilding = Alignment.hell;
	}
	
}