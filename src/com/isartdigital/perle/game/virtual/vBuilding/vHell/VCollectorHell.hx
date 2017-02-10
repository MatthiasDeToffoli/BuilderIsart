package com.isartdigital.perle.game.virtual.vBuilding.vHell;

import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
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
		alignementBuilding = Alignment.hell;
		super(pDescription);
		
		
	}
	
	override function addGenerator():Void 
	{
		myGeneratorType = GeneratorType.buildResourceFromHell;
		super.addGenerator();
	}
}