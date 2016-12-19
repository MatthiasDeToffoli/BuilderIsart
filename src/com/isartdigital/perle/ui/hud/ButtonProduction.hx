package com.isartdigital.perle.ui.hud;

import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorDescription;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.utils.game.factory.FlumpMovieAnimFactory;
import com.isartdigital.utils.ui.Button;
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
	private var myGeneratorDesc:GeneratorDescription;
	private var id:Int;
	private var resourceType:GeneratorType;

	public function new(pAssetName:String) 
	{
		
		factory = new FlumpMovieAnimFactory();
		// assetName before because the super() does start.
		if (pAssetName != null)
			assetName = pAssetName;	
		super();
		
		
	}
	
	public function setId(pId:Int) {
		id = pId;	
	}
	public function setMyGenerator(pType:GeneratorType):Void {
		myGeneratorDesc = ResourcesManager.getGenerator(id,pType);
	}
	
	override function _click(pEvent:EventTarget):Void 
	{
		myGeneratorDesc = ResourcesManager.takeResources(myGeneratorDesc);
		super._click(pEvent);

	}
	
	override public function destroy():Void 
	{
		//parent.removeChild(this);
		super.destroy();
	}
}