package com.isartdigital.perle.game.sprites;

import com.isartdigital.perle.game.sprites.Building;
import com.isartdigital.perle.ui.SmartCheck;
import com.isartdigital.perle.ui.contextual.sprites.PurgatorySoulCounter;
import com.isartdigital.utils.game.GameStage;

/**
 * ...
 * @author de Toffoli Matthias
 */
class Tribunal extends Building
{

	public function new(?pAssetName:String) 
	{
		super(pAssetName);	
	}
	
override public function init():Void 
	{
		super.init();
		PurgatorySoulCounter.getInstance().position = position.clone();
		PurgatorySoulCounter.getInstance().position.y -= height/2; // @TODO: positionner autrement pour que cela fonctionne avec toutes les qualité 
		PurgatorySoulCounter.getInstance().position.x += width/5;
		Building.uiContainer.addChild(PurgatorySoulCounter.getInstance());
	}
	
	override public function destroy():Void 
	{
		Building.uiContainer.removeChild(PurgatorySoulCounter.getInstance());
		super.destroy();
	}
	
	override public function setStateConstruction():Void 
	{
		
	}
	
	override public function setStateEndConstruction():Void 
	{
		
	}
}