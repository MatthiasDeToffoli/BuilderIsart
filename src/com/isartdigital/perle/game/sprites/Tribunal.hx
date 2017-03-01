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

		var baner:Dynamic = anim.getChildByName('Calque 2');
		anim.addChild(PurgatorySoulCounter.getInstance());
		
		PurgatorySoulCounter.getInstance().position.x = baner.getLocalBounds().x + PurgatorySoulCounter.getInstance().width/2;
		PurgatorySoulCounter.getInstance().position.y = baner.getLocalBounds().y + PurgatorySoulCounter.getInstance().height; // @TODO: positionner autrement pour que cela fonctionne avec toutes les qualité 
	}
	override public function destroy():Void 
	{
		anim.removeChild(PurgatorySoulCounter.getInstance());
		super.destroy();
	}
	
	override public function setStateConstruction():Void 
	{
		
	}
	
	override public function setStateEndConstruction():Void 
	{
		
	}
}