package com.isartdigital.perle.ui.contextual;

import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorDescription;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.utils.game.factory.FlumpMovieAnimFactory;
import com.isartdigital.utils.ui.smart.SmartButton;
import pixi.core.math.Point;
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
	
	private var refBuilding:Int;
	
	/**
	 * type of generator which had by this button
	 */
	private var resourceType:GeneratorType;
	
	
	/**
	 * say if building is activate or not
	 */
	//private var buildingIsInView:Bool = false;
	
	/**
	 * say if generator is empty of not
	 */
	//private var generatorIsNotEmpty = false;
	
	// @TODO : séparer graphique du logique => VButtonProduction et ButtonProduction
	// et voir pour pooling de la partie graphique
	public function new() {
		super("GoldProduction");
		
		//buildingIsInView = true;
		
		//setMyGenerator(pType);
		//generatorIsNotEmpty = ResourcesManager.GeneratorIsNotEmpty(myGeneratorDesc);
		
		//ResourcesManager.generatorEvent.on(ResourcesManager.GENERATOR_EVENT_NAME, setActive);
		
		//if (generatorIsNotEmpty) activate();
	}
	
	public function init (pPosition:Point, pRefBuilding:Int):Void {
		position = pPosition;
		refBuilding = pRefBuilding;
	}
	
	public function setMyGenerator(pType:GeneratorType):Void {
		myGeneratorDesc = ResourcesManager.getGenerator(refBuilding, pType);
	}
	
		/**
	 * look if we had to active or desactive the button
	 * @param data object contain the id and a boolean which said if we activate or desactivate the button
	 */
	/*private function setActive(data:Dynamic){
		if (data.id == id)
			if (data.active)
				activateWithGenerator();
			else desactiveWithGenerator();
	}*/
	
	/**
	 * when it generator is not empty see if we activate the button
	 */
	/*private function activateWithGenerator():Void{
		generatorIsNotEmpty = true;
		if (buildingIsInView) activate();
	}*/
	
	/**
	 * addchild the button
	 */
	/*private function activate():Void {
		GameStage.getInstance().getGameContainer().addChild(this);
		
	}*/
	
	/**
	 * when building is desactivate see if we desactivate the button to
	 */
	/*public function desactiveWithBuilding(){
		buildingIsInView = false;		
		if(generatorIsNotEmpty) desactivate();
	}*/
	
	/**
	 * when it generator is empty see if we desactivate the button
	 */
	/*public function desactiveWithGenerator(){
		generatorIsNotEmpty = false;		
		if(buildingIsInView) desactivate();
	}*/
	
	
	override function _click(pEvent:EventTarget = null):Void {
		if(myGeneratorDesc != null) myGeneratorDesc = ResourcesManager.takeResources(myGeneratorDesc);
		super._click(pEvent);
	}
	
	override public function destroy():Void { // todo : destrooy fonctionnel ?
		//ResourcesManager.generatorEvent.off(ResourcesManager.GENERATOR_EVENT_NAME, setActive);
		parent.removeChild(this);
		super.destroy();
	}
}