package com.isartdigital.perle.ui.hud.dialogue;
import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.DialogueManager;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.events.EventType;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.TextSprite;
import pixi.interaction.EventTarget;

/**
 * ...
 * @author Alexis
 */
class DialogueScenario extends Dialogue
{

	public function new() 
	{
		super(AssetName.FTUE_SCENARIO_WINDOW);
		name = componentName;
	}
	
	override function setWireframe():Void 
	{
		//npc_name = cast(getChildByName(AssetName.FTUE_SCENARIO_NAME), TextSprite);	
		npc_speach = cast(getChildByName(AssetName.FTUE_SCENARIO_SPEACH), TextSprite);	
		btnNext = cast(getChildByName(AssetName.FTUE_SCENARIO_BUTTON), SmartButton);
		npc_right = AssetName.FTUE_SCENARIO_HEAVEN;
		npc_left = AssetName.FTUE_SCENARIO_HELL;
		Interactive.addListenerClick(btnNext, onClickNext);
		
		DialogueManager.registerIsADialogue = true;
		on(EventType.ADDED, registerForFTUE);
		
		super.setWireframe();
	}
	
	override function closeFtue() 
	{
		btnNext.removeAllListeners();
		super.closeFtue();
	}
	
	override public function destroy():Void 
	{
		Interactive.removeListenerClick(btnNext, onClickNext);
		super.destroy();
	}
	
	private function registerForFTUE (pEvent:EventTarget):Void {
		for (i in 0...children.length) {
			if (Std.is(children[i],SmartButton)) DialogueManager.register(children[i]);
		}
		off(EventType.ADDED, registerForFTUE);
	}
	
	/**
	 * Button
	 */
	private function onClickNext():Void {
		DialogueManager.endOfaDialogue();
	}
}