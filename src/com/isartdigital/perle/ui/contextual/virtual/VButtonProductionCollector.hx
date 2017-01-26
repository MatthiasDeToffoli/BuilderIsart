package com.isartdigital.perle.ui.contextual.virtual;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.SaveManager.TimeCollectorProduction;
import com.isartdigital.perle.game.managers.TimeManager;
import com.isartdigital.perle.ui.contextual.VHudContextual;
import com.isartdigital.perle.ui.contextual.sprites.ButtonProductionCollector;

/**
 * ...
 * @author de Toffoli Matthias
 */
class VButtonProductionCollector extends VButtonProduction
{
	
	/**
	 * type of generator which had by this button
	 */
	private var resourceType:GeneratorType;
	private var gain:Int;

	public function new() 
	{
		super();
		TimeManager.eProduction.on(TimeManager.EVENT_COLLECTOR_PRODUCTION_FINE, onProdFine);
		TimeManager.eProduction.on(TimeManager.EVENT_COLLECTOR_PRODUCTION_STOP, onProdStop);
	}
	
	private function onProdFine(pTimeProd:TimeCollectorProduction):Void{
		
		if (pTimeProd.buildingRef != refBuilding) return;
		
		if (!generatorIsNotEmpty){
			gain = pTimeProd.gain;
			generatorIsNotEmpty = true;

			if (shoulBeVisible() && graphic == null)
				addGraphic();
		}
		
	}
	
	private function onProdStop(pRef:Int):Void {
		if (pRef != refBuilding) return;
		
		generatorIsNotEmpty = false;
		removeGraphic();
	}
	
	override public function init(pVHud:VHudContextual):Void 
	{
		resourceType = pVHud.myVBuilding.myGeneratorType;
		super.init(pVHud);
	}
	override function addGraphic():Void 
	{
		myBtn = new ButtonProductionCollector(resourceType,gain,refBuilding);
		super.addGraphic();
	}
	override public function destroy():Void 
	{
		TimeManager.eProduction.off(TimeManager.EVENT_COLLECTOR_PRODUCTION_FINE, onProdFine);
		TimeManager.eProduction.off(TimeManager.EVENT_COLLECTOR_PRODUCTION_STOP, onProdStop);
		super.destroy();
	}
}