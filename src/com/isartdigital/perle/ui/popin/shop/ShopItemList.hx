package com.isartdigital.perle.ui.popin.shop;

import com.isartdigital.utils.ui.smart.SmartComponent;

	
/**
 * ...
 * @author ambroise
 */
class ShopItemList extends SmartComponent {
	

	private static var instance: ShopItemList;
	

	public static function getInstance (): ShopItemList {
		if (instance == null) instance = new ShopItemList();
		return instance;
	}
	
	public function new(pID:String=null) {
		super(pID);
		
	}
	
	override public function destroy (): Void {
		instance = null;
	}

}