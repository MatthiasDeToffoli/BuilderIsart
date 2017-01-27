package com.isartdigital.perle.ui.popin.listIntern;

import com.isartdigital.perle.game.managers.QuestsManager;
import com.isartdigital.perle.game.managers.SaveManager.TimeQuestDescription;
import com.isartdigital.perle.game.managers.TimeManager;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.ui.smart.SmartButton;
import pixi.core.math.Point;
import pixi.interaction.EventTarget;

/**
 * ...
 * @author Emeline Berenguier
 */
class SendButton extends SmartButton
{

	public function new(pPos:Point, pID:String=null) 
	{
		super("ButtonSend");
		position = pPos;
		
	}
	
	override public function destroy():Void { // todo : destroy fonctionnel ?
		//Interactive.removeListenerClick(this, onClick);
		removeAllListeners();
		if (parent != null) parent.removeChild(this);
		super.destroy();
	}
}