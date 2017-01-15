package com.isartdigital.perle.ui.popin.shop;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.ui.popin.listIntern.ListInternPopin;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.SmartPopin;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;
import js.Browser;
import pixi.core.math.Point;

enum ShopTab { Building; Interns; Deco; Resources; Currencies; Bundle; }
enum ShopBar { Soft; Hard; Marble; Wood; }

/**
 * ...
 * @author ambroise & alexis
 */
class ShopPopin extends SmartPopin{

	private static var instance:ShopPopin;
	
	private var btnExit:SmartButton;
	private var btnPurgatory:SmartButton;
	private var btnInterns:SmartButton;
	private var tabs:Map<ShopTab, SmartComponent>;
	private var bars:Map<ShopBar, SmartComponent>;
	private var carousselSpawner:UISprite;
	
	private var carousselPos:Point;
	private var caroussel:ShopCaroussel;
	
	
	public static function getInstance (): ShopPopin {
		if (instance == null) instance = new ShopPopin();
		return instance;
	}	
	
	private function new() {
		modal = false;
		super(AssetName.POPIN_SHOP);
		tabs = new Map<ShopTab, SmartComponent>();
		bars = new Map<ShopBar, SmartComponent>();
		initCarousselPos(AssetName.SHOP_CAROUSSEL_SPAWNER);
		
		
		var lSC = cast(SmartCheck.getChildByName(this, AssetName.SHOP_RESSOURCE_SC), SmartComponent);
		var lSCtext = cast(SmartCheck.getChildByName(lSC, AssetName.SHOP_RESSOURCE_TEXT), TextSprite);
		lSCtext.text = "" + ResourcesManager.getTotalForType(GeneratorType.soft);
		
		var lHC = cast(SmartCheck.getChildByName(this, AssetName.SHOP_RESSOURCE_HC), SmartComponent);
		var lHCtext = cast(SmartCheck.getChildByName(lHC, AssetName.SHOP_RESSOURCE_TEXT), TextSprite);
		lHCtext.text = "" + ResourcesManager.getTotalForType(GeneratorType.hard);
		
		var lmarbre = cast(SmartCheck.getChildByName(this, AssetName.SHOP_RESSOURCE_MARBRE), SmartComponent);
		var lmarbretext = cast(SmartCheck.getChildByName(lmarbre, AssetName.SHOP_RESSOURCE_TEXT), TextSprite);
		lmarbretext.text = "" + ResourcesManager.getTotalForType(GeneratorType.buildResourceFromHell);
		
		var lwood = cast(SmartCheck.getChildByName(this, AssetName.SHOP_RESSOURCE_BOIS), SmartComponent);
		var lwoodtext = cast(SmartCheck.getChildByName(lwood, AssetName.SHOP_RESSOURCE_TEXT), TextSprite);
		lwoodtext.text = ""+ResourcesManager.getTotalForType(GeneratorType.buildResourceFromParadise);
		
		btnExit = cast(SmartCheck.getChildByName(this, AssetName.SHOP_BTN_CLOSE), SmartButton);
		btnPurgatory = cast(SmartCheck.getChildByName(this, AssetName.SHOP_BTN_PURGATORY), SmartButton);
		btnInterns = cast(SmartCheck.getChildByName(this, AssetName.SHOP_BTN_INTERNS), SmartButton);
		
		tabs[ShopTab.Building] = cast(SmartCheck.getChildByName(this, AssetName.SHOP_BTN_TAB_BUILDING), SmartButton);
		tabs[ShopTab.Interns] = cast(SmartCheck.getChildByName(this, AssetName.SHOP_BTN_TAB_INTERN), SmartButton);
		tabs[ShopTab.Deco] = cast(SmartCheck.getChildByName(this, AssetName.SHOP_BTN_TAB_DECO), SmartButton);
		tabs[ShopTab.Resources] = cast(SmartCheck.getChildByName(this, AssetName.SHOP_BTN_TAB_RESOURCE), SmartButton);
		tabs[ShopTab.Currencies] = cast(SmartCheck.getChildByName(this, AssetName.SHOP_BTN_TAB_CURRENCIE), SmartButton);
		tabs[ShopTab.Bundle] = cast(SmartCheck.getChildByName(this, AssetName.SHOP_BTN_TAB_BUNDLE), SmartButton);
		//bars[ShopBar.Soft] = cast(getChildByName('Player_SC'), SmartComponent);
		//bars[ShopBar.Hard] = cast(getChildByName('Player_HC'), SmartComponent);
		//bars[ShopBar.Marble] = cast(getChildByName('Player_Marbre'), SmartButton);
		//bars[ShopBar.Wood] = cast(getChildByName('Player_Bois'), SmartButton);
		tabs[ShopTab.Building].on(MouseEventType.CLICK, onClickOpenBuldings);
		tabs[ShopTab.Deco].on(MouseEventType.CLICK, onClickOpenDecorations);
		tabs[ShopTab.Interns].on(MouseEventType.CLICK, onClickOpenIntern);
		tabs[ShopTab.Resources].on(MouseEventType.CLICK, onClickOpenResource);
		tabs[ShopTab.Currencies].on(MouseEventType.CLICK, onClickOpenCurencies);
		tabs[ShopTab.Bundle].on(MouseEventType.CLICK, onClickOpenBundle);
		
		btnExit.on(MouseEventType.CLICK, onClickExit);
		btnPurgatory.on(MouseEventType.CLICK, onClickPurgatory);
		btnInterns.on(MouseEventType.CLICK, onClickInterns);
		
		
		
		//bars[ShopBar.Soft].on(MouseEventType.CLICK, onClickFakeBuySoft);
		//bars[ShopBar.Hard].on(MouseEventType.CLICK, onClickFakeBuyHard);
		
		//var test = cast(getChildByName('Shop_Item_List'), ShopItemList);
		//ShopItemList.getInstance(); // todo : là je fais quoi, je recrée ou je prends celui deja présent ?
		// screen achat etdescription
	}
	
	public function init(pTab:ShopTab) {
		checkOfOngletToOpen(pTab);
	}
	
	private function checkOfOngletToOpen(pTab:ShopTab):Void {
		switch(pTab) {
			case ShopTab.Building : onClickOpenBuldings();
			case ShopTab.Deco : onClickOpenDecorations();
			case ShopTab.Interns : onClickOpenIntern();
			case ShopTab.Resources : onClickOpenResource();
			case ShopTab.Currencies : onClickOpenCurencies();
			case ShopTab.Bundle : onClickOpenBundle();
		}
	}
	
	private function addCaroussel(pTab:ShopTab):Void {
		if (caroussel != null)
			caroussel.destroy();
		
		if (pTab == ShopTab.Building)
			caroussel = new ShopCarousselBuilding();
		else if (pTab == ShopTab.Resources)
			caroussel = new ShopCarousselResource();
			
		caroussel.init(carousselPos);
		addChild(caroussel);
		caroussel.start();
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
	
	private function onClickOpenBuldings() {
		addCaroussel(ShopTab.Building);
		caroussel.changeCardsToShow(ShopCaroussel.buildingNameList); // todo: mettre cela dans le ShopCaroussel appelé, héritage
	}
	
	private function onClickOpenDecorations() {
		addCaroussel(ShopTab.Building);
		caroussel.changeCardsToShow(ShopCaroussel.decoNameList);
	}
	
	private function onClickOpenIntern() {
		addCaroussel(ShopTab.Building);
		
		Browser.alert("Work in progress : Special Feature");	
		caroussel.changeCardsToShow(ShopCaroussel.internsNameList);
	}
	
	private function onClickOpenResource() {
		addCaroussel(ShopTab.Resources);
		caroussel.changeCardsToShow(ShopCaroussel.resourcesNameList);
	}
	
	private function onClickOpenCurencies() {
		addCaroussel(ShopTab.Resources);
		caroussel.changeCardsToShow(ShopCaroussel.currencieNameList);
	}
	
	private function onClickOpenBundle() {
		addCaroussel(ShopTab.Building);
		Browser.alert("Work in progress");
		caroussel.changeCardsToShow(ShopCaroussel.bundleNameList);
	}
	
	private function onClickExit ():Void {
		Hud.getInstance().show();
		UIManager.getInstance().closeCurrentPopin();
	}
	
	private function onClickPurgatory ():Void {
		UIManager.getInstance().closeCurrentPopin();
		UIManager.getInstance().openPopin(TribunalPopin.getInstance());
	}
	
	private function onClickInterns ():Void {
		UIManager.getInstance().closeCurrentPopin();
		UIManager.getInstance().openPopin(ListInternPopin.getInstance());
	}
	
	private function onClickFakeBuySoft ():Void { // todo temporaire, confirmBuyCurrencie gère si soft ou hard
		UIManager.getInstance().openPopin(ConfirmBuyCurrencie.getInstance());
	}
	
	private function onClickFakeBuyHard ():Void { // todo temporaire
		UIManager.getInstance().openPopin(ConfirmBuyCurrencie.getInstance());
	}
	
	override public function destroy():Void {
		btnExit.removeListener(MouseEventType.CLICK, onClickExit);
		btnPurgatory.removeListener(MouseEventType.CLICK, onClickExit);
		btnInterns.removeListener(MouseEventType.CLICK, onClickExit);
		
		instance = null;
		super.destroy();
	}
	
}