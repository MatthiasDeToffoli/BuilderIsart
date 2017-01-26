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
 * @author Rabier Ambroise
 */
class VButtonProduction extends VSmartComponent
{
	
	
	
	/**
	 * id of the building link to this button
	 */
	private var refBuilding:Int;
	
	private var myBtn:ButtonProduction;
	
	/**
	 * say if generator is empty of not
	 */
	private var generatorIsNotEmpty = false;

	public function new() 
	{
		super();
		
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
		
		graphic = cast(myBtn, Container);
		
		
		cast(myVHudContextual.graphic, HudContextual).addComponentBtnProd(
			cast(myBtn, SmartComponent)
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
		
		myBtn = null;
	}
}