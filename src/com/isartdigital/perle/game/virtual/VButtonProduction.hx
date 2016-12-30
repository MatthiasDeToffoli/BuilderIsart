package com.isartdigital.perle.game.virtual;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorDescription;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.ui.contextual.ButtonProduction;
import com.isartdigital.perle.ui.contextual.HudContextual;
import pixi.core.math.Point;
//we have to change package when UI clipping is make

//@Ambroise : you can move and modify this class for clipping :)
/**
 * contain all information for the button production
 * @author de Toffoli Matthias
 */
class VButtonProduction //@TODO : extends classes for clipping
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
	 * say if building is activate or not
	 */
	private var buildingIsInView:Bool = false;
	
	/**
	 * say if generator is empty of not
	 */
	private var generatorIsNotEmpty = false;
	
	/**
	 * Hud contained the Graphic
	 */
	private var myHudContainer:HudContextual;
	/**
	 * graphics of the button
	 */	
	private var graphicBtn:ButtonProduction = new ButtonProduction();

	public function new() 
	{
		ResourcesManager.generatorEvent.on(ResourcesManager.GENERATOR_EVENT_NAME, onGeneratorEvent);
	}
	
	/**
	 * initialiste the virtual button production and set the graphic position the building ref, the generator description and the hud container
	 * @param	pPosition the position of the graphic
	 * @param	pRefBuilding the building reference
	 * @param	pType the type of generator
	 * @param	pHud the hud which contained the graphic
	 */
	public function init (pPosition:Point, pRefBuilding:Int, pType:GeneratorType, pHud:HudContextual):Void {
		graphicBtn.position = pPosition;
		refBuilding = pRefBuilding;
		myGeneratorDesc = ResourcesManager.getGenerator(refBuilding, pType);
		myHudContainer = pHud;
		generatorIsNotEmpty = ResourcesManager.GeneratorIsNotEmpty(myGeneratorDesc);
	}
	
	/**
	 * when the générator have changement (if he increase is value or when he send his resources to his total)
	 * @param	data object contain the id of the generator and a boolean said if the generator is empty or not
	 */
	private function onGeneratorEvent(data:Dynamic):Void{
		if (data.id == refBuilding)
			if (data.active){
				generatorIsNotEmpty = true;
				activate();
			}
			else{
				generatorIsNotEmpty = false;
				if (buildingIsInView){
					graphicBtn.destroy();
					graphicBtn = new ButtonProduction();
				}
				
			}
	}
	
	/**
	 * call when a building is activate
	 */
	public function activeWithBuilding():Void{
		buildingIsInView = true;
		activate();
	}
	
	/**
	 * addchild the goldbutton if the generator is not empty and the building is active
	 */
	private function activate():Void{
		if (generatorIsNotEmpty && buildingIsInView) {
			graphicBtn.setMyGeneratorDescription(myGeneratorDesc);
			myHudContainer.addChild(graphicBtn);
		}
	}
	
	/**
	 * destroy the goldbutton
	 */
	public function unActivateWithBuild():Void{

		buildingIsInView = false;
		
		if (generatorIsNotEmpty){
			//@TODO: voir si on le removechild juste du container ou si on le destroy bien celon le clipping :)
			graphicBtn.destroy();
			// si on remove childe juste @TODO: suprimer cette ligne
			graphicBtn = new ButtonProduction();
		}
		
	}
	
	public function destroy(){
		ResourcesManager.generatorEvent.off(ResourcesManager.GENERATOR_EVENT_NAME, onGeneratorEvent);
	}
}