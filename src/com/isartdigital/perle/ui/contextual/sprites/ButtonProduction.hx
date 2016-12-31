package com.isartdigital.perle.ui.contextual.sprites;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorDescription;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.ui.smart.SmartComponent;
import pixi.interaction.EventTarget;



/**
 * ...
 * @author COQUERELLE Killian
 */

 /**
  * Button class for all kind of Resources generator (except intern) link to a building
  */
class ButtonProduction extends SmartComponent // todo : si hérite de SmartButton il doit être un symbol btn ds le wireframe
{ 
	/**
	 * description of the generator link te this button
	 */
	private var myGeneratorDesc:GeneratorDescription;
	
	
	// @TODO : séparer graphique du logique => VButtonProduction et ButtonProduction
	// et voir pour pooling de la partie graphique
	public function new() {
		super("GoldProduction");
		interactive = true;
		on(MouseEventType.CLICK, onClick);
	}
	
	/**
	 * take the generator description
	 * @param	pDesc the generator description
	 */
	public function setMyGeneratorDescription(pDesc:GeneratorDescription):Void {
		myGeneratorDesc = pDesc;
	}

	function onClick(pEvent:EventTarget = null):Void {
		//if (myGeneratorDesc != null) // si pas justifié on enlève, mieux vaut pas rendre le code imperméable aux bugs venant d'un truc mal codé
			myGeneratorDesc = ResourcesManager.takeResources(myGeneratorDesc);
	}
	
	override public function destroy():Void { // todo : destroy fonctionnel ?
		removeAllListeners();
		myGeneratorDesc = null;
		if (parent != null)
			parent.removeChild(this);
		super.destroy();
	}
}