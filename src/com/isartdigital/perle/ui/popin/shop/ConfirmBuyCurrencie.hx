package com.isartdigital.perle.ui.popin.shop;
import com.isartdigital.utils.ui.smart.SmartPopin;

/**
 * ...
 * @author ambroise
 */
class ConfirmBuyCurrencie extends SmartPopin{

	private static var instance:ConfirmBuyCurrencie;
	
	public static function getInstance (): ConfirmBuyCurrencie {
		if (instance == null) instance = new ConfirmBuyCurrencie();
		return instance;
	}	
	
	private function new() {
		super('Popin_ConfirmBuyEuro');
	}
	
	override public function destroy():Void {
		instance = null;
		super.destroy();
	}
	
}