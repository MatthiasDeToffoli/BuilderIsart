package com.isartdigital.perle.ui.hud.building;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.virtual.vBuilding.VCollector;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.ui.smart.SmartButton;

/**
 * ...
 * @author de Toffoli Matthias
 */
class BHBuiltProductor extends BHBuiltUpgrade
{

	private var btnLastProd:SmartButton;
	private var timer:BuildingTimer;
	
	public function new(pID:String=null) 
	{
		super(pID);
		
	}
	
	override function findElements():Void 
	{
		btnLastProd = cast(getChildByName(AssetName.CONTEXTUAL_BTN_LAST_PRODUCTION), SmartButton);
		testIfAddTimer();
		super.findElements();
	}
	
	private function testIfAddTimer():Void {
		if (testIfProduct()) {
			removeChild(btnLastProd);
			createTimer();
		} else {
			Interactive.addListenerClick(btnLastProd,onClickDescription);
		}
	}
	
	private function testIfProduct():Bool {
		return false;
	}
	private function createTimer():Void {
		
	}
	
	private function onClickLastProduction():Void {
		trace("last prod");
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		if (timer != null) timer.destroy();
		super.destroy();
	}
	
}