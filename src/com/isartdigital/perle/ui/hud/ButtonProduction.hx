package com.isartdigital.perle.ui.hud;

import com.isartdigital.perle.game.iso.IsoManager;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorDescription;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.SaveManager.TileDescription;
import com.isartdigital.perle.game.sprites.Building;
import com.isartdigital.perle.game.virtual.VTile.Index;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.game.factory.FlumpMovieAnimFactory;
import com.isartdigital.utils.ui.Button;
import pixi.core.math.Point;
import pixi.interaction.EventTarget;

/**
 * ...
 * @author COQUERELLE Killian
 */

 /**
  * Button class for all kind of Resources generator (except intern) link to a building
  */
class ButtonProduction extends Button
{
	/**
	 * description of the generator link te this button
	 */
	private var myGeneratorDesc:GeneratorDescription;
	
	/**
	 * id of this button
	 */
	private var id:Int;
	
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

	public function new(pAssetName:String) 
	{
		
		factory = new FlumpMovieAnimFactory();
		// assetName before because the super() does start.
		if (pAssetName != null)
			assetName = pAssetName;
		super();
		
		ResourcesManager.generatorEvent.on(ResourcesManager.GENERATOR_EVENT_NAME, setActive);
		
		
	}
	
	/**
	 * get a generator corresponding to him
	 * @param pType the type of the generator wanted
	 */
	private function setMyGenerator(pType:GeneratorType):Void {
		myGeneratorDesc = ResourcesManager.getGenerator(id,pType);
	}
	
	override function _click(pEvent:EventTarget):Void 
	{
		if(myGeneratorDesc != null) myGeneratorDesc = ResourcesManager.takeResources(myGeneratorDesc);
		super._click(pEvent);

	}
	
	/**
	 * when building is activate see if we activate the button to
	 * @param pDesc description of the batiment link of this button
	 * @param pType the type of the generator wanted
	 */
	public function activeWithBuilding(pDesc:TileDescription, pType:GeneratorType):Void{
		buildingIsInView = true;
		
		var posIso:Point = IsoManager.modelToIsoView(new Point(pDesc.mapX + pDesc.regionX - Building.ASSETNAME_TO_MAPSIZE[pDesc.assetName].width/2, pDesc.mapY + pDesc.regionY - Building.ASSETNAME_TO_MAPSIZE[pDesc.assetName].height / 2));
		posIso.y -= height;
		position = posIso;
		id = pDesc.id;		
		setMyGenerator(pType);
		
		generatorIsNotEmpty = ResourcesManager.GeneratorIsNotEmpty(myGeneratorDesc);
		
		if (generatorIsNotEmpty) activate();
	}
	
	/**
	 * look if we had to active or desactive the button
	 * @param data object contain the id and a boolean which said if we activate or desactivate the button
	 */
	private function setActive(data:Dynamic){
		if (data.id == id)
			if (data.active)
				activateWithGenerator();
			else desactiveWithGenerator();
	}
	
	/**
	 * when it generator is not empty see if we activate the button
	 */
	private function activateWithGenerator():Void{
		generatorIsNotEmpty = true;
		if (buildingIsInView) activate();
	}
	
	/**
	 * addchild the button
	 */
	private function activate():Void {
		GameStage.getInstance().getGameContainer().addChild(this);
		
	}
	
	/**
	 * when building is desactivate see if we desactivate the button to
	 */
	public function desactiveWithBuilding(){
		buildingIsInView = false;		
		if(generatorIsNotEmpty) desactivate();
	}
	
	/**
	 * when it generator is empty see if we desactivate the button
	 */
	public function desactiveWithGenerator(){
		generatorIsNotEmpty = false;		
		if(buildingIsInView) desactivate();
	}
	
	/**
	 * removechild the button
	 */
	private function desactivate():Void{
		parent.removeChild(this);
	}
	
	override public function destroy():Void 
	{
		//parent.removeChild(this);
		ResourcesManager.generatorEvent.off(ResourcesManager.GENERATOR_EVENT_NAME, setActive);
		super.destroy();
	}
}