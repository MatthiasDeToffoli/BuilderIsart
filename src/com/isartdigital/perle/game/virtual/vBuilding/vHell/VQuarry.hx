package com.isartdigital.perle.game.virtual.vBuilding.vHell;

import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.virtual.VBuilding;

/**
 * ...
 * @author de Toffoli Matthias
 */
class VQuarry extends VBuilding
{

	public function new(pDescription:TileDescription) 
	{
		super(pDescription);
		alignementBuilding = Alignment.hell;
	}
	
	override function addGenerator():Void 
	{
		myGeneratorType = GeneratorType.buildResourceFromHell;
		super.addGenerator();
	}
	
}