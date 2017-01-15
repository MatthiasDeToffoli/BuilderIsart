package com.isartdigital.perle.game.virtual.vBuilding;

import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.ResourcesManager.Population;
import com.isartdigital.perle.game.managers.SaveManager;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.managers.TimeManager;
import com.isartdigital.perle.game.managers.TimeManager.EventResoucreTick;
import com.isartdigital.perle.game.virtual.VBuilding;

/**
 * ...
 * @author de Toffoli Matthias
 */
class VHouse extends VBuildingUpgrade
{

	private var myPopulation:Population;
	private var mapMaxPopulation:Map<String, Int>;
	private var maxResources:Array<Float>;
	private var valuesWin:Array<Float>;
	
	public function new(pDescription:TileDescription) 
	{
		super(pDescription);
		mapMaxPopulation = new Map < String,Int>();

		ResourcesManager.populationChangementEvent.on(ResourcesManager.POPULATION_CHANGEMENT_EVENT_NAME, onPopulationChanged);
		
	}
	
	/**
	 * add a new population to this building
	 * @param	pMax the max soul building can has
	 */
	private function addPopulation(pMax:Int):Void{
		if (tileDesc.maxPopulation == null) {
			tileDesc.currentPopulation = 0;
			tileDesc.maxPopulation = pMax;
		}
		
		myPopulation = ResourcesManager.addPopulation(tileDesc.currentPopulation, tileDesc.maxPopulation, alignementBuilding, tileDesc.id);
	}
	
	override function addGenerator():Void 
	{
		maxResources = [50, 225, 1200];
		myMaxContains = maxResources[0]; 
		myTime = 60000 / valuesWin[0];

		super.addGenerator();
	}
	
	/**
	 * update population information
	 * @param	pQuantity the new quantity of population
	 * @param	pMax the new max of population
	 */
	public function updatePopulation(?pQuantity:Int, ?pMax:Int):Void{
		if (pQuantity != null){
			tileDesc.currentPopulation = pQuantity;
			myPopulation.quantity = pQuantity;
		}
		
		if (pMax != null){
			tileDesc.maxPopulation = pMax;
			myPopulation.max = pMax;
		}
		
		ResourcesManager.updatePopulation(myPopulation,alignementBuilding);
		
		SaveManager.save();
	}
	
	public function getPopulation():Population{
		return myPopulation;
	}
	
	/**
	 * catch the population when it change
	 * @param	pPopulation the population changed
	 */
	public function onPopulationChanged(pPopulation:Dynamic):Void{
		if (pPopulation.buildingRef != tileDesc.id) return;
		
		myPopulation = pPopulation;
		tileDesc.maxPopulation = pPopulation.max;
		tileDesc.currentPopulation = pPopulation.quantity;
		
		SaveManager.save();
	}
	
	override public function onClickUpgrade():Void 
	{
		super.onClickUpgrade();
		
		updatePopulation(null, mapMaxPopulation[tileDesc.assetName]);
		myTime = 60000 / valuesWin[indexLevel];
		myGenerator = ResourcesManager.UpdateResourcesGenerator(myGenerator, maxResources[indexLevel], myTime); //@TODO : mettre de vrais valeur...
		
		SaveManager.save();
	}
	
	
	override public function destroy():Void 
	{
		ResourcesManager.populationChangementEvent.off(ResourcesManager.POPULATION_CHANGEMENT_EVENT_NAME, onPopulationChanged);
		super.destroy();
	}
	
}