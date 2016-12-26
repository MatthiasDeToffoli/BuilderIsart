package com.isartdigital.perle.ui.popin.shop;

import com.isartdigital.utils.ui.smart.SmartPopin;

/**
 * ...
 * @author ambroise
 */
class ConfirmBuyBuilding extends SmartPopin{

	private static var instance:ConfirmBuyBuilding;
	
	public static function getInstance (): ConfirmBuyBuilding {
		if (instance == null) instance = new ConfirmBuyBuilding();
		return instance;
	}	
	
	private function new() {
		super("Popin_ConfirmBuyHouse");
		
	}
	
	override public function destroy():Void {
		instance = null;
		super.destroy();
	}
	
}