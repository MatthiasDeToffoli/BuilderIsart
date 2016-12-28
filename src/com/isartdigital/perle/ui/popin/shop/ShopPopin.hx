package com.isartdigital.perle.ui.popin.shop;

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
		super("Shop_Building");
		
		tabs = new Map<ShopTab, SmartComponent>();
		bars = new Map<ShopBar, SmartComponent>();
		
		/*for (i in 0...children.length) 
			trace (children[i].name);*/
			
		/*try {*/ // todo : pouah ya du boulot...
			// huuum faire des classes et recréer des élements ? ou ?
			caroussel = cast(getChildByName('Shop_Item_List'), ShopCaroussel);
			//cast(test, ShopCaroussel);
			btnExit = cast(getChildByName('Shop_Close_Button'), SmartButton);
			//btnPurgatory = cast(getChildByName('Purgatory_Button'), SmartButton);
			//btnInterns = cast(getChildByName('Interns_Button'), SmartButton);
			//tabs[ShopTab.Building] = cast(getChildByName('Onglet_Building'), SmartButton);
			//tabs[ShopTab.Interns] = cast(getChildByName('Onglet_Interns'), SmartButton);
			//tabs[ShopTab.Deco] = cast(getChildByName('Onglet_Deco'), SmartButton);
			//tabs[ShopTab.Resources] = cast(getChildByName('Onglet_Ressources'), SmartButton);
			//tabs[ShopTab.Currencies] = cast(getChildByName('Onglet_Currencies'), SmartButton);
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
		//bars[ShopBar.Soft].on(MouseEventType.CLICK, onClickFakeBuySoft);
		//bars[ShopBar.Hard].on(MouseEventType.CLICK, onClickFakeBuyHard);
		
		//var test = cast(getChildByName('Shop_Item_List'), ShopItemList);
		//ShopItemList.getInstance(); // todo : là je fais quoi, je recrée ou je prends celui deja présent ?
		// screen achat etdescription
	}
	
	private function onClickExit ():Void {
		UIManager.getInstance().closeCurrentPopin();
	}
	
	private function onClickFakeBuyBuilding ():Void { // todo temporaire
		UIManager.getInstance().openPopin(ConfirmBuyBuilding.getInstance());
	}
	
	private function onClickFakeBuySoft ():Void { // todo temporaire, confirmBuyCurrencie gère si soft ou hard
		trace("lol");
		UIManager.getInstance().openPopin(ConfirmBuyCurrencie.getInstance());
	}
	
	private function onClickFakeBuyHard ():Void { // todo temporaire
		UIManager.getInstance().openPopin(ConfirmBuyCurrencie.getInstance());
	}
	
	override public function destroy():Void {
		instance = null;
		super.destroy();
	}
	
}