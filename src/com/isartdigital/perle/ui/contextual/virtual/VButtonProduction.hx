package com.isartdigital.perle.ui.contextual.virtual;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorDescription;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.ui.contextual.HudContextual;
import com.isartdigital.perle.ui.contextual.sprites.ButtonProduction;
import com.isartdigital.utils.ui.smart.SmartComponent;
import pixi.core.display.Container;


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
	private function onGeneratorEvent(data:Dynamic):Void {
		if (data.forButton && data.id == refBuilding) {
			
			generatorIsNotEmpty = data.active; // j'appellerais cela plutôt empty ou notEmpty plutôt que active
			
			if (shoulBeVisible() && graphic == null)
				addGraphic();
			else if (active && !generatorIsNotEmpty)
				removeGraphic();
		}
	}
	
	private function shoulBeVisible ():Bool {
		return active && generatorIsNotEmpty;
	}
	
	// a titre de comprehension
	private function shouldBeHidden ():Bool {
		return (active && !generatorIsNotEmpty) || (!active);
	}
	
	// todo : faire une methode addgraphic ds virtual et l'ovverride, changer ds les autres descendant de virtual egalement
	// et du coup condition a l'interrieur de cette function
	private function addGraphic ():Void {
		var lButton:ButtonProduction = new ButtonProduction();
		
		graphic = cast(lButton, Container);
		
		lButton.setMyGeneratorDescription(myGeneratorDesc);
		
		cast(myVHudContextual.graphic, HudContextual).addComponentBtnProd(
			cast(lButton, SmartComponent)
		);
	}
	
	/**
	 * addchild the goldbutton if the generator is not empty and the building is active
	 */
	override public function activate ():Void {
		super.activate(); // put active to true

		if (shoulBeVisible())
			addGraphic();
	}
	
	override public function desactivate ():Void {
		// todo : condition si active car appele deux fois ??
		super.desactivate(); //@TODO: rendre le btn clippable en ajoutant l'implement
		// difficile car demande bcp d'ajout ds les class de Mathieu, (plein de fc super.recycle)
		// à voir plus tard on va dire.
	}
	
	override public function destroy() {	
		ResourcesManager.generatorEvent.off(ResourcesManager.GENERATOR_EVENT_NAME, onGeneratorEvent);
		super.destroy();
	}
}