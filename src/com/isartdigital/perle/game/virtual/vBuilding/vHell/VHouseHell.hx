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
	
	private static inline var FTUE_SOUL_INHOUSE:Int = 3;
	public function new(pDescription:TileDescription) 
	{
		alignementBuilding = Alignment.hell;
		super(pDescription);
	}
	
	public function addForFtue():Void {
		ResourcesManager.increaseResources(myGenerator, myGenerator.desc.max);
		ResourcesManager.UpdateResourcesGenerator(myGenerator, myMaxContains, myTime);
		updatePopulation(FTUE_SOUL_INHOUSE);
	}
	
}