package com.isartdigital.perle.ui.hud;

import com.isartdigital.perle.game.sprites.Building;
import com.isartdigital.perle.game.virtual.VBuilding;
import com.isartdigital.perle.ui.hud.building.BuildingHud;
import com.isartdigital.perle.ui.hud.building.BHMoving;
import com.isartdigital.perle.ui.hud.building.BHHarvest;
import com.isartdigital.perle.ui.hud.building.BHConstruction;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartScreen;
import pixi.core.display.Container;

enum BuildingHudType { CONSTRUCTION; HARVEST; MOVING; }

/**
 * Classe en charge de gérer les informations du Hud
 * @author Ambroise RABIER et Vicktor Grenu
 */
class Hud extends SmartScreen 
{
	
	private static var instance: Hud;

	private var currentBuildingHud:BuildingHudType;
	
	private var buildingRecolte:BHHarvest;
	private var buildingTimeBased:BHConstruction;
	private var buildingMovingBuilding:BHMoving;
	
	private var containerBuildingHud:Container;

	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): Hud {
		if (instance == null) instance = new Hud();
		return instance;
	}	
	
	public function new() 
	{
		super("HUD");
		modal = null;
		
		containerBuildingHud = new Container();
		buildingRecolte = new BHHarvest();
		buildingTimeBased = new BHConstruction();
		buildingMovingBuilding = new BHMoving();
		
		buildingRecolte.init();
		addChild(containerBuildingHud);
		
		addListeners();
	}
	
	// todo : called from building on click
	public function showBuildingHud (pNewBuildingHud:BuildingHudType, pVBuilding:VBuilding):Void {
		
		BuildingHud.linkVirtualBuilding(pVBuilding);
		
		if (currentBuildingHud != pNewBuildingHud) {
			currentBuildingHud = pNewBuildingHud;
			hideBuildingHud();
			
			switch (pNewBuildingHud) 
			{
				case BuildingHudType.HARVEST: 
					containerBuildingHud.addChild(buildingRecolte);
				case BuildingHudType.CONSTRUCTION: 
					containerBuildingHud.addChild(buildingTimeBased);
				case BuildingHudType.MOVING: 
					containerBuildingHud.addChild(buildingMovingBuilding);
				default: throw("No BuildingHud found !");
			}
		}
	}
	
	// todo : called from any clic outside a building
	public function hideBuildingHud ():Void {
		containerBuildingHud.removeChildren();
	}
	
	private function addListeners ():Void {
		for (i in 0...children.length) 
			trace (children[i].name);
		
		cast(getChildByName("Shop"), SmartButton).on(MouseEventType.CLICK, onClickShop);
	}
	
	private function onClickShop ():Void {
		Building.onClickHudBuilding("House"); // todo temporaire
	}
	
	
	/*
		 * btnTest = cast(getChildByName("ButtonItem"), SmartButton);
		btnTest.on(MouseEventType.CLICK, onClick);*/
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
		super.destroy();
	}

}