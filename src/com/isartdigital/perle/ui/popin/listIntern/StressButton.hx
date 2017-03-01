package com.isartdigital.perle.ui.popin.listIntern;

import com.isartdigital.perle.game.managers.QuestsManager;
import com.isartdigital.perle.game.managers.SaveManager.TimeQuestDescription;
import com.isartdigital.perle.game.managers.TimeManager;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.ui.smart.SmartButton;
import pixi.core.math.Point;

/**
 * ...
 * @author Emeline Berenguier
 */
class StressButton extends SmartButton
{

	public function new(pPos:Point, pID:String=null) 
	{
		super("ButtonPopinStress");
		position = pPos;		
	}
	
}