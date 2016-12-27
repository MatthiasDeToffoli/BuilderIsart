package com.isartdigital.perle.ui.hud;


import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.sprites.Quest;
import com.isartdigital.perle.game.virtual.VBuilding;
import com.isartdigital.perle.ui.hud.building.BHConstruction;
import com.isartdigital.perle.ui.hud.building.BHHarvest;
import com.isartdigital.perle.ui.hud.building.BHMoving;
import com.isartdigital.perle.ui.hud.building.BuildingHud;
import com.isartdigital.perle.ui.popin.listIntern.ListInternPopin;
import com.isartdigital.perle.ui.popin.shop.ShopPopin;
import com.isartdigital.perle.ui.popin.TribunalPopin;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartScreen;
import com.isartdigital.utils.ui.smart.TextSprite;
import pixi.core.display.Container;

enum BuildingHudType { CONSTRUCTION; HARVEST; MOVING; NONE; }

/**
 * @author Ambroise RABIER
 * @author Vicktor Grenu
*/
class Hud extends SmartScreen 
{	
	private static inline var PREFIX = "HUD_";
	
	private static var instance: Hud;
	
	private var currentBuildingHud:BuildingHudType;
	
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
		
		BHHarvest.getInstance().init();
		BHConstruction.getInstance().init();
		BHMoving.getInstance().init();
		
		addChild(containerBuildingHud);
		
		addListeners();
	}
	
	/**
	 * todo: move it to BuildingHud.hx ?
	 * Show corresponding BuildingHud when player click on a building.
	 * @param	pNewBuildingHud
	 * @param	pVBuilding
	 */
	public function changeBuildingHud (pNewBuildingHud:BuildingHudType, ?pVBuilding:VBuilding):Void {

		BuildingHud.linkVirtualBuilding(pVBuilding);
		// todo : mettre en évidence quel building on sélectionne actuellement...
		if (pVBuilding != null)
			trace("VBuildindg ID is : " + pVBuilding.tileDesc.id); 
		
		if (currentBuildingHud != pNewBuildingHud) {
			currentBuildingHud = pNewBuildingHud;
			containerBuildingHud.removeChildren();
			
			switch (pNewBuildingHud) 
			{
				case BuildingHudType.HARVEST: 
					containerBuildingHud.addChild(BHHarvest.getInstance());
				case BuildingHudType.CONSTRUCTION: 
					containerBuildingHud.addChild(BHConstruction.getInstance());
				case BuildingHudType.MOVING: 
					containerBuildingHud.addChild(BHMoving.getInstance());
				case BuildingHudType.NONE: 
					
				default: throw("No BuildingHud found !");
			}
		}
	}
	
	// todo : called from any clic outside a building
	public function hideBuildingHud ():Void {
		changeBuildingHud(BuildingHudType.NONE);
	}
	

	private function addListeners ():Void {
		
		cast(SmartCheck.getChildByName(this, PREFIX + "ShopButton"), SmartButton).on(MouseEventType.CLICK, onClickShop);
		cast(SmartCheck.getChildByName(this, PREFIX + "PurgatoryButton"), SmartButton).on(MouseEventType.CLICK, onClickTribunal);
		
		var interMc:Dynamic = SmartCheck.getChildByName(this, PREFIX + "InternsButton");
		cast(SmartCheck.getChildByName(interMc, "internsButton"), SmartButton).on(MouseEventType.CLICK, onClickListIntern);
	}
	
	public function onClickBuilding (pCurrentState:VBuildingState, pVBuilding:VBuilding):Void {
		var lBuidldingHudType:BuildingHudType = null;
		
		if (pCurrentState == VBuildingState.isBuilt)
			lBuidldingHudType = BuildingHudType.HARVEST;
		else if (pCurrentState == VBuildingState.isBuilding)
			lBuidldingHudType = BuildingHudType.CONSTRUCTION;
		
		changeBuildingHud(
			lBuidldingHudType,
			pVBuilding
		);
	}
	
	private function onClickShop ():Void {
		UIManager.getInstance().openPopin(ShopPopin.getInstance());
		hide();
	}
	
	private function onClickTribunal():Void {
		GameStage.getInstance().getPopinsContainer().addChild(TribunalPopin.getInstance());
		hide();
	}
	
	private function onClickListIntern(){
		//Todo: Temporaire! En attendant d'avoir plus de précision sur le wireframe
		var lRandomEvent:Int = Math.round(Math.random() * 3 + 1);
		var lQuest:Quest = new Quest(lRandomEvent);
		GameStage.getInstance().getPopinsContainer().addChild(ListInternPopin.getInstance());
		hide();
	}
	
	/**
	 * set the good value of a resource on the Hud
	 * @param	value the value to set
	 * @param	isLevel if we have to set on the level or not
	 * @param	type the type of resource we want to set
	 */
	public function setAllTextValues(value:Float, isLevel:Bool, ?type:GeneratorType, ?pMax:Float):Void{
		if(isLevel) setTextValues(PREFIX + "Level", "_level_txt", value);
		//else if (type == GeneratorType.soulGood) setTextValues(PREFIX + "Souls_Heaven", "bar_txt", value); existe plus sur hud apparamment -> nicolas
		//else if (type == GeneratorType.soulBad) setTextValues(PREFIX + "Souls_Hell", "bar_txt", value);
		else if (type == GeneratorType.badXp) setTextValues(PREFIX + "HellXP", "Hud_xp_txt", value, pMax);
		else if (type == GeneratorType.goodXp) setTextValues(PREFIX + "HeavenXP", "Hud_xp_txt", value, pMax);
		else if (type == GeneratorType.soft) setTextValues(PREFIX + "SoftCurrency", "bar_txt", value, pMax);
		else if (type == GeneratorType.hard) setTextValues(PREFIX + "HardCurrency", "bar_txt", value, pMax);
	}
	
	/**
	 * find the text on the Hud et change is value
	 * @param	pContainerName the name of the object which contain the text
	 * @param	pTextName the name of the text
	 * @param	pValue the value we want
	 */
	private function setTextValues(pContainerName:String, pTextName:String, pValue:Float, ?pMax:Float):Void{
		var textContainer:Dynamic = SmartCheck.getChildByName(this, pContainerName);
		
		var text:TextSprite = cast(SmartCheck.getChildByName(textContainer, pTextName), TextSprite);
		text.text = pMax != null ? pValue + " / " + pMax : pValue + "";
	}
	
	//hud génant quand ouvre autre screen est ce que on garde ou on fait autrement ?
	// Ambroise : C'est une bonne méthode à mon avis, par contre le nom de la fonction est encore mal trouvé :/
	// typiquement en jquery la function se nommerait hide(); et l'autre show();
	//Matthias : ça va X)
	
	/**
	 * hide the hud
	 */
	public function hide():Void{
		GameStage.getInstance().getHudContainer().removeChild(this);
	}
	
	/**
	 * show the hud
	 */
	public function show():Void{
		GameStage.getInstance().getHudContainer().addChild(this);
	}
	
	
	
	/*
		 * btnTest = cast(SmartCheck.getChildByName(this, "ButtonItem"), SmartButton);
		btnTest.on(MouseEventType.CLICK, onClick);*/
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
		super.destroy();
	}

}