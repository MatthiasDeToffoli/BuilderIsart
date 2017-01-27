package com.isartdigital.perle.ui.popin.listIntern;

import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.TextSprite;
import pixi.core.math.Point;

/**
 * ...
 * @author Emeline Berenguier
 */
class AccelerateButton extends SmartButton
{
	private var accelerateValue:TextSprite;

	public function new(pPos:Point, pID:String=null) 
	{
		super("ButtonAccelerate");
		position = pPos;
		accelerateValue = cast(SmartCheck.getChildByName(this, "_accelerate_cost"), TextSprite);
		accelerateValue.text = "2"; //@ToDo: Provisoire, en attendant le balancing des GD
	
		//For the actualisation of the switch accelerateButton/stressButton/resolveButton
		//UIManager.getInstance().closeCurrentPopin();
		//InternElementInQuest.canPushNewScreen = true;
		//UIManager.getInstance().openPopin(ListInternPopin.getInstance());
		//GameStage.getInstance().getPopinsContainer().addChild(ListInternPopin.getInstance());
	}
	
	override public function destroy():Void {
		//Interactive.removeListenerClick(this, onClick);
		removeAllListeners();
		if (parent != null) parent.removeChild(this);
		super.destroy();
	}
	
}