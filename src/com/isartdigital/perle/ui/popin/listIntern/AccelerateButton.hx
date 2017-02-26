package com.isartdigital.perle.ui.popin.listIntern;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.SaveManager.TimeQuestDescription;
import com.isartdigital.perle.game.managers.server.ServerManager;
import com.isartdigital.perle.game.managers.TimeManager;
import com.isartdigital.perle.game.managers.server.ServerManager;
import com.isartdigital.perle.game.sprites.Intern;
import com.isartdigital.perle.ui.popin.accelerate.AcceleratePopin;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.TextSprite;
import pixi.core.math.Point;


/**
 * Button for the acceleration/Time skip
 * @author Emeline Berenguier
 */
class AccelerateButton extends SmartButton
{
	private var accelerateValue:TextSprite;
	private var quest:TimeQuestDescription;
	private var boostPrice:Int;

	public function new(pPos:Point, pID:String=null) 
	{
		super("ButtonAccelerate");
		position = pPos;
		Interactive.addListenerClick(this, onAccelerate);
		Interactive.addListenerRewrite(this, setValues);
		
	}
	
	public function spawn(pQuest:TimeQuestDescription):Void{
		quest = pQuest;
		setValues();
	}
	
	private function onAccelerate(){
		setValues();
		if (boostPrice <= ResourcesManager.getTotalForType(GeneratorType.hard)) {
			ResourcesManager.spendTotal(GeneratorType.hard, boostPrice);
			TimeManager.increaseQuestProgress(quest);
			SoundManager.getSound("SOUND_KARMA").play();
		}
	}
	
	private function setValues():Void {
		boostPrice = Math.ceil(((quest.startTime + quest.steps[quest.stepIndex]) - quest.progress) / AcceleratePopin.TIME_BASE_PRICE);
		accelerateValue = cast(SmartCheck.getChildByName(this, "_accelerate_cost"), TextSprite);
		accelerateValue.text = Std.string(boostPrice);
	}
	
	override public function destroy():Void {
		removeAllListeners();
		Interactive.removeListenerClick(this, onAccelerate);
		Interactive.removeListenerRewrite(this, setValues);
		if (parent != null) parent.removeChild(this);
		super.destroy();
	}
	
}