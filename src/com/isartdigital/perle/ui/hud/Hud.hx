package com.isartdigital.perle.ui.hud;


import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.DialogueManager;
import com.isartdigital.perle.game.managers.ExperienceManager;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.sprites.Building;
import com.isartdigital.perle.game.sprites.building.heaven.InternHouseHeaven;
import com.isartdigital.perle.game.sprites.building.hell.InternHouseHell;
import com.isartdigital.perle.game.sprites.Tribunal;
import com.isartdigital.perle.game.virtual.VBuilding;
import com.isartdigital.perle.game.virtual.vBuilding.VBuildingUpgrade;
import com.isartdigital.perle.game.virtual.vBuilding.VCollector;
import com.isartdigital.perle.game.virtual.vBuilding.vHeaven.VMarketingHouse;
import com.isartdigital.perle.game.virtual.vBuilding.VHouse;
import com.isartdigital.perle.game.virtual.vBuilding.VTribunal;
import com.isartdigital.perle.ui.hud.building.BHBuiltCollectorNotUpgrade;
import com.isartdigital.perle.ui.hud.building.BHBuiltCollectorUpgradable;
import com.isartdigital.perle.ui.hud.building.BHBuiltInUpgrading;
import com.isartdigital.perle.ui.hud.building.BHBuiltMarketing;
import com.isartdigital.perle.ui.hud.building.BHConstruction;
import com.isartdigital.perle.ui.hud.building.BHHarvestHouse;
import com.isartdigital.perle.ui.hud.building.BHHarvestNoUpgrade;
import com.isartdigital.perle.ui.hud.building.BHMoving;
import com.isartdigital.perle.ui.hud.building.BuildingHud;
import com.isartdigital.perle.ui.popin.listIntern.ListInternPopin;
import com.isartdigital.perle.ui.popin.option.OptionPoppin;
import com.isartdigital.perle.ui.popin.shop.ShopPopin;
import com.isartdigital.perle.ui.popin.TribunalPopin;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.events.EventType;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.SmartScreen;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UIMovie;
import com.isartdigital.utils.ui.UIPosition;
import eventemitter3.EventEmitter;
import haxe.Timer;
import pixi.core.display.Container;
import pixi.core.math.Point;
import pixi.core.math.shapes.Rectangle;
import pixi.interaction.EventTarget;

enum BuildingHudType { CONSTRUCTION; UPGRADING; HARVEST; MOVING; NONE; }

/**
 * @author Ambroise RABIER
 * @author Vicktor Grenu
*/
class Hud extends SmartScreen 
{	
	public static inline var EVENT_CHANGE_BUIDINGHUD:String = "Hud_Change_BuildingHud";
	public static inline var LEVEL_UNLOCK_INTERNS:Int = 3;
	
	public static var eChangeBH:EventEmitter;
	
	private static var instance: Hud;
	public static var isHide:Bool = false;
	
	public var buildingPosition:Point;
	
	private var currentBuildingHudType:BuildingHudType;
	private var currentBuildingHud:BuildingHud;
	
	private var containerBuildingHud:Container;
	private var containerBuildingHudSecondary:Container;
	
	public var hellXPBar:SmartComponent;
	public var heavenXPBar:SmartComponent;
	public var lBarHeaven:UIMovie;
	public var lBarHell:UIMovie;
	
	public var buttonMissionDeco:SmartButton;
	
	//private var btnResetData:SmartButton;
	public var btnShop:SmartButton;
	private var btnPurgatory:SmartButton;
	private var btnInterns:SmartButton;
	private var btnOptions:SmartButton; // todo 
	private var btnIron:SmartButton;
	private var btnWood:SmartButton;
	public var btnSoft:SmartButton;
	public var softMc:Dynamic;
	public var btnHard:SmartButton;
	public var hardMc:Dynamic;
	private var containerEffect:Container;
	private var movingBuilding:SmartComponent;	
	private var basePosXMasqueXpHell:Float;
	private var basePosXMasqueXpHeaven:Float;
	private var baseGaugeWidth:Float;
	private var btnInternBloc:SmartComponent;
	
	
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
		initBHMoving(this);
		containerBuildingHud = new Container();
		containerBuildingHudSecondary = new Container();
		com.isartdigital.perle.game.sprites.Building.getBuildingHudContainer().addChild(containerBuildingHud);
		com.isartdigital.perle.game.sprites.Building.getBuildingHudContainer().addChild(containerBuildingHudSecondary);
		buildingPosition = new Point(containerBuildingHud.x / 2, containerBuildingHud.y / 2);
		name = componentName;
		eChangeBH = new EventEmitter();
		
		containerEffect = new Container();
		addChild(containerEffect); // over everything
		addListeners();
		
		on(EventType.ADDED, registerForFTUE);
	}
	
	private static function initBHMoving (pHud:Hud):Void {
		SmartCheck.traceChildrens(pHud);
		BHMoving.initHack(
			cast(SmartCheck.getChildByName(pHud, AssetName.HUD_MOVNG_BUILDING_DESKTOP), BHMoving),
			cast(SmartCheck.getChildByName(pHud, AssetName.HUD_MOVNG_BUILDING), BHMoving)
		);
	}
	
	public function getContainerEffect ():Container {
		return containerEffect;
	}
	
	/*public function initClass():Void {
		eChangeBH = new EventEmitter();
	}*/
	
	public function getGoldIconPos ():Point {
		return containerEffect.toLocal(SmartCheck.getChildByName(btnSoft.parent, "_icon_softcurrency").position, btnSoft.parent);
	}
	
	public function getWoodIconPos ():Point {
		return containerEffect.toLocal(SmartCheck.getChildByName(btnWood.parent, "_icon_wood").position, btnWood.parent);
	}
	
	public function getIronIconPos ():Point {
		return containerEffect.toLocal(SmartCheck.getChildByName(btnIron.parent, "_icon_stone").position, btnIron.parent);
	}
	
	public function getShopIconPos ():Point {
		return containerEffect.toLocal(SmartCheck.getChildByName(this, "ButtonShop_HUD").position, btnShop.parent);
	}
	
	private function needToChangeBH(pInfos:Map<String, Dynamic>):Void {
		changeBuildingHud(pInfos["type"], pInfos["building"]);
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
			
			if (currentBuildingHudType == BuildingHudType.MOVING)
				BHMoving.getInstance().visible = false;
			else
				closeCurrentBuildingHud();
			
			currentBuildingHudType = pNewBuildingHud;
			
			switch (pNewBuildingHud) 
			{
				case BuildingHudType.HARVEST: {
					
					if (Std.is(BuildingHud.virtualBuilding, VHouse) && cast(BuildingHud.virtualBuilding,VBuildingUpgrade).canUpgrade())
						openContextual(BHHarvestHouse.getInstance()); // todo
					else if (Std.is(BuildingHud.virtualBuilding, VCollector))
						if(cast(BuildingHud.virtualBuilding, VBuildingUpgrade).canUpgrade())
							openContextual(BHBuiltCollectorUpgradable.getInstance());
						else openContextual(BHBuiltCollectorNotUpgrade.getInstance());
					else if (Std.is(BuildingHud.virtualBuilding, VMarketingHouse))
						openContextual(BHBuiltMarketing.getInstance());
					else openContextual(BHHarvestNoUpgrade.getInstance());
				}
				case BuildingHudType.CONSTRUCTION:
					openContextual(BHConstruction.getInstance());
					
				case BuildingHudType.UPGRADING:
					openContextual(BHBuiltInUpgrading.getInstance());
					
				case BuildingHudType.MOVING:
					BHMoving.getInstance().visible = true;
					GameStage.getInstance().getHudContainer().addChild(BHMoving.getInstance());
					currentBuildingHud = BHMoving.getInstance();
					/*UIPosition.setPositionInHud(
						BHMoving.getInstance(),
						UIPosition.BOTTOM,
						0,
						BHHarvestNoUpgrade.getInstance().height/2
					);*/
					
					
				case BuildingHudType.NONE: 
				
				default: throw("No BuildingHud found !");
			}
		}
	}
	

	override public function onResize (pEvent:EventTarget = null):Void {
		super.onResize(pEvent);
		if (currentBuildingHudType == BuildingHudType.MOVING) {
			UIPosition.setPositionInHud(
				BHMoving.getInstance(),
				UIPosition.BOTTOM,
				0,
				BHHarvestNoUpgrade.getInstance().height/2
			);
		}
	}
	
	public function closeCurrentBuildingHud():Void {
		if (currentBuildingHud != null) 
			currentBuildingHud.destroy();
		currentBuildingHud = null;
	}
	//@Ambroise : impossible d'utiliser HudContextual directement car sinon les boutons ne marche plus vu que le clique sur le gameStage pour fermé le hud prend le dessus...
	// pas compris.
	private function addComponent(pComponent:BuildingHud):Void{
		
		placeAndAddComponent(pComponent, containerBuildingHud, UIPosition.BOTTOM_RIGHT);
	}
	
	
	public function addSecondaryComponent(pComponent:SmartComponent):Void {
		placeAndAddComponent(pComponent, containerBuildingHudSecondary, UIPosition.BOTTOM);
		pComponent.position.x += BuildingHud.virtualBuilding.getGraphicLocalBoundsAtFirstFrame().clone().width / 2;
	}
	
	public function placeAndAddComponent(pComponent:SmartComponent, pContainer:Container, pUIPos:String):Void {

		var lVBuilding:VBuilding = BuildingHud.virtualBuilding == null ? VTribunal.getInstance():BuildingHud.virtualBuilding;
		var lLocalBounds:Rectangle = lVBuilding.getGraphicLocalBoundsAtFirstFrame().clone();

		var lAnchor = new Point(lLocalBounds.x, lLocalBounds.y);
			
		var lRect:Point = lVBuilding.graphic.position.clone();
		pContainer.position.x = lRect.x + lAnchor.x;
		pContainer.position.y = lRect.y + lAnchor.y;

		
		if(pUIPos == UIPosition.BOTTOM || pUIPos == UIPosition.BOTTOM_RIGHT|| pUIPos == UIPosition.BOTTOM_LEFT) pContainer.position.y += lLocalBounds.height;
		if(pUIPos == UIPosition.BOTTOM_RIGHT) pContainer.position.x += lLocalBounds.width;
		pContainer.addChild(pComponent);
	}
	
	
	private function openContextual(pContextual:BuildingHud):Void{
		addComponent(pContextual);
		pContextual.setOnSpawn();
		currentBuildingHud = pContextual;
		
	}
	
	// todo : called from any clic outside a building
	public function hideBuildingHud ():Void {
		changeBuildingHud(BuildingHudType.NONE);
	}
	

	private function addListeners ():Void {
		ResourcesManager.totalResourcesEvent.on(ResourcesManager.TOTAL_RESOURCES_EVENT_NAME, refreshTextValue);
		btnShop = cast(SmartCheck.getChildByName(this, AssetName.HUD_BTN_SHOP), SmartButton);
		btnPurgatory = cast(SmartCheck.getChildByName(this, AssetName.HUD_BTN_PURGATORY), SmartButton);
		btnInterns = cast(SmartCheck.getChildByName(this, AssetName.HUD_BTN_INTERNS), SmartButton);
		btnInternBloc = cast(SmartCheck.getChildByName(this, AssetName.HUD_BTN_INTERNS_LOCK), SmartComponent);
		btnOptions = cast(SmartCheck.getChildByName(this, AssetName.HUD_BTN_OPTIONS), SmartButton);
		
		buttonMissionDeco = cast(SmartCheck.getChildByName(this, AssetName.HUD_MISSION_DECO), SmartButton);
		
		hellXPBar = cast(SmartCheck.getChildByName(this, AssetName.XP_GAUGE_HELL), SmartComponent);
		heavenXPBar = cast(SmartCheck.getChildByName(this, AssetName.XP_GAUGE_HEAVEN), SmartComponent);
		
		lBarHeaven = cast(heavenXPBar.getChildByName(AssetName.HUD_XP_GAUGE_MASK_HEAVEN_CONTAINER), UIMovie);
		lBarHell = cast(hellXPBar.getChildByName(AssetName.HUD_XP_GAUGE_MASK_HELL_CONTAINER), UIMovie);
		
		
		addListenersOnClick();
		setGlowFalse();
		eChangeBH.addListener(EVENT_CHANGE_BUIDINGHUD, needToChangeBH);
	}
	
	public function setGlowFalse():Void{
		var lGlowHell:Dynamic = lBarHell.children[0];
		var lGlowHeaven:Dynamic = lBarHeaven.children[0];
		SmartCheck.getChildByName(lGlowHell, "ftueGlow").visible = false;
		SmartCheck.getChildByName(lGlowHeaven, "ftueGlow").visible = false;
	}
	
	public function setGlowTrue(pBar:UIMovie):Void {
		var lGlow:Dynamic = pBar.children[0];
		SmartCheck.getChildByName(lGlow, "ftueGlow").visible = true;
	}
	
	private function addListenersOnClick() {
		//FTUE : désolé j'ai du faire ça sinon impossible de recolter les golds
		if (DialogueManager.ftueStepRecolt || DialogueManager.ftueStepConstructBuilding ||  DialogueManager.ftueStepOpenPurgatory) {
			btnShop.interactive = false;
			btnInterns.interactive = false;
			btnOptions.interactive = false;
			btnPurgatory.interactive = false;
			buttonMissionDeco.interactive = false;
			return;
		}
		else {
			btnShop.interactive = true;
			btnInterns.interactive = true;
			btnOptions.interactive = true;
			btnPurgatory.interactive = true;	
			buttonMissionDeco.interactive = true;	
		}
		Timer.delay( setInternButtonUnderLevel3,500);
		
		//Interactive.addListenerClick(btnResetData, onClickResetData);
		Interactive.addListenerClick(btnShop, onClickShop);
		Interactive.addListenerClick(btnPurgatory, onClickTribunal);
		Interactive.addListenerClick(btnInterns, onClickListIntern);
		Interactive.addListenerClick(btnOptions, onClickOptions); // todo 
		Interactive.addListenerRewrite(buttonMissionDeco, rewriteBtn); // todo 
		
		var woodMc:Dynamic = SmartCheck.getChildByName(this, AssetName.HUD_COUNTER_MATERIAL_HELL);
		var ironMc:Dynamic = SmartCheck.getChildByName(this, AssetName.HUD_COUNTER_MATERIAL_HEAVEN);
		softMc = SmartCheck.getChildByName(this, AssetName.HUD_COUNTER_SOFT);
		hardMc = SmartCheck.getChildByName(this, AssetName.HUD_COUNTER_HARD);
		
		btnIron = cast(SmartCheck.getChildByName(woodMc, AssetName.HUD_BTN_IRON), SmartButton);
		btnWood = cast(SmartCheck.getChildByName(ironMc, AssetName.HUD_BTN_WOOD), SmartButton);
		btnSoft = cast(SmartCheck.getChildByName(softMc, AssetName.HUD_BTN_SOFT), SmartButton);
		btnHard = cast(SmartCheck.getChildByName(hardMc, AssetName.HUD_BTN_HARD), SmartButton);
		
		Interactive.addListenerClick(btnIron, onClickShopResource);
		Interactive.addListenerClick(btnWood, onClickShopResource);		
		Interactive.addListenerClick(btnSoft, onClickShopCurrencies);
		Interactive.addListenerClick(btnHard, onClickShopCurrencies);
		
		//Main.getInstance().stage.addListener(MouseEventType.RIGHT_CLICK, onKeyDown);
	}
	
	private function setInternButtonUnderLevel3():Void {
		
		if (ResourcesManager.getLevel() >= LEVEL_UNLOCK_INTERNS) {
			btnInterns.interactive = true;
			btnInternBloc.visible = false;
		}
		else {
			btnInternBloc.visible = true;
			btnInterns.interactive = false;	
		}
	}
	
	private function rewriteBtn():Void {
		HudMissionButton.updateHud();
	}
	
	private function registerForFTUE (pEvent:EventTarget):Void {
		for (i in 0...children.length) {
			if (Std.is(children[i],SmartButton)) DialogueManager.register(children[i],true);
		}
		off(EventType.ADDED, registerForFTUE);
	}
	
	public function initGauges():Void {
		cast(heavenXPBar.getChildByName(AssetName.HUD_XP_GAUGE_MASK_HEAVEN_CONTAINER), UIMovie).goToAndStop(0);		
		cast(hellXPBar.getChildByName(AssetName.HUD_XP_GAUGE_MASK_HELL_CONTAINER), UIMovie).goToAndStop(0);	
	}
	
	public function initGaugesWithSave():Void{
		setXpGauge();
	}
	
	public function setXpGauge():Void {
		var percentXp:Int = Std.int(100 * ResourcesManager.getResourcesData().totalsMap[GeneratorType.badXp] / ExperienceManager.getMaxExp(cast(ResourcesManager.getLevel(), Int)));
		cast(hellXPBar.getChildByName(AssetName.HUD_XP_GAUGE_MASK_HELL_CONTAINER), UIMovie).goToAndStop(percentXp);
		
		percentXp = Std.int(100*ResourcesManager.getResourcesData().totalsMap[GeneratorType.goodXp] / ExperienceManager.getMaxExp(cast(ResourcesManager.getLevel(), Int)));
		cast(heavenXPBar.getChildByName(AssetName.HUD_XP_GAUGE_MASK_HEAVEN_CONTAINER), UIMovie).goToAndStop(percentXp);
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
		
		if (pCurrentState != VBuildingState.isBuilding && pCurrentState != VBuildingState.isUpgrading)
			if (DialogueManager.ftueStepRecolt || DialogueManager.ftueStepConstructBuilding || DialogueManager.ftueStepOpenPurgatory)
				return;
			
		//trace(pCurrentState);
	/*	if (DialogueManager.ftueStepOpenPurgatory)
		if(pVBuilding.alignementBuilding.getName() !=neutral*/
		if (pCurrentState == VBuildingState.isBuilt)
			lBuidldingHudType = BuildingHudType.HARVEST;
		else if (pCurrentState == VBuildingState.isBuilding)
			lBuidldingHudType = BuildingHudType.CONSTRUCTION;
		else if (pCurrentState == VBuildingState.isMoving)
			lBuidldingHudType = BuildingHudType.MOVING;
		else if (pCurrentState == VBuildingState.isUpgrading)
			lBuidldingHudType = BuildingHudType.UPGRADING;
			
		changeBuildingHud(
			lBuidldingHudType,
			pVBuilding
		);
	}
	
	private function checkIfTribunal(pVbuilding:VBuilding):Bool {
		return (Std.is(pVbuilding.graphic, Tribunal));
	}
	
	public function checkIfInternHouseHell(pVbuilding:VBuilding):Bool {
		return (Std.is(pVbuilding.graphic, InternHouseHell));
	}
	
	public function checkIfInternHouseHeaven(pVbuilding:VBuilding):Bool {
		return (Std.is(pVbuilding.graphic, InternHouseHeaven));
	}
	
	private function onClickShop ():Void {
		if (DialogueManager.ftueStepClickShop)
			DialogueManager.endOfaDialogue(true);
		
		UIManager.getInstance().openPopin(ShopPopin.getInstance());
		if (DialogueManager.ftueStepOpenShopIntern || DialogueManager.ftueStepBuyIntern)
			ShopPopin.getInstance().init(ShopTab.Interns);
		else
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
		if (DialogueManager.ftueStepRecolt || DialogueManager.ftueStepConstructBuilding)
			return
		closeCurrentBuildingHud();
		UIManager.getInstance().openPopin(TribunalPopin.getInstance());
		hide();
	}
	
	private function onClickListIntern() {
		UIManager.getInstance().openPopin(ListInternPopin.getInstance());
		hide();
		if (DialogueManager.ftueStepClickOnIntern)
			DialogueManager.endOfaDialogue(true);
		
	}
	
	private function onClickOptions() {
		UIManager.getInstance().openPopin(OptionPoppin.getInstance());
		hide();
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
		text.text = pMax != null ? pValue + " / " + pMax : ResourcesManager.shortenValue(pValue);
	}
	
	/**
	 * hide the hud
	 */
	public function hide():Void { // todo : should still show phantom menu (accept or cancel build)
		if (!isHide) {
			visible = false;
			// this line bellow is from Alexis for FTUE
			removeListenersClick();
			//ButtonRegion.hide();
			isHide = true;
		}
	}
	
	/**
	 * show the hud
	 */
	public function show():Void { // todo : should still show phantom menu (accept or cancel build)
		if (isHide) {	
			visible = true;
			isHide = false;
			//ButtonRegion.show();
		}
		// Alexis : let this outside, for FTUE, (Ambroise: he don't know why)
		// this line bellow is from Alexis for FTUE
		addListenersOnClick();
	}
	
	private function removeListenersClick() {
		//Interactive.removeListenerClick(btnResetData, onClickResetData);
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
		eChangeBH.removeListener(EVENT_CHANGE_BUIDINGHUD, needToChangeBH);
		ResourcesManager.totalResourcesEvent.off(ResourcesManager.TOTAL_RESOURCES_EVENT_NAME, refreshTextValue);
		instance = null;
		super.destroy();
	}

}