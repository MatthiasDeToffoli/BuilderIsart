package com.isartdigital.perle.ui.contextual.virtual;
import com.isartdigital.perle.game.managers.TimeManager;

/**
 * ...
 * @author de Toffoli Matthias
 */
class VButtonProductionCollector extends VButtonProduction
{

	public function new() 
	{
		super();
		
		TimeManager.eProduction.on(TimeManager.EVENT_COLLECTOR_PRODUCTION_FINE, onProdFine);
	}
	
	private function onProdFine(){
		generatorIsNotEmpty = true;
	}
	
	override function addGraphic():Void 
	{
		super.addGraphic();
	}
	override public function destroy():Void 
	{
		TimeManager.eProduction.off(TimeManager.EVENT_COLLECTOR_PRODUCTION_FINE, onProdFine);
		super.destroy();
	}
}