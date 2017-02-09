package com.isartdigital.perle.game.virtual.vBuilding;

import com.isartdigital.perle.game.GameConfig.TableTypeBuilding;
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
	
	override function addGenerator():Void 
	{
		addPopulation();
		super.addGenerator();
	}
	/**
	 * add a new population to this building
	 * @param	pMax the max soul building can has
	 */
	private function addPopulation():Void{
		if (tileDesc.maxPopulation == null) {
			tileDesc.currentPopulation = 0;
			tileDesc.maxPopulation = GameConfig.getBuildingByName(tileDesc.buildingName, tileDesc.level + 1).maxSoulsContained;
		}
		
		myPopulation = ResourcesManager.addPopulation(tileDesc.currentPopulation, tileDesc.maxPopulation, alignementBuilding, tileDesc.id);
	}
	
	override function calculTimeProd(?pTypeBuilding:TableTypeBuilding):Float 
	{
		if (myPopulation.quantity == 0) return null;
		return super.calculTimeProd(pTypeBuilding)/myPopulation.quantity;
	}
	
	/**
	 * update population information
	 * @param	pQuantity the new quantity of population
	 * @param	pMax the new max of population
	 */
	public function updatePopulation(?pQuantity:Int):Void{

		if (pQuantity != null){
			tileDesc.currentPopulation = pQuantity;
			myPopulation.quantity = pQuantity;
		}
		
			var lMax:Int = GameConfig.getBuildingByName(tileDesc.buildingName, tileDesc.level + 1).maxSoulsContained;
			tileDesc.maxPopulation = lMax;
			myPopulation.max = lMax;
		
		ResourcesManager.updatePopulation(myPopulation, alignementBuilding);
		updateResources();
		
		
		SaveManager.save();
	}
	
	public function getPopulation():Population{
		return myPopulation;
	}
	
	override public function updateGeneratorInfo(?data:Dynamic) 
	{
		super.updateGeneratorInfo(data);
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
		updateResources();
		SaveManager.save();
	}
	
	override public function onClickUpgrade():Void 
	{
		super.onClickUpgrade();
		
		updatePopulation();
		
		SaveManager.save();
	}
	
	
	override public function destroy():Void 
	{
		ResourcesManager.populationChangementEvent.off(ResourcesManager.POPULATION_CHANGEMENT_EVENT_NAME, onPopulationChanged);
		super.destroy();
	}
	
}