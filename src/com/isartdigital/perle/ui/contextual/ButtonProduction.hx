package com.isartdigital.perle.ui.contextual;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorDescription;
import com.isartdigital.utils.ui.smart.SmartButton;
import pixi.interaction.EventTarget;



/**
 * ...
 * @author COQUERELLE Killian
 */

 /**
  * Button class for all kind of Resources generator (except intern) link to a building
  */
class ButtonProduction extends SmartButton
{
	/**
	 * description of the generator link te this button
	 */
	private var myGeneratorDesc:GeneratorDescription;
	
	
	// @TODO : séparer graphique du logique => VButtonProduction et ButtonProduction
	// et voir pour pooling de la partie graphique
	public function new() {
		super("GoldProduction");
	}
	
	/**
	 * take the generator description
	 * @param	pDesc the generator description
	 */
	public function setMyGeneratorDescription(pDesc:GeneratorDescription):Void {
		myGeneratorDesc = pDesc;
	}

	override function _click(pEvent:EventTarget = null):Void {
		
		if(myGeneratorDesc != null) myGeneratorDesc = ResourcesManager.takeResources(myGeneratorDesc);
		super._click(pEvent);
	}
	
	override public function destroy():Void { // todo : destroy fonctionnel ?
		myGeneratorDesc = null;
		parent.removeChild(this);
		super.destroy();
	}
}