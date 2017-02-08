package com.isartdigital.perle.game.virtual.vBuilding;

import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.virtual.VBuilding;

/**
 * ...
 * @author de Toffoli Matthias
 */
class VInternHouse extends VBuilding
{

	public function new(pDescription:TileDescription) 
	{
		super(pDescription);	
	}
	
	override function setHaveRecolter():Void 
	{
		haveRecolter = false;
	}
	
}