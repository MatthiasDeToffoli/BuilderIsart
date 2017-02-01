package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.ui.UIManager;
import com.isartdigital.perle.ui.hud.Hud;
import com.isartdigital.perle.ui.hud.dialogue.DialogueUI;
import com.isartdigital.perle.ui.hud.dialogue.FTUEStep;
import com.isartdigital.perle.ui.hud.dialogue.FocusManager;
import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.loader.GameLoader;
import com.isartdigital.utils.ui.smart.SmartButton;
import js.Browser;
import pixi.core.display.DisplayObject;


/**
 * ...
 * @author Alexis
 */
class DialogueManager
{
	private static var steps:Array<FTUEStep>;
	private static var closeDialoguePoppin:Bool = false;
	public static var npc_dialogue_ftue:Array<Array<Array<String>>>;
	public static var dialogueSaved:Int;
	
	
	public static function init (pFTUE: Dynamic): Void {
		steps = pFTUE.steps;	
		npc_dialogue_ftue = [];
		parseJsonFtue(Main.DIALOGUE_FTUE_JSON_NAME); //json
		DialogueUI.numberOfDialogue = npc_dialogue_ftue.length; //set length of the dialogue
		DialogueUI.firstToSpeak = npc_dialogue_ftue[0][0][0]; //Set the first NPC to talk
	}
	
	/**
	 * Create Ftue
	 */
	public static function createFtue():Void {
		//check if first time
		if (SaveManager.currentSave.ftueProgress > steps.length-1) {
			//DialogueUI.actualDialogue = SaveManager.currentSave.ftueProgress;
			return;
		}
		dialogueSaved = 0;
		
		//check if FTUE wasn't over
		if(SaveManager.currentSave.ftueProgress!=null)
			dialogueSaved = SaveManager.currentSave.ftueProgress;
		else
			dialogueSaved = 0;
		
		nextStep();
		
	}
	
	public static function createTextDialogue(pNumber:Int, pNpc:String) {
		if (!closeDialoguePoppin) {
			GameStage.getInstance().getHudContainer().addChild(DialogueUI.getInstance());
			Hud.getInstance().hide();
			DialogueUI.getInstance().open();
		}	
		DialogueUI.getInstance().createText(pNumber,pNpc);
	}
	
	public static function register (pTarget:DisplayObject): Void {
		if (dialogueSaved >= steps.length || pTarget.parent == null) return;
		
		for (i in 0...steps.length) {
			if (pTarget.name == steps[i].name && pTarget.parent.name == steps[i].parentName) {
				steps[i].item = pTarget;
				if (Std.is(pTarget,SmartButton)) cast(pTarget, SmartButton).on(MouseEventType.CLICK, endOfStep);
			}
		}
	}
	
	public static function nextStep(pTarget:DisplayObject=null): Void {
		
		if (dialogueSaved >= steps.length) return;
		
		UIManager.getInstance().openFTUE();
		
		//Effects : 
		
		//Dialogue
		if (dialogueSaved == 0 || steps[dialogueSaved].npcWhoTalk != null) {
			if (pTarget != null) return;
			createTextDialogue(steps[dialogueSaved].dialogueNumber, steps[dialogueSaved].npcWhoTalk);
			//FocusManager.getInstance().setFocus(steps[dialogueSaved].item,0);
		}
		//ARROW
		else if (steps[dialogueSaved].arrowRotation != null) FocusManager.getInstance().setFocus(steps[dialogueSaved].item, steps[dialogueSaved].arrowRotation);
		else FocusManager.getInstance().setFocus(steps[dialogueSaved].item, 90);
		
	}
	
	public static function endOfaDialogue():Void {
		if (steps[dialogueSaved + 1].npcWhoTalk != null) {
			closeDialoguePoppin = false;
		}
		else {
			closeDialoguePoppin = true;
			removeDialogue();
		}
		endOfStep();
	}
	
	private static function endOfStep ():Void {
		if (dialogueSaved >= steps.length)
			return;
		
		if (Std.is(steps[dialogueSaved].item, SmartButton)) {
			cast(steps[dialogueSaved].item, SmartButton).off(MouseEventType.CLICK, endOfStep);
			steps[dialogueSaved].item = null;
		}
		
		if (dialogueSaved == steps.length-1) Browser.alert ("fin de la FTUE");
		else {
			trace ("fin d'etape " + dialogueSaved);
		}
		
		UIManager.getInstance().closeFTUE();
		
		dialogueSaved++;
		if (steps[dialogueSaved-1].checkpoint)
			SaveManager.save();
		
		nextStep();
	}
	
	/**
	 * Parse of the json to set an array
	 * @param	pJsonName
	 */
	private static function parseJsonFtue(pJsonName:String):Void {
		var jsonFtue:Dynamic = GameLoader.getContent(pJsonName + ".json");
		var i:Int = 0;
		for (dialogue in Reflect.fields(jsonFtue)) {
			npc_dialogue_ftue[i] = [];
			var ldialogue = Reflect.field(jsonFtue, dialogue);
			var lArray:Array<String> = ldialogue;
			npc_dialogue_ftue[i].push(lArray);
			i++;
		}
	}
	
	/**
	 * Remove Ftue
	 */
	public static function removeDialogue():Void {
		Hud.getInstance().show();
		GameStage.getInstance().getHudContainer().removeChild(DialogueUI.getInstance());	
	}
	
}