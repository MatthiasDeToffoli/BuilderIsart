package com.isartdigital.perle.ui.hud;

import com.isartdigital.perle.game.managers.ResourcesManager.Generator;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.sprites.Building;
import com.isartdigital.perle.game.sprites.FlumpStateGraphic;
import com.isartdigital.perle.game.virtual.VBuilding;
import com.isartdigital.perle.ui.hud.building.BuildingHud;
import com.isartdigital.perle.ui.hud.building.BHMoving;
import com.isartdigital.perle.ui.hud.building.BHHarvest;
import com.isartdigital.perle.ui.hud.building.BHConstruction;
import com.isartdigital.perle.ui.popin.InternPopin;
import com.isartdigital.perle.ui.popin.ListInternPopin;
import com.isartdigital.perle.ui.popin.TribunalPopin;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartScreen;
import com.isartdigital.utils.ui.smart.TextSprite;
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
		
		//encore nécéssaire ?
		/*for (i in 0...children.length) 
			trace (children[i].name);*/
		
		cast(getChildByName("Shop"), SmartButton).on(MouseEventType.CLICK, onClickShop);
		cast(getChildByName("Tribunal"), SmartButton).on(MouseEventType.CLICK, onClickTribunal);
		
		var interMc:Dynamic = getChildByName("Quests"); 
		cast(interMc.getChildByName("Button"), SmartButton).on(MouseEventType.CLICK, onClickListIntern);
	}
	
	private function onClickShop ():Void {
		Building.onClickHudBuilding("House"); // todo temporaire
	}
	
	private function onClickTribunal():Void {
		GameStage.getInstance().getPopinsContainer().addChild(TribunalPopin.getInstance());
		removeToContainer();
	}
	
	private function onClickListIntern(){
		GameStage.getInstance().getPopinsContainer().addChild(ListInternPopin.getInstance());
		removeToContainer();
	}
	
	/**
	 * set the good value of a resource on the Hud
	 * @param	value the value to set
	 * @param	isLevel if we have to set on the level or not
	 * @param	type the type of resource we want to set
	 */
	public function setAllTextValues(value:Float, isLevel:Bool, ?type:GeneratorType):Void{
		if(isLevel) setTextValues("Level", "_level_txt", value);
		else if (type == GeneratorType.soulGood) setTextValues("Souls_Heaven", "bar_txt", value);
		else if (type == GeneratorType.soulBad) setTextValues("Souls_Hell", "bar_txt", value);
		else if (type == GeneratorType.badXp) setTextValues("Xp_bar_Hell", "Hud_xp_txt", value);
		else if (type == GeneratorType.goodXp) setTextValues("Xp_bar_Heaven", "Hud_xp_txt", value);
		else if (type == GeneratorType.soft) setTextValues("SoftCurrency", "bar_txt", value);
		else if (type == GeneratorType.hard) setTextValues("HardCurrency", "bar_txt", value);
	}
	
	/**
	 * find the text on the Hud et change is value
	 * @param	pContainerName the name of the object which contain the text
	 * @param	pTextName the name of the text
	 * @param	pValue the value we want
	 */
	private function setTextValues(pContainerName:String, pTextName:String, pValue:Float):Void{
		var textContainer:Dynamic = getChildByName(pContainerName);
		
		var text:TextSprite = cast(textContainer.getChildByName(pTextName, TextSprite));
		text.text = pValue + "";
	}
	
	//hud génant quand ouvre autre screen est ce que on garde ou on fait autrement ?
	public function removeToContainer():Void{
		GameStage.getInstance().getHudContainer().removeChild(this);
	}
	
	public function addToContainer():Void{
		GameStage.getInstance().getHudContainer().addChild(this);
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