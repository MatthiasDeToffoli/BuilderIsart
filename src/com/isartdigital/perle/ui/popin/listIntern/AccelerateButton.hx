package com.isartdigital.perle.ui.popin.listIntern;

import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.SaveManager.TimeQuestDescription;
import com.isartdigital.perle.game.managers.TimeManager;
import com.isartdigital.perle.utils.Interactive;
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
	private var quest:TimeQuestDescription;
	
	private static inline var SKIP_PRICE:Int = 2;

	public function new(pPos:Point, pID:String=null) 
	{
		super("ButtonAccelerate");
		position = pPos;
		accelerateValue = cast(SmartCheck.getChildByName(this, "_accelerate_cost"), TextSprite);
		accelerateValue.text = SKIP_PRICE + "";
		Interactive.addListenerClick(this, onAccelerate);
		
	}
	
	public function spawn(pQuest:TimeQuestDescription):Void{
		quest = pQuest;
	}
	
	private function onAccelerate(){
		if (SKIP_PRICE <= ResourcesManager.getTotalForType(GeneratorType.hard)) ResourcesManager.spendTotal(GeneratorType.hard, 2);
		if (!TimeManager.increaseQuestProgress(quest)) return;
	}
	
	override public function destroy():Void {
		removeAllListeners();
		Interactive.removeListenerClick(this, onAccelerate);
		if (parent != null) parent.removeChild(this);
		super.destroy();
	}
	
}