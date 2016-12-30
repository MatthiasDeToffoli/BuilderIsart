package com.isartdigital.perle.ui.contextual.virtual;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorDescription;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.ui.contextual.sprites.ButtonProduction;
import com.isartdigital.perle.ui.contextual.HudContextual;
import com.isartdigital.utils.ui.smart.SmartComponent;
import pixi.core.display.Container;
import pixi.core.math.Point;


/**
 * contain all information for the button production
 * Is not saved, is not in clipping List directly, is contained by VHudContextual
 * @author de Toffoli Matthias
 */
class VButtonProduction extends VSmartComponent
{
	
	/**
	 * description of the generator link te this button
	 */
	private var myGeneratorDesc:GeneratorDescription;
	
	/**
	 * id of the building link to this button
	 */
	private var refBuilding:Int;
	
	/**
	 * type of generator which had by this button
	 */
	private var resourceType:GeneratorType;
	
	/**
	 * say if generator is empty of not
	 */
	private var generatorIsNotEmpty = false;
	
	private var buildingIsInView:Bool;

	public function new() 
	{
		super();
		ResourcesManager.generatorEvent.on(ResourcesManager.GENERATOR_EVENT_NAME, onGeneratorEvent);
	}
	
	/**
	 * initialiste the virtual button production and set the graphic position the building ref, the generator description and the hud container
	 * @param	pRefBuilding the building reference
	 * @param	pType the type of generator
	 * @param	pHud the hud which contained the graphic
	 */
	override public function init (pVHud:VHudContextual):Void {
		super.init(pVHud);
		refBuilding = pVHud.myVBuilding.tileDesc.id;
		myGeneratorDesc = ResourcesManager.getGenerator(refBuilding, pVHud.myVBuilding.myGeneratorType);
		generatorIsNotEmpty = ResourcesManager.GeneratorIsNotEmpty(myGeneratorDesc);
	}
	
	/**
	 * when the générator have changement (if he increase is value or when he send his resources to his total)
	 * @param	data object contain the id of the generator and a boolean said if the generator is empty or not
	 */
	private function onGeneratorEvent(data:Dynamic):Void{
		if (data.id == refBuilding)
			if (data.active) { 
				// @TODO : plutôt que d'envoyer data.active il devrait envoyer data.empty
				// empty faisant référence à ce que contient le générateur
				// car là le generator se mèle des affaire qui le concerne pas en mettant
				// .active (qui fait référence dans nos tête à this.active du clipping)
				generatorIsNotEmpty = true;
				if (!active && buildingIsInView)
					activate();
			}
			else{
				generatorIsNotEmpty = false;
				if (active)
					desactivate();
			}
	}
	
	/**
	 * addchild the goldbutton if the generator is not empty and the building is active
	 */
	override public function activate ():Void {
		buildingIsInView = true;
		
		if (generatorIsNotEmpty) {	
			super.activate(); // put active to true
			
			var lButton:ButtonProduction = new ButtonProduction();
			graphic = cast(lButton, Container);
			
			lButton.setMyGeneratorDescription(myGeneratorDesc);
			
			cast(myVHudContextual.graphic, HudContextual).addComponent(
				cast(lButton, SmartComponent)
			);
		} 
	}
	
	override public function desactivate ():Void {
		buildingIsInView = false;
		
		super.desactivate(); //@TODO: rendre le btn clippable en ajoutant l'implement
	}
	
	override public function destroy() {	
		ResourcesManager.generatorEvent.off(ResourcesManager.GENERATOR_EVENT_NAME, onGeneratorEvent);
		super.destroy();
	}
}