package com.isartdigital.perle.game.virtual.vBuilding.vHell;

import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager;
import com.isartdigital.perle.game.managers.SaveManager.Alignment;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.virtual.VBuilding;
import com.isartdigital.perle.game.virtual.vBuilding.VHouse;

/**
 * ...
 * @author de Toffoli Matthias
 */
class VHouseHell extends VHouse
{
	public function new(pDescription:TileDescription) 
	{
		alignementBuilding = Alignment.hell;
		super(pDescription);
	}
	
	public function addForFtue():Void {
		myPopulation.quantity = myPopulation.max;	
		ResourcesManager.updatePopulation(myPopulation, alignementBuilding);
		ResourcesManager.increaseResources(myGenerator, myGenerator.desc.max);
		myGenerator = {desc:ResourcesManager.getGenerator(tileDesc.id, myGeneratorType)};
	}
	
}