package com.isartdigital.perle.ui.popin.shop;

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
	
	public function new(pID:String=null) {
		super(pID);
		
		/*for (i in 0...children.length) 
			trace (children[i].name);*/
			
			
		var test = cast(getChildByName('Shop_Item_Unlocked'), SmartComponent);
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