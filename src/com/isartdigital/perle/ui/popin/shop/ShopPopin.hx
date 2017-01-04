package com.isartdigital.perle.ui.popin.shop;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.ui.popin.listIntern.ListInternPopin;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.SmartPopin;

enum ShopTab { Building; Interns; Deco; Resources; Currencies; }
enum ShopBar { Soft; Hard; Marble; Wood; }

/**
 * ...
 * @author ambroise
 */
class ShopPopin extends SmartPopin{

	private static var instance:ShopPopin;
	
	private var btnExit:SmartButton;
	private var btnPurgatory:SmartButton;
	private var btnInterns:SmartButton;
	private var tabs:Map<ShopTab, SmartComponent>;
	private var bars:Map<ShopBar, SmartComponent>;
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
		
		/*for (i in 0...children.length) 
			trace (children[i].name);*/
			
		/*try {*/ // todo : pouah ya du boulot...
			// huuum faire des classes et recréer des élements ? ou ?
			caroussel = cast(SmartCheck.getChildByName(this, AssetName.SHOP_CAROUSSEL), ShopCaroussel);
			//cast(test, ShopCaroussel);
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
		/*} catch (pError:Dynamic) {
			if (pError != null)
				trace(pError);
			trace('assetName changed in WireFrame in ' + 'ShopPopin');
		}*/
		btnExit.on(MouseEventType.CLICK, onClickExit);
		btnPurgatory.on(MouseEventType.CLICK, onClickPurgatory);
		btnInterns.on(MouseEventType.CLICK, onClickInterns);
		
		caroussel.init();
		//bars[ShopBar.Soft].on(MouseEventType.CLICK, onClickFakeBuySoft);
		//bars[ShopBar.Hard].on(MouseEventType.CLICK, onClickFakeBuyHard);
		
		//var test = cast(getChildByName('Shop_Item_List'), ShopItemList);
		//ShopItemList.getInstance(); // todo : là je fais quoi, je recrée ou je prends celui deja présent ?
		// screen achat etdescription
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
	
	private function onClickFakeBuyBuilding ():Void { // todo temporaire
		UIManager.getInstance().openPopin(ConfirmBuyBuilding.getInstance());
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