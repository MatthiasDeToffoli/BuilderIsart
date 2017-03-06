package com.isartdigital.perle.ui.contextual.virtual;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorDescription;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.ui.contextual.VHudContextual;
import com.isartdigital.perle.ui.contextual.sprites.ButtonProduction;
import com.isartdigital.perle.ui.contextual.sprites.ButtonProductionGenerator;

/**
 * contain all information for the button production link to a generator
 * @author de Toffoli Matthias
 * @author Rabier Ambroise
 */
class VButtonProductionGenerator extends VButtonProduction
{
	
	/**
	 * description of the generator link te this button
	 */
	private var myGeneratorDesc:GeneratorDescription;

	public function new() 
	{
		super();
		ResourcesManager.generatorEvent.on(ResourcesManager.GENERATOR_EVENT_NAME, onGeneratorEvent);
	}
	
	override public function init(pVHud:VHudContextual):Void 
	{
		super.init(pVHud);
		myGeneratorDesc = ResourcesManager.getGenerator(refBuilding, pVHud.myVBuilding.myGeneratorType);
		generatorIsNotEmpty = ResourcesManager.GeneratorIsNotEmpty(myGeneratorDesc);
	}
	
	/**
	 * when the générator have changement (if he increase is value or when he send his resources to his total)
	 * @param	data object contain the id of the generator and a boolean said if the generator is empty or not
	 */
	private function onGeneratorEvent(data:Dynamic):Void {
		if (data.forButton && data.id == refBuilding && myBtn == null) {
			
			generatorIsNotEmpty = data.active; // j'appellerais cela plutôt empty ou notEmpty plutôt que active
			
			if (shoulBeVisible() && graphic == null)
				addGraphic();
			else if (active && !generatorIsNotEmpty)
				removeGraphic();
		}
		
		if (myBtn != null) cast(myBtn,ButtonProductionGenerator).setScale();
	}
	
	override function addGraphic():Void 
	{
		myBtn = new ButtonProductionGenerator(myGeneratorDesc.type);
		cast(myBtn,ButtonProductionGenerator).setMyGeneratorDescription(myGeneratorDesc);
		super.addGraphic();
	}
	
	override public function activate():Void {
		super.activate();
		if (myBtn != null) cast(myBtn,ButtonProductionGenerator).setScale();
	}
	
	override public function desactivate():Void {
		ResourcesManager.generatorEvent.off(ResourcesManager.GENERATOR_EVENT_NAME, onGeneratorEvent);
		super.desactivate();
	}
	
	override public function destroy() {
		ResourcesManager.generatorEvent.off(ResourcesManager.GENERATOR_EVENT_NAME, onGeneratorEvent);
		super.destroy();
	}
	
}