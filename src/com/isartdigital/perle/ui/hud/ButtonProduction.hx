package com.isartdigital.perle.ui.hud;

import com.isartdigital.perle.game.managers.ResourcesManager;
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
	private var myGenerator:Dynamic;
	private var resourcesName:String;
	private var id:Int;

	public function new(pAssetName:String) 
	{
		
		factory = new FlumpMovieAnimFactory();
		// assetName before because the super() does start.
		if (pAssetName != null)
			assetName = pAssetName;	
		super();
		resourcesName = assetName.split("Button")[1];
		
		
	}
	
	public function setId(pId:Int) {
		id = pId;	
	}
	public function setMyGenerator():Void {
		myGenerator = ResourcesManager.getGenerator(resourcesName, id);
	}
	
	override function _click(pEvent:EventTarget):Void 
	{
		ResourcesManager.choosResourcesToTake(resourcesName, myGenerator);
		super._click(pEvent);

	}
	
	override public function destroy():Void 
	{
		//parent.removeChild(this);
		super.destroy();
	}
}