package com.isartdigital.perle.ui.popin.listIntern;

import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.ui.smart.SmartButton;
import pixi.core.math.Point;

/**
 * ...
 * @author Emeline Berenguier
 */
class ResolveButton extends SmartButton
{

	public function new(pPos:Point, pID:String=null) 
	{
		super("ButtonResolve");
		position = pPos;
		
		//For the actualisation of the switch accelerateButton/stressButton/resolveButton
		//UIManager.getInstance().closeCurrentPopin();
		//InternElementInQuest.canPushNewScreen = true;
		//UIManager.getInstance().openPopin(ListInternPopin.getInstance());
		//GameStage.getInstance().getPopinsContainer().addChild(ListInternPopin.getInstance());
	}
	
	override public function destroy():Void {
		removeAllListeners();
		if (parent != null) parent.removeChild(this);
		super.destroy();
	}
	
}