package com.isartdigital.perle.ui.hud;


import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.DialogueManager;
import com.isartdigital.perle.game.managers.ExperienceManager;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.sprites.Building;
import com.isartdigital.perle.game.sprites.Tribunal;
import com.isartdigital.perle.game.virtual.VBuilding;
import com.isartdigital.perle.game.virtual.vBuilding.VHouse;
import com.isartdigital.perle.game.virtual.vBuilding.VTribunal;
import com.isartdigital.perle.ui.hud.building.BHBuilt;
import com.isartdigital.perle.ui.hud.building.BHConstruction;
import com.isartdigital.perle.ui.hud.building.BHHarvest;
import com.isartdigital.perle.ui.hud.building.BHHarvestHouse;
import com.isartdigital.perle.ui.hud.building.BHMoving;
import com.isartdigital.perle.ui.hud.building.BuildingHud;
import com.isartdigital.perle.ui.hud.building.SoulCounterHouse;
import com.isartdigital.perle.ui.popin.listIntern.ListInternPopin;
import com.isartdigital.perle.ui.popin.shop.ShopPopin;
import com.isartdigital.perle.ui.popin.TribunalPopin;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.events.EventType;
import com.isartdigital.utils.events.KeyboardEventType;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.SmartScreen;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.UIPosition;
import js.Browser;
import js.html.KeyboardEvent;
import pixi.core.display.Container;
import pixi.core.math.Point;
import pixi.core.math.shapes.Rectangle;
import pixi.interaction.EventTarget;

enum BuildingHudType { CONSTRUCTION; HARVEST; MOVING; NONE; }

/**
 * @author Ambroise RABIER
 * @author Vicktor Grenu
*/
class Hud extends SmartScreen 
{	
	
	private static var instance: Hud;
	public static var isHide:Bool = false;
	
	public var buildingPosition:Point;
	
	private var currentBuildingHudType:BuildingHudType;
	
	private var containerBuildingHud:Container;
	private var containerSoulCounter:Container;
	
	private var hellXPBar:SmartComponent;
	private var heavenXPBar:SmartComponent;
	
	private var btnResetData:SmartButton;
	private var btnShop:SmartButton;
	private var btnPurgatory:SmartButton;
	private var btnInterns:SmartButton;
	//private var btnMissions:SmartButton; // todo 
	private var btnIron:SmartButton;
	private var btnWood:SmartButton;
	private var btnSoft:SmartButton;
	private var btnHard:SmartButton;
	private var containerEffect:Container;
	private var movingBuilding:SmartComponent;
	
	
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
		containerSoulCounter = new Container();
		com.isartdigital.perle.game.sprites.Building.getBuildingHudContainer().addChild(containerBuildingHud);
		com.isartdigital.perle.game.sprites.Building.getBuildingHudContainer().addChild(containerSoulCounter);
		buildingPosition = new Point(containerBuildingHud.x / 2, containerBuildingHud.y / 2);
		name = componentName;
		
		containerEffect = new Container();
		addChild(containerEffect); // over everything
		addListeners();
		
		on(EventType.ADDED, registerForFTUE);
	}
	
	public function getContainerEffect ():Container {
		return containerEffect;
	}
	
	public function getGoldIconPos ():Point {
		return containerEffect.toLocal(SmartCheck.getChildByName(btnSoft.parent, "_icon_softcurrency").position, btnSoft.parent);
	}
	
	/**
	 * todo: move it to BuildingHud.hx ?
	 * Show corresponding BuildingHud when player click on a building.
	 * @param	pNewBuildingHud
	 * @param	pVBuilding
	 */
	public function changeBuildingHud(pNewBuildingHud:BuildingHudType, ?pVBuilding:VBuilding):Void {
		BuildingHud.linkVirtualBuilding(pVBuilding);

		// todo : mettre en évidence quel building on sélectionne actuellement...
		//containerBuildingHud = Building.getBuildingHud();

		if (pVBuilding != null)
			trace("VBuildindg ID is : " + pVBuilding.tileDesc.id); 

		if (currentBuildingHudType != pNewBuildingHud) {

			if(currentBuildingHudType != null) destroyBuildingHud(currentBuildingHudType);
			
			currentBuildingHudType = pNewBuildingHud;
			
			switch (pNewBuildingHud) 
			{
				case BuildingHudType.HARVEST: {
	
					if (Std.is(BuildingHud.virtualBuilding, VHouse))
						openHarvest(BHHarvestHouse.getInstance()); // todo
					else openHarvest(BHHarvest.getInstance());
				}
				case BuildingHudType.CONSTRUCTION:
					openConstruction(BHConstruction.getInstance());
					
				case BuildingHudType.MOVING: 
					GameStage.getInstance().getHudContainer().addChild(BHMoving.getInstance());
					UIPosition.setPositionInHud(
						BHMoving.getInstance(),
						UIPosition.BOTTOM,
						0,
						BHHarvest.getInstance().height/2
					);
					
					
				case BuildingHudType.NONE: 
				
				default: throw("No BuildingHud found !");
			}
		}
	}
	
	private function destroyBuildingHud(pType:BuildingHudType):Void {
		switch(pType) {
			case BuildingHudType.CONSTRUCTION:
				BHConstruction.getInstance().destroy();
				
			case BuildingHudType.HARVEST:
				BHHarvest.getInstance().destroy();
				BHHarvestHouse.getInstance().destroy();
				
			case BuildingHudType.MOVING:
				BHMoving.getInstance().destroy();
				
			case BuildingHudType.NONE:
				
				
		}
	}
	
	override public function onResize (pEvent:EventTarget = null):Void {
		super.onResize(pEvent);
		if (currentBuildingHudType == BuildingHudType.MOVING) {
			UIPosition.setPositionInHud(
				BHMoving.getInstance(),
				UIPosition.BOTTOM,
				0,
				BHHarvest.getInstance().height/2
			);
		}
	}
	
	//@Ambroise : impossible d'utiliser HudContextual directement car sinon les boutons ne marche plus vu que le clique sur le gameStage pour fermé le hud prend le dessus...
	private function addComponent(pComponent:BuildingHud):Void{
		
		placeAndAddComponent(pComponent, containerBuildingHud, UIPosition.BOTTOM_RIGHT);
	}
	
	
	public function addSoulCounter(pComponent:SoulCounterHouse):Void {
		placeAndAddComponent(pComponent, containerSoulCounter, UIPosition.BOTTOM);
	}
	
	private function placeAndAddComponent(pComponent:SmartComponent, pContainer:Container, pUIPos:String):Void {
		var lLocalBounds:Rectangle = BuildingHud.virtualBuilding.graphic.getLocalBounds();
		var lAnchor = new Point(lLocalBounds.x, lLocalBounds.y);
			
		var lRect:Point = BuildingHud.virtualBuilding.graphic.position;
		pContainer.position.x = lRect.x + lAnchor.x;
		pContainer.position.y = lRect.y + lAnchor.y;
		
		UIPosition.setPositionContextualUI(
			BuildingHud.virtualBuilding.graphic,
			pComponent,
			pUIPos,
			0,
			0
		);
		
		pContainer.addChild(pComponent);
	}
	
	
	private function openHarvest(pHarvest:BHBuilt):Void{
		addComponent(pHarvest);
		pHarvest.setOnSpawn();
	}
	
	
	
	private function openConstruction(pConstruct:BHConstruction):Void {
		addComponent(pConstruct);
		pConstruct.setOnSpawn();
	}
	
	// todo : called from any clic outside a building
	public function hideBuildingHud ():Void {
		changeBuildingHud(BuildingHudType.NONE);
	}
	

	private function addListeners ():Void {
		
		ResourcesManager.totalResourcesEvent.on(ResourcesManager.TOTAL_RESOURCES_EVENT_NAME, refreshTextValue);
		btnResetData = cast(SmartCheck.getChildByName(this, AssetName.HUD_BTN_RESET_DATA), SmartButton);
		btnShop = cast(SmartCheck.getChildByName(this, AssetName.HUD_BTN_SHOP), SmartButton);
		btnPurgatory = cast(SmartCheck.getChildByName(this, AssetName.HUD_BTN_PURGATORY), SmartButton);
		btnInterns = cast(SmartCheck.getChildByName(this, AssetName.HUD_BTN_INTERNS), SmartButton);
		//btnMissions = cast(SmartCheck.getChildByName(this, AssetName.HUD_BTN_MISSIONS), SmartButton); // todo 
		
		
		
		hellXPBar = cast(SmartCheck.getChildByName(this, AssetName.XP_GAUGE_HELL), SmartComponent);
		heavenXPBar = cast(SmartCheck.getChildByName(this, AssetName.XP_GAUGE_HEAVEN), SmartComponent);
		addListenersOnClick();
	}
	
	private function addListenersOnClick() {
		//FTUE : désolé j'ai du faire ça sinon impossible de recolter les golds
		if (DialogueManager.ftueStepRecolt || DialogueManager.ftueStepConstructBuilding ||  DialogueManager.ftueStepOpenPurgatory)
			return;
			
		Interactive.addListenerClick(btnResetData, onClickResetData);
		Interactive.addListenerClick(btnShop, onClickShop);
		Interactive.addListenerClick(btnPurgatory, onClickTribunal);
		Interactive.addListenerClick(btnInterns, onClickListIntern);
		//Interactive.addListenerClick(btnMissions, onClickMission); // todo 
		
		var woodMc:Dynamic = SmartCheck.getChildByName(this, AssetName.HUD_COUNTER_MATERIAL_HELL);
		var ironMc:Dynamic = SmartCheck.getChildByName(this, AssetName.HUD_COUNTER_MATERIAL_HEAVEN);
		var softMc:Dynamic = SmartCheck.getChildByName(this, AssetName.HUD_COUNTER_SOFT);
		var hardMc:Dynamic = SmartCheck.getChildByName(this, AssetName.HUD_COUNTER_HARD);
		
		btnIron = cast(SmartCheck.getChildByName(woodMc, AssetName.HUD_BTN_IRON), SmartButton);
		btnWood = cast(SmartCheck.getChildByName(ironMc, AssetName.HUD_BTN_WOOD), SmartButton);
		btnSoft = cast(SmartCheck.getChildByName(softMc, AssetName.HUD_BTN_SOFT), SmartButton);
		btnHard = cast(SmartCheck.getChildByName(hardMc, AssetName.HUD_BTN_HARD), SmartButton);
		
		Interactive.addListenerClick(btnIron, onClickShopResource);
		Interactive.addListenerClick(btnWood, onClickShopResource);		
		Interactive.addListenerClick(btnSoft, onClickShopCurrencies);
		Interactive.addListenerClick(btnHard, onClickShopCurrencies);
		
		//Main.getInstance().stage.addListener(MouseEventType.RIGHT_CLICK, onKeyDown);
		Browser.window.addEventListener(KeyboardEventType.KEY_DOWN, onKeyDown);
	}
	
	private function onKeyDown(pEvent:KeyboardEvent){
		if (pEvent.key != "g" && pEvent.key != "j") return;
		if (pEvent.key == "g") ResourcesManager.levelUp();
		//DialogueManager.registerIsADialogue = false;
	}
	
	private function registerForFTUE (pEvent:EventTarget):Void {
		for (i in 0...children.length) {
			if (Std.is(children[i],SmartButton)) DialogueManager.register(children[i],true);
		}
		off(EventType.ADDED, registerForFTUE);
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
		
		if (checkIfTribunal(pVBuilding)) {
			if (DialogueManager.ftueStepOpenPurgatory)
				DialogueManager.endOfaDialogue(true);
				
			UIManager.getInstance().openPopin(TribunalPopin.getInstance());
			hide();
			return;
		}
		
		if (pCurrentState != VBuildingState.isBuilding)
			if (DialogueManager.ftueStepRecolt || DialogueManager.ftueStepConstructBuilding || DialogueManager.ftueStepOpenPurgatory)
			return;
			
	/*	if (DialogueManager.ftueStepOpenPurgatory)
		if(pVBuilding.alignementBuilding.getName() !=neutral*/
		
		if (pCurrentState == VBuildingState.isBuilt)
			lBuidldingHudType = BuildingHudType.HARVEST;
		else if (pCurrentState == VBuildingState.isBuilding)
			lBuidldingHudType = BuildingHudType.CONSTRUCTION;
		else if (pCurrentState == VBuildingState.isMoving)
			lBuidldingHudType = BuildingHudType.MOVING;
			
		changeBuildingHud(
			lBuidldingHudType,
			pVBuilding
		);
	}
	
	private function checkIfTribunal(pVbuilding:VBuilding):Bool {
		return (Std.is(pVbuilding.graphic, Tribunal));
	}
	
	private function onClickShop ():Void {
		if (DialogueManager.ftueStepClickShop) {
			
			//DialogueManager.removeDialogue();
			DialogueManager.endOfaDialogue(true);
		}
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
	
	public function onClickTribunal():Void {
		if(currentBuildingHudType != null) destroyBuildingHud(currentBuildingHudType);
		UIManager.getInstance().openPopin(TribunalPopin.getInstance());
		hide();
	}
	
	private function onClickListIntern(){
		UIManager.getInstance().openPopin(ListInternPopin.getInstance());
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
	
	/**
	 * hide the hud
	 */
	public function hide():Void { // todo : should still show phantom menu (accept or cancel build)
		if (!isHide) {
			GameStage.getInstance().getHudContainer().removeChild(this);
			isHide = true;
		}
	}
	
	/**
	 * show the hud
	 */
	public function show():Void { // todo : should still show phantom menu (accept or cancel build)
		if (isHide) {	
			GameStage.getInstance().getHudContainer().addChild(this);
			isHide = false;
		}
	}
	
	private function removeListenersClick() {
		Interactive.removeListenerClick(btnResetData, onClickResetData);
		Interactive.removeListenerClick(btnShop, onClickShop);
		Interactive.removeListenerClick(btnPurgatory, onClickTribunal);
		Interactive.removeListenerClick(btnInterns, onClickListIntern);
		//Interactive.removeListenerClick(btnMissions, onClickMission); // todo 
		
		Interactive.removeListenerClick(btnIron, onClickShopResource);
		Interactive.removeListenerClick(btnWood, onClickShopResource);
		Interactive.removeListenerClick(btnSoft, onClickShopCurrencies);
		Interactive.removeListenerClick(btnHard, onClickShopCurrencies);
	}
	
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		removeListenersClick();
		ResourcesManager.totalResourcesEvent.off(ResourcesManager.TOTAL_RESOURCES_EVENT_NAME, refreshTextValue);
		instance = null;
		super.destroy();
	}

}