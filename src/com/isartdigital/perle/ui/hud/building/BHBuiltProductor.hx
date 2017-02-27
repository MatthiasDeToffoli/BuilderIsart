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

	private var timer:BuildingTimer;
	
	public function new(pID:String=null) 
	{
		super(pID);
		
	}
	
	override function findElements():Void 
	{
		testIfAddTimer();
		super.findElements();
	}
	
	private function testIfAddTimer():Void {
		if (testIfProduct()) {
			createTimer();
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