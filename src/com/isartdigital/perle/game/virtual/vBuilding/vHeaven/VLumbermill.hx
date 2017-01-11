package com.isartdigital.perle.game.virtual.vBuilding.vHeaven;

import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.virtual.VBuilding;

/**
 * ...
 * @author de Toffoli Matthias
 */
class VLumbermill extends VBuilding
{

	public function new(pDescription:TileDescription) 
	{
		super(pDescription);
		alignementBuilding = Alignment.heaven;
	}
	
	override function addGenerator():Void 
	{
		myGeneratorType = GeneratorType.buildResourceFromParadise;
		super.addGenerator();
	}
	
	
}