package com.isartdigital.perle.ui.popin.listIntern;
import com.isartdigital.perle.game.managers.ResourcesManager;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.SaveManager.TimeQuestDescription;
import com.isartdigital.perle.game.managers.server.ServerManager;
import com.isartdigital.perle.game.managers.TimeManager;
import com.isartdigital.perle.game.managers.server.ServerManager;
import com.isartdigital.perle.game.sprites.Intern;
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
	
	private static inline var SKIP_PRICE:Int = 5;

	public function new(pPos:Point, pID:String=null) 
	{
		super("ButtonAccelerate");
		position = pPos;
		accelerateValue = cast(SmartCheck.getChildByName(this, "_accelerate_cost"), TextSprite);
		accelerateValue.text = SKIP_PRICE + "";
		Interactive.addListenerClick(this, onAccelerate);
		Interactive.addListenerRewrite(this, setValues);
		
	}
	
	public function spawn(pQuest:TimeQuestDescription):Void{
		quest = pQuest;
	}
	
	private function onAccelerate(){
		setValues();
		if (SKIP_PRICE <= ResourcesManager.getTotalForType(GeneratorType.hard)) {
			ResourcesManager.spendTotal(GeneratorType.hard, SKIP_PRICE);
			TimeManager.increaseQuestProgress(quest);
			SoundManager.getSound("SOUND_KARMA").play();
		}
	}
	
	private function setValues():Void{
		accelerateValue = cast(SmartCheck.getChildByName(this, "_accelerate_cost"), TextSprite);
		accelerateValue.text = SKIP_PRICE + "";
	}
	
	override public function destroy():Void {
		removeAllListeners();
		Interactive.removeListenerClick(this, onAccelerate);
		Interactive.removeListenerRewrite(this, setValues);
		if (parent != null) parent.removeChild(this);
		super.destroy();
	}
	
}