package com.isartdigital.perle.ui.popin.shop;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.ui.smart.SmartComponent;

	
/**
 * ...
 * @author ambroise
 */
class ShopCaroussel extends SmartComponent {
	

	//private static var instance: ShopItemList;
	

	/*public static function getInstance (): ShopItemList {
		if (instance == null) instance = new ShopItemList();
		return instance;
	}*/
	
	public function new(pID:String=null) { // used in UIBuilder.hx
		super(pID);
			
		var test = cast(SmartCheck.getChildByName(this, AssetName.SHOP_BTN_ITEM_UNLOCKED), SmartComponent);
		test.interactive = true;
		test.on(MouseEventType.CLICK, _click);
	}
	
	private function _click ():Void {
		UIManager.getInstance().openPopin(ConfirmBuyBuilding.getInstance());
	}
	
	/*override public function destroy (): Void {
		instance = null;
	}*/

}