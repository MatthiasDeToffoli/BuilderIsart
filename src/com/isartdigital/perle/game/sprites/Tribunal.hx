package com.isartdigital.perle.game.sprites;

import com.isartdigital.perle.game.sprites.Building;
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
		PurgatorySoulCounter.getInstance().position = position;
		PurgatorySoulCounter.getInstance().position.y += 250;
		GameStage.getInstance().getHudContainer().addChild(PurgatorySoulCounter.getInstance());
	}
	
	override public function destroy():Void 
	{
		GameStage.getInstance().getHudContainer().removeChild(PurgatorySoulCounter.getInstance());
		super.destroy();
	}
}