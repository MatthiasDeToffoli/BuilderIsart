package com.isartdigital.perle.ui.popin.shop;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.DialogueManager;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.ui.popin.isartPoints.IsartPointsPoppin;
import com.isartdigital.perle.ui.popin.shop.caroussel.ShopCaroussel;
import com.isartdigital.perle.ui.popin.shop.caroussel.ShopCarousselBuilding;
import com.isartdigital.perle.ui.popin.shop.caroussel.ShopCarousselBundle;
import com.isartdigital.perle.ui.popin.shop.caroussel.ShopCarousselCurrencies;
import com.isartdigital.perle.ui.popin.shop.caroussel.ShopCarousselDeco;
import com.isartdigital.perle.ui.popin.shop.caroussel.ShopCarousselInterns;
import com.isartdigital.perle.ui.popin.shop.caroussel.ShopCarousselInternsSearch;
import com.isartdigital.perle.ui.popin.shop.caroussel.ShopCarousselResource;
import com.isartdigital.perle.ui.SmartPopinExtended;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.Debug;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.localisation.Localisation;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UIMovie;
import com.isartdigital.utils.ui.smart.UISprite;
import js.Browser;
import js.Lib;
import pixi.core.math.Point;

enum ShopTab { Building; Interns; InternsSearch; Deco; Resources; Currencies; Bundle; }
enum ShopBar { Soft; Hard; Marble; Wood; }

/**
 * ...
 * @author ambroise & alexis
 */
class ShopPopin extends SmartPopinExtended {
	
	private static var instance:ShopPopin;
	private static var buttonTab:Array<Array<SmartButton>>;
	
	private var btnExit:SmartButton;
	private var tabs:Map<ShopTab, SmartComponent>;
	private var bars:Map<ShopBar, SmartComponent>;
	private var carousselSpawner:UISprite;
	
	public var lSC:SmartComponent;
	public var lHC:SmartComponent;
	public var lmarbre:SmartComponent;
	public var lwood:SmartComponent;
	
	public var shopTabSCIcon:UISprite;
	public var shopTabHCIcon:UIMovie;
	public var shopTabWoodIcon:UISprite;
	public var shopTabIronIcon:UISprite;
	
	private var lSCtext:TextSprite;
	private var lHCtext:TextSprite;
	private var lmarbretext:TextSprite;
	private var lwoodtext:TextSprite;
	
	public static var isSearching:Bool;
	
	private var carousselPos:Point;
	private var caroussel:ShopCaroussel;
	
	private var buttonOpenBundle:SmartComponent;
	private var buttonBuilding1:SmartButton;
	private var buttonBuilding2:SmartButton;
	private var buttonDeco1:SmartButton;
	private var buttonDeco2:SmartButton;
	private var buttonIntern1:SmartButton;
	private var buttonIntern2:SmartButton;
	private var buttonCurrencies1:SmartButton;
	private var buttonCurrencies2:SmartButton;
	private var buttonRessources1:SmartButton;
	private var buttonRessources2:SmartButton;
	private var buttonBundle1:SmartButton;
	private var buttonBundle2:SmartButton;
	
	private var titleShop:SmartComponent;
	private var titleShopFrench:UISprite;
	private var titleShopEnglish:UISprite;
	
	public static function getInstance (): ShopPopin {
		if (instance == null) instance = new ShopPopin();
		return instance;
	}	
	
	private function new() {
		Hud.isHide = false;
		Hud.getInstance().hide();
		modal = false;
		super(AssetName.POPIN_SHOP);
		tabs = new Map<ShopTab, SmartComponent>();
		bars = new Map<ShopBar, SmartComponent>();
		initCarousselPos(AssetName.SHOP_CAROUSSEL_SPAWNER);
		SoundManager.getSound("SOUND_OPEN_MENU_SHOP").play();
		
		lSC = cast(SmartCheck.getChildByName(this, AssetName.SHOP_RESSOURCE_SC), SmartComponent);
		shopTabSCIcon = cast(SmartCheck.getChildByName(lSC, "_icon_softcurrency"), UISprite);
		lHC = cast(SmartCheck.getChildByName(this, AssetName.SHOP_RESSOURCE_HC), SmartComponent);
		shopTabHCIcon = cast(SmartCheck.getChildByName(lHC, "_icon_hardcurrency"), UIMovie);
		lmarbre = cast(SmartCheck.getChildByName(this, AssetName.SHOP_RESSOURCE_MARBRE), SmartComponent);
		shopTabWoodIcon = cast(SmartCheck.getChildByName(lmarbre, "_icon_wood"), UISprite);
		lwood = cast(SmartCheck.getChildByName(this, AssetName.SHOP_RESSOURCE_BOIS), SmartComponent);
		shopTabIronIcon = cast(SmartCheck.getChildByName(lwood, "_icon_wood"), UISprite);
		lSCtext = cast(SmartCheck.getChildByName(lSC, AssetName.SHOP_RESSOURCE_TEXT), TextSprite);
		lHCtext = cast(SmartCheck.getChildByName(lHC, AssetName.SHOP_RESSOURCE_TEXT), TextSprite);
		lmarbretext = cast(SmartCheck.getChildByName(lmarbre, AssetName.SHOP_RESSOURCE_TEXT), TextSprite);
		lwoodtext = cast(SmartCheck.getChildByName(lwood, AssetName.SHOP_RESSOURCE_TEXT), TextSprite);
		
		setCurrenciesNumber();
		btnExit = cast(SmartCheck.getChildByName(this, AssetName.SHOP_BTN_CLOSE), SmartButton);
		
		titleShop = cast(SmartCheck.getChildByName(this, "Shop_Title"), SmartComponent);
		titleShopFrench = cast(SmartCheck.getChildByName(titleShop, "_marcheTitle"), UISprite);
		titleShopEnglish = cast(SmartCheck.getChildByName(titleShop, "_shopTitle"), UISprite);
		//As we must display only the good translation and remove the other, we can't use the label system for the translation
		Localisation.actualLanguage == "en" ? titleShopFrench.visible = false : titleShopEnglish.visible = false;
		addButton();
		Interactive.addListenerClick(btnExit, onClickExit);
	}
	
	public function getIconSFPos():Point{
		return lSC.position;
	}
	
	public function setCurrenciesNumber():Void {
		lSCtext.text = ResourcesManager.shortenValue(ResourcesManager.getTotalForType(GeneratorType.soft));
		lHCtext.text = ResourcesManager.shortenValue(ResourcesManager.getTotalForType(GeneratorType.hard));
		lmarbretext.text = ResourcesManager.shortenValue(ResourcesManager.getTotalForType(GeneratorType.buildResourceFromHell));
		lwoodtext.text = ResourcesManager.shortenValue(ResourcesManager.getTotalForType(GeneratorType.buildResourceFromParadise));
	}
	
	private function addButton() {
		buttonTab = [];
		var tabBuilding = cast(SmartCheck.getChildByName(this, "Onglet_Building"), SmartComponent);
		buttonTab[0] = [];
		var tabDeco= cast(SmartCheck.getChildByName(this, "Onglet_Deco"), SmartComponent);
		buttonTab[1] = [];
		var tabInterns = cast(SmartCheck.getChildByName(this, "Onglet_Interns"), SmartComponent);
		buttonTab[2] = [];
		var tabCurrencies = cast(SmartCheck.getChildByName(this, "Onglet_Currencies"), SmartComponent);
		buttonTab[3] = [];
		var tabRessources = cast(SmartCheck.getChildByName(this, "Onglet_Ressources"), SmartComponent);
		buttonTab[4] = [];
		var tabBundle = cast(SmartCheck.getChildByName(this, "Bundles_Button"), SmartComponent);
		buttonTab[5] = [];
		
		buttonBuilding1 = cast(SmartCheck.getChildByName(tabBuilding, "Current"), SmartButton);
		Interactive.addListenerClick(buttonBuilding1, onClickOpenBuldings);
		buttonBuilding2 = cast(SmartCheck.getChildByName(tabBuilding, "Layer 1"), SmartButton);
		Interactive.addListenerClick(buttonBuilding2, onClickOpenBuldings);
		buttonTab[0].push(buttonBuilding1);
		buttonTab[0].push(buttonBuilding2);
		
		buttonDeco1 = cast(SmartCheck.getChildByName(tabDeco, "Current"), SmartButton);
		Interactive.addListenerClick(buttonDeco1, onClickOpenDecorations);
		buttonDeco2 = cast(SmartCheck.getChildByName(tabDeco, "Layer 1"), SmartButton);
		Interactive.addListenerClick(buttonDeco2, onClickOpenDecorations);
		buttonTab[1].push(buttonDeco1);
		buttonTab[1].push(buttonDeco2);
		
		buttonIntern1 = cast(SmartCheck.getChildByName(tabInterns, "Current"), SmartButton);
		Interactive.addListenerClick(buttonIntern1, onClickOpenInterns);
		buttonIntern2 = cast(SmartCheck.getChildByName(tabInterns, "Layer 1"), SmartButton);
		Interactive.addListenerClick(buttonIntern2, onClickOpenInterns);
		buttonTab[2].push(buttonIntern1);
		buttonTab[2].push(buttonIntern2);
		
		buttonCurrencies1 = cast(SmartCheck.getChildByName(tabCurrencies, "Current"), SmartButton);
		Interactive.addListenerClick(buttonCurrencies1, onClickOpenCurencies);
		buttonCurrencies2 = cast(SmartCheck.getChildByName(tabCurrencies, "Layer 1"), SmartButton);
		Interactive.addListenerClick(buttonCurrencies2, onClickOpenCurencies);
		buttonTab[3].push(buttonCurrencies1);
		buttonTab[3].push(buttonCurrencies2);
		
		buttonRessources1 = cast(SmartCheck.getChildByName(tabRessources, "Current"), SmartButton);
		Interactive.addListenerClick(buttonRessources1, onClickOpenResource);
		buttonRessources2 = cast(SmartCheck.getChildByName(tabRessources, "Layer 1"), SmartButton);
		Interactive.addListenerClick(buttonRessources2, onClickOpenResource);
		buttonTab[4].push(buttonRessources1);
		buttonTab[4].push(buttonRessources2);
		
		buttonBundle1 = cast(SmartCheck.getChildByName(tabBundle, "Current"), SmartButton);
		Interactive.addListenerClick(buttonBundle1, onClickOpenBundle);
		buttonBundle2 = cast(SmartCheck.getChildByName(tabBundle, "Layer 1"), SmartButton);
		Interactive.addListenerClick(buttonBundle2, onClickOpenBundle);
		buttonTab[5].push(buttonBundle1);
		buttonTab[5].push(buttonBundle2);
	}
	
	private function switchButtons() {
		for (i in 0...buttonTab.length) {
			buttonTab[i][0].visible = false;
		}
	}
	
	private function setButtons(pNumber:Int,?pBundleOn:Bool) {
		switchButtons();
		if (pBundleOn)
			return;
		buttonTab[pNumber][0].visible = true;
	}
	
	public function init(pTab:ShopTab) {
		switch(pTab) {
			case ShopTab.Building : onClickOpenBuldings();
			case ShopTab.Deco : onClickOpenDecorations();
			case ShopTab.Interns : onClickOpenInterns();
			case ShopTab.InternsSearch : onClickOpenInternsSearch();
			case ShopTab.Resources : onClickOpenResource();
			case ShopTab.Currencies : onClickOpenCurencies();
			case ShopTab.Bundle : onClickOpenBundle();
		}
	}
	
	public static function initSearch():Void{
		isSearching = false;
	}
	
	private function addCaroussel(pTab:ShopTab):Void {
		if (caroussel != null)
			caroussel.destroy();
		
		switch (pTab) {
			case ShopTab.Building: 		caroussel = new ShopCarousselBuilding();
			case ShopTab.Resources: 	caroussel = new ShopCarousselResource();
			case ShopTab.Deco: 			caroussel = new ShopCarousselDeco();
			case ShopTab.Currencies: 	caroussel = new ShopCarousselCurrencies();
			case ShopTab.Interns: 		caroussel = new ShopCarousselInterns();
			case ShopTab.InternsSearch: caroussel = new ShopCarousselInternsSearch();
			case ShopTab.Bundle: 		caroussel = new ShopCarousselBundle();
			default: Debug.error("Undefined caroussel class for ShopTab : " + pTab);
		}
		
		caroussel.init(carousselPos, pTab);
		addChild(caroussel);
	}
	
	public function removeCaroussel():Void {
		removeChild(caroussel);		
	}
	
	private function initCarousselPos (pAssetName:String):Void {
		carousselSpawner = cast(SmartCheck.getChildByName(this, pAssetName), UISprite);
		carousselPos = new Point();
		carousselPos.copy(carousselSpawner.position);
		removeChild(carousselSpawner);
		carousselSpawner.destroy();
	}
	
	private function onClickOpenBuldings () {
		if (DialogueManager.ftueStepClickOnIntern || DialogueManager.ftueStepBlocInterns)
			return;
		setButtons(0);
		addCaroussel(ShopTab.Building);
		SoundManager.getSound("SOUND_NEUTRAL").play();
	}
	
	private function onClickOpenDecorations () {
		if (DialogueManager.ftueStepClickOnCard || DialogueManager.ftueStepClickOnIntern)
			return;
		setButtons(1);
		addCaroussel(ShopTab.Deco);
		SoundManager.getSound("SOUND_NEUTRAL").play();
	}
	
	private function onClickOpenInterns () {
		if (DialogueManager.ftueStepBlocBuildings)
				return;
		/*if(!DialogueManager.ftueStepClickOnIntern)
			if (DialogueManager.ftueStepClickOnCard)
				return;*/
		SoundManager.getSound("SOUND_NEUTRAL").play();
		setButtons(2);
		isSearching ? onClickOpenInternsSearch() : addCaroussel(ShopTab.Interns);	
	}
	
	private function onClickOpenInternsSearch () {
		SoundManager.getSound("SOUND_NEUTRAL").play();
		addCaroussel(ShopTab.InternsSearch);
	}
	
	private function onClickOpenCurencies () {
		if (DialogueManager.ftueStepClickOnCard || DialogueManager.ftueStepClickOnIntern)
			return;
		setButtons(3);
		addCaroussel(ShopTab.Currencies);
		openIsartPointsPoppin();
		SoundManager.getSound("SOUND_NEUTRAL").play();
	}
	
	private function onClickOpenResource () {
		if (DialogueManager.ftueStepClickOnCard || DialogueManager.ftueStepClickOnIntern)
			return;
		setButtons(4);
		addCaroussel(ShopTab.Resources);
		SoundManager.getSound("SOUND_NEUTRAL").play();
	}
	
	private function onClickOpenBundle () {
		if (DialogueManager.ftueStepClickOnCard || DialogueManager.ftueStepClickOnIntern)
			return;
		setButtons(5);
		addCaroussel(ShopTab.Bundle);
		openIsartPointsPoppin();
		SoundManager.getSound("SOUND_NEUTRAL").play();
	}
	
	private function onClickExit ():Void {
		if (DialogueManager.ftueStepClickOnCard || DialogueManager.ftueStepClickOnIntern)
			return;
		Hud.getInstance().show();
		UIManager.getInstance().closeCurrentPopin();
		SoundManager.getSound("SOUND_NEUTRAL").play();
	}
	
	private function onClickPurgatory ():Void {
		UIManager.getInstance().closeCurrentPopin();
		UIManager.getInstance().openPopin(TribunalPopin.getInstance());
		SoundManager.getSound("SOUND_NEUTRAL").play();
	}
	
	private function onClickInterns ():Void {
		Browser.alert("Work in progress : Special Feature");
		//UIManager.getInstance().closeCurrentPopin();
		//UIManager.getInstance().openPopin(ListInternPopin.getInstance());
	}
	
	private function onClickFakeBuySoft ():Void { // todo temporaire, confirmBuyCurrencie gère si soft ou hard
		UIManager.getInstance().openPopin(ConfirmBuyCurrencie.getInstance());
	}
	
	private function onClickFakeBuyHard ():Void { // todo temporaire
		UIManager.getInstance().openPopin(ConfirmBuyCurrencie.getInstance());
	}
	
	private function openIsartPointsPoppin():Void {
		GameStage.getInstance().getFirstPoppinContainer().addChild(IsartPointsPoppin.getInstance());
	}
	
	public function closeIsartPointsPoppin():Void {
		GameStage.getInstance().getFirstPoppinContainer().removeChild(IsartPointsPoppin.getInstance());
	}
	
	override public function destroy():Void {
		Interactive.removeListenerClick(btnExit, onClickExit);
		
		//Interactive.removeListenerClick(buttonOpenBundle, onClickOpenBundle);
		Interactive.removeListenerClick(buttonBuilding1, onClickOpenBuldings);
		Interactive.removeListenerClick(buttonBuilding2, onClickOpenBuldings);
		Interactive.removeListenerClick(buttonDeco1, onClickOpenDecorations);
		Interactive.removeListenerClick(buttonDeco2, onClickOpenDecorations);
		Interactive.removeListenerClick(buttonIntern1, onClickOpenInterns);
		Interactive.removeListenerClick(buttonIntern2, onClickOpenInterns);
		Interactive.removeListenerClick(buttonCurrencies1, onClickOpenCurencies);
		Interactive.removeListenerClick(buttonCurrencies2, onClickOpenCurencies);
		Interactive.removeListenerClick(buttonRessources1, onClickOpenResource);
		Interactive.removeListenerClick(buttonRessources2, onClickOpenResource);
		
		instance = null;
		super.destroy();
	}
	
}
