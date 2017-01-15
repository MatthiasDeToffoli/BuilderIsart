package com.isartdigital.perle.ui.hud;


import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.ExperienceManager;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.UnlockManager;
import com.isartdigital.perle.game.sprites.Building;
import com.isartdigital.perle.game.virtual.VBuilding;
import com.isartdigital.perle.game.virtual.vBuilding.VHouse;
import com.isartdigital.perle.ui.hud.building.BHBuilt;
import com.isartdigital.perle.ui.hud.building.BHConstruction;
import com.isartdigital.perle.ui.hud.building.BHHarvest;
import com.isartdigital.perle.ui.hud.building.BHHarvestHouse;
import com.isartdigital.perle.ui.hud.building.BHMoving;
import com.isartdigital.perle.ui.hud.building.BuildingHud;
import com.isartdigital.perle.ui.popin.listIntern.ListInternPopin;
import com.isartdigital.perle.ui.popin.shop.ShopPopin;
import com.isartdigital.perle.ui.popin.TribunalPopin;
import com.isartdigital.perle.ui.popin.choice.Choice;
import com.isartdigital.utils.events.KeyboardEventType;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.SmartScreen;
import com.isartdigital.utils.ui.smart.TextSprite;
import eventemitter3.EventEmitter;
import js.Browser;
import js.html.KeyboardEvent;
import pixi.core.display.Container;
import pixi.core.math.Point;

enum BuildingHudType { CONSTRUCTION; HARVEST; MOVING; NONE; }

/**
 * @author Ambroise RABIER
 * @author Vicktor Grenu
*/
class Hud extends SmartScreen 
{	
	
	private static var instance: Hud;
	public static var isHide:Bool = false;
	
	private var currentBuildingHud:BuildingHudType;
	
	private var containerBuildingHud:Container;
	
	private var hellXPBar:SmartComponent;
	private var heavenXPBar:SmartComponent;
	
	public var buildingPosition:Point;
	

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
		super("HUD_Desktop");
		modal = null;
		containerBuildingHud = new Container();
		BHHarvestHouse.getInstance().init();
		BHHarvest.getInstance().init();
		BHConstruction.getInstance().init();
		BHMoving.getInstance().init();
		
		com.isartdigital.perle.game.sprites.Building.getBuildingHudContainer().addChild(containerBuildingHud);
		buildingPosition = new Point(containerBuildingHud.x / 2, containerBuildingHud.y / 2);
		
		addListeners();
	}
	
	/**
	 * todo: move it to BuildingHud.hx ?
	 * Show corresponding BuildingHud when player click on a building.
	 * @param	pNewBuildingHud
	 * @param	pVBuilding
	 */
	public function changeBuildingHud (pNewBuildingHud:BuildingHudType, ?pVBuilding:VBuilding, ?pPos:Point):Void {

		BuildingHud.linkVirtualBuilding(pVBuilding);
		// todo : mettre en évidence quel building on sélectionne actuellement...
		//containerBuildingHud = Building.getBuildingHud();

		if (pVBuilding != null)
			trace("VBuildindg ID is : " + pVBuilding.tileDesc.id); 
		
		if (currentBuildingHud != pNewBuildingHud) {
			currentBuildingHud = pNewBuildingHud;
			containerBuildingHud.removeChildren();
			
			switch (pNewBuildingHud) 
			{
				case BuildingHudType.HARVEST: {
					if (Std.is(BuildingHud.virtualBuilding, VHouse))
						openHarvest(BHHarvestHouse.getInstance(),pPos);
					else openHarvest(BHHarvest.getInstance(),pPos);
				}
				case BuildingHudType.CONSTRUCTION: 
					containerBuildingHud.addChild(BHConstruction.getInstance());
				case BuildingHudType.MOVING: {
					//trace(buildingPosition);
					//BHMoving.getInstance().position = buildingPosition;
					BHHarvest.getInstance().removeListenerGameContainer();
					BHHarvestHouse.getInstance().removeListenerGameContainer();
					containerBuildingHud.addChild(BHMoving.getInstance());
				}
				case BuildingHudType.NONE: 
					
				default: throw("No BuildingHud found !");
			}
		}
	}
	
	private function openHarvest(pHarvest:BHBuilt, pPos:Point):Void{
		containerBuildingHud.addChild(pHarvest);
		pHarvest.position = pPos;
		pHarvest.setOnSpawn();
	}
	
	/**
	 * Temporarily function use to test choice popin
	 * @param	pEvent
	 */
	public function showInternEvent (pEvent:KeyboardEvent):Void {
		if (pEvent.key != "i") return;
		hide();
		GameStage.getInstance().getPopinsContainer().addChild(Choice.getInstance());
	}
	
	// todo : called from any clic outside a building
	public function hideBuildingHud ():Void {
		changeBuildingHud(BuildingHudType.NONE);
	}
	

	private function addListeners ():Void {
		ResourcesManager.totalResourcesEvent.on(ResourcesManager.TOTAL_RESOURCES_EVENT_NAME, refreshTextValue);
		
		cast(SmartCheck.getChildByName(this, AssetName.HUD_BTN_RESET_DATA), SmartButton).on(MouseEventType.CLICK, onClickResetData);
		
		cast(SmartCheck.getChildByName(this, AssetName.HUD_BTN_SHOP), SmartButton).on(MouseEventType.CLICK, onClickShop);
		cast(SmartCheck.getChildByName(this, AssetName.HUD_BTN_PURGATORY), SmartButton).on(MouseEventType.CLICK, onClickTribunal);
		//var interMc:Dynamic = SmartCheck.getChildByName(this, AssetName.HUD_CONTAINER_BTN_INTERNS);
		cast(SmartCheck.getChildByName(this, AssetName.HUD_BTN_INTERNS), SmartButton).on(MouseEventType.CLICK, onClickListIntern);
		cast(SmartCheck.getChildByName(this, AssetName.HUD_BTN_MISSIONS), SmartButton).on(MouseEventType.CLICK, onClickMission);
		hellXPBar = cast(SmartCheck.getChildByName(this, AssetName.XP_GAUGE_HELL), SmartComponent);
		heavenXPBar = cast(SmartCheck.getChildByName(this, AssetName.XP_GAUGE_HEAVEN), SmartComponent);
		
		Browser.window.addEventListener(KeyboardEventType.KEY_DOWN, showInternEvent);
		
		//var interMc:Dynamic = SmartCheck.getChildByName(this, AssetName.HUD_CONTAINER_BTN_INTERNS);
		//cast(SmartCheck.getChildByName(interMc, AssetName.HUD_BTN_INTERNS), SmartButton).on(MouseEventType.CLICK, onClickListIntern);
		
		var woodMc:Dynamic = SmartCheck.getChildByName(this, AssetName.HUD_COUNTER_MATERIAL_HELL);
		cast(SmartCheck.getChildByName(woodMc, AssetName.HUD_BTN_IRON), SmartButton).on(MouseEventType.CLICK, onClickShopResource);
		
		var ironMc:Dynamic = SmartCheck.getChildByName(this,AssetName.HUD_COUNTER_MATERIAL_HEAVEN);
		cast(SmartCheck.getChildByName(ironMc, AssetName.HUD_BTN_WOOD), SmartButton).on(MouseEventType.CLICK, onClickShopResource);
		
		var softMc:Dynamic = SmartCheck.getChildByName(this, AssetName.HUD_COUNTER_SOFT);
		cast(SmartCheck.getChildByName(softMc, AssetName.HUD_BTN_SOFT), SmartButton).on(MouseEventType.CLICK, onClickShopCurrencies);
		
		var hardMc:Dynamic = SmartCheck.getChildByName(this, AssetName.HUD_COUNTER_HARD);
		cast(SmartCheck.getChildByName(hardMc, AssetName.HUD_BTN_HARD), SmartButton).on(MouseEventType.CLICK, onClickShopCurrencies);
		
	}
	
	public function initGauges():Void{
		hellXPBar.getChildByName("movingGauge").scale.x = 0;
		heavenXPBar.getChildByName("movingGauge").scale.x = 0;
	}
	
	public function initGaugesWithSave():Void{
		hellXPBar.getChildByName("movingGauge").scale.x = ResourcesManager.getResourcesData().totalsMap[GeneratorType.badXp]/ExperienceManager.getMaxExp(cast(ResourcesManager.getLevel(), Int));
		heavenXPBar.getChildByName("movingGauge").scale.x = ResourcesManager.getResourcesData().totalsMap[GeneratorType.goodXp]/ExperienceManager.getMaxExp(cast(ResourcesManager.getLevel(), Int));
	}
	
	public function setXpGauge(pType:GeneratorType, pQuantity:Float):Void{
		var lNumberToPercent:Float = pQuantity / ExperienceManager.getMaxExp(cast(ResourcesManager.getLevel(), Int));
		var lScaleHellXp:Float = hellXPBar.getChildByName("movingGauge").scale.x;
		var lScaleHeavenXp:Float = heavenXPBar.getChildByName("movingGauge").scale.x;
		
		if (lScaleHellXp != 1 && lScaleHeavenXp != 1){
			if (pType.getName() == "badXp") {
				lScaleHellXp += lNumberToPercent;
				if (lScaleHellXp > 1) lScaleHellXp = 1;
				hellXPBar.getChildByName("movingGauge").scale.x = lScaleHellXp;
			}
		
			if (pType.getName() == "goodXp") {
				lScaleHeavenXp += lNumberToPercent;
				if (lScaleHeavenXp > 1) lScaleHeavenXp = 1;
				heavenXPBar.getChildByName("movingGauge").scale.x = lScaleHeavenXp;
			}
		}
	}
	
	public function onClickResetData(){
		SaveManager.reinit();
	}
	
	public function onClickBuilding (pCurrentState:VBuildingState, pVBuilding:VBuilding, pPos:Point):Void {
		var lBuidldingHudType:BuildingHudType = null;
		
		if (pCurrentState == VBuildingState.isBuilt)
			lBuidldingHudType = BuildingHudType.HARVEST;
		else if (pCurrentState == VBuildingState.isBuilding)
			lBuidldingHudType = BuildingHudType.CONSTRUCTION;
		
		changeBuildingHud(
			lBuidldingHudType,
			pVBuilding,
			pPos
		);
	}
	
	private function onClickShop ():Void {
		UIManager.getInstance().openPopin(ShopPopin.getInstance());
		ShopPopin.getInstance().init(ShopTab.Building);
		hide();
	}
	
	private function onClickShopCurrencies ():Void {
		UIManager.getInstance().openPopin(ShopPopin.getInstance());
		ShopPopin.getInstance().init(ShopTab.Currencies);
		hide();
	}
	
	private function onClickShopResource ():Void {
		UIManager.getInstance().openPopin(ShopPopin.getInstance());
		ShopPopin.getInstance().init(ShopTab.Resources);
		hide();
	}
	
	private function onClickTribunal():Void {
		UIManager.getInstance().openPopin(TribunalPopin.getInstance());
		hide();
	}
	
	private function onClickListIntern(){
		UIManager.getInstance().openPopin(ListInternPopin.getInstance());
		
		Browser.alert("Work in progress : Special Feature");	
		GameStage.getInstance().getPopinsContainer().addChild(ListInternPopin.getInstance());
		hide();
	}
	
	private function onClickMission() {
		Browser.alert("Work in progress : Special Feature");	
	}
	
	/**
	 * refresh all text value
	 * @param	pArray a array contain all value at set in text
	 */
	private function refreshTextValue(pArray:Array<TotalResourcesEventParam>):Void{
		var param:TotalResourcesEventParam;
		for (param in pArray) setAllTextValues(param.value, param.isLevel, param.type, param.max);
	}
	
	/**
	 * set the good value of a resource on the Hud
	 * @param	value the value to set
	 * @param	isLevel if we have to set on the level or not
	 * @param	type the type of resource we want to set
	 */
	public function setAllTextValues(value:Float, isLevel:Bool, ?type:GeneratorType, ?pMax:Float):Void {
		if(isLevel) setTextValues(AssetName.HUD_COUNTER_LEVEL, AssetName.COUNTER_TXT_LEVEL, value);
		else if (type == GeneratorType.buildResourceFromParadise) setTextValues(AssetName.HUD_COUNTER_MATERIAL_HEAVEN, AssetName.COUNTER_TXT_RESSOURCE, value);
		else if (type == GeneratorType.buildResourceFromHell) setTextValues(AssetName.HUD_COUNTER_MATERIAL_HELL, AssetName.COUNTER_TXT_RESSOURCE, value);
		//else if (type == GeneratorType.badXp) setTextValues(AssetName.HUD_COUNTER_XP_HELL, AssetName.COUNTER_TXT_XP, value, pMax);
		//else if (type == GeneratorType.goodXp) setTextValues(AssetName.HUD_COUNTER_XP_HEAVEN, AssetName.COUNTER_TXT_XP, value, pMax);
		else if (type == GeneratorType.soft) setTextValues(AssetName.HUD_COUNTER_SOFT, AssetName.COUNTER_TXT_RESSOURCE, value, pMax);
		else if (type == GeneratorType.hard) setTextValues(AssetName.HUD_COUNTER_HARD, AssetName.COUNTER_TXT_RESSOURCE, value, pMax);
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
		isHide = true;
	}
	
	/**
	 * show the hud
	 */
	public function show():Void{
		GameStage.getInstance().getHudContainer().addChild(this);
		isHide = false;
	}
	
	
	
	/*
		 * btnTest = cast(SmartCheck.getChildByName(this, "ButtonItem"), SmartButton);
		btnTest.on(MouseEventType.CLICK, onClick);*/
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		ResourcesManager.totalResourcesEvent.off(ResourcesManager.TOTAL_RESOURCES_EVENT_NAME, refreshTextValue);
		instance = null;
		super.destroy();
	}

}