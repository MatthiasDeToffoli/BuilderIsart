package com.isartdigital.perle.ui.popin.shop;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.ui.popin.listIntern.ListInternPopin;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.SmartPopin;
import com.isartdigital.utils.ui.smart.UISprite;
import pixi.core.math.Point;

enum ShopTab { Building; Interns; Deco; Resources; Currencies; }
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
	
	public static function getInstance (pTab:ShopTab): ShopPopin {
		if (instance == null) instance = new ShopPopin(pTab);
		return instance;
	}	
	
	private function new(pTab:ShopTab) {
		modal = false;
		super(AssetName.POPIN_SHOP);
		
		tabs = new Map<ShopTab, SmartComponent>();
		bars = new Map<ShopBar, SmartComponent>();
		initCarousselPos(AssetName.SHOP_CAROUSSEL_SPAWNER);
		
		btnExit = cast(SmartCheck.getChildByName(this, AssetName.SHOP_BTN_CLOSE), SmartButton);
		btnPurgatory = cast(SmartCheck.getChildByName(this, AssetName.SHOP_BTN_PURGATORY), SmartButton);
		btnInterns = cast(SmartCheck.getChildByName(this, AssetName.SHOP_BTN_INTERNS), SmartButton);
		
		tabs[ShopTab.Building] = cast(SmartCheck.getChildByName(this, AssetName.SHOP_BTN_TAB_BUILDING), SmartButton);
		tabs[ShopTab.Interns] = cast(SmartCheck.getChildByName(this, AssetName.SHOP_BTN_TAB_INTERN), SmartButton);
		tabs[ShopTab.Deco] = cast(SmartCheck.getChildByName(this, AssetName.SHOP_BTN_TAB_DECO), SmartButton);
		tabs[ShopTab.Resources] = cast(SmartCheck.getChildByName(this, AssetName.SHOP_BTN_TAB_RESOURCE), SmartButton);
		tabs[ShopTab.Currencies] = cast(SmartCheck.getChildByName(this, AssetName.SHOP_BTN_TAB_CURRENCIE), SmartButton);
		//bars[ShopBar.Soft] = cast(getChildByName('Player_SC'), SmartComponent);
		//bars[ShopBar.Hard] = cast(getChildByName('Player_HC'), SmartComponent);
		//bars[ShopBar.Marble] = cast(getChildByName('Player_Marbre'), SmartButton);
		//bars[ShopBar.Wood] = cast(getChildByName('Player_Bois'), SmartButton);
		tabs[ShopTab.Building].on(MouseEventType.CLICK, onClickOpenBuldings);
		tabs[ShopTab.Deco].on(MouseEventType.CLICK, onClickOpenDecorations);
		
		btnExit.on(MouseEventType.CLICK, onClickExit);
		btnPurgatory.on(MouseEventType.CLICK, onClickPurgatory);
		btnInterns.on(MouseEventType.CLICK, onClickInterns);
		
		addCaroussel();
		
		checkOfOngletToOpen(pTab);
		//bars[ShopBar.Soft].on(MouseEventType.CLICK, onClickFakeBuySoft);
		//bars[ShopBar.Hard].on(MouseEventType.CLICK, onClickFakeBuyHard);
		
		//var test = cast(getChildByName('Shop_Item_List'), ShopItemList);
		//ShopItemList.getInstance(); // todo : là je fais quoi, je recrée ou je prends celui deja présent ?
		// screen achat etdescription
	}
	
	private function checkOfOngletToOpen(pTab:ShopTab):Void {
		switch(pTab.getName()) {
			case "Building" : onClickOpenBuldings();
			case "Deco" : onClickOpenDecorations();
			/*case "Interns" : onClickOpenBuldings();
			case "Resources" : onClickOpenBuldings();
			case "Currencies" : onClickOpenBuldings();*/
		}
	}
	
	private function addCaroussel():Void {
		caroussel = new ShopCaroussel();
		caroussel.init(carousselPos);
		addChild(caroussel);
		caroussel.start();
	}
	
	private function initCarousselPos (pAssetName:String):Void {
		carousselSpawner = cast(SmartCheck.getChildByName(this, pAssetName), UISprite);
		carousselPos = new Point();
		carousselPos.copy(carousselSpawner.position);
		removeChild(carousselSpawner);
		carousselSpawner.destroy();
	}
	
	private function onClickOpenBuldings() {
		caroussel.changeCardsToShow(ShopCaroussel.buildingNameList);
	}
	
	private function onClickOpenDecorations() {
		caroussel.changeCardsToShow(ShopCaroussel.decoNameList);
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