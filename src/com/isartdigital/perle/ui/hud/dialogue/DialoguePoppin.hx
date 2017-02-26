package com.isartdigital.perle.ui.hud.dialogue;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.DialogueManager;
import com.isartdigital.perle.game.managers.TweenManager;
import com.isartdigital.perle.utils.Interactive;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.sounds.SoundManager;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.SmartScreen;
import com.isartdigital.utils.ui.smart.TextSprite;
import com.isartdigital.utils.ui.smart.UISprite;
import pixi.core.math.Point;

	
/**
 * ...
 * @author Alexis
 */
class DialoguePoppin extends SmartScreen 
{
	private static inline var NEUTRAL_EXPRESSION:String = "_Neutral";
	private static inline var ANGRY_EXPRESSION:String = "_Sad";
	private static inline var HAPPY_EXPRESSION:String = "_Happy";
	private static inline var HELL_NPC:String = "Demona";
	private static inline var HELL_NPC_MASCOT:String = "_ftue_mascot_demona";
	private static inline var HEAVEN_NPC_MASCOT:String = "_ftue_mascot_angela";
	private static inline var HEAVEN_NPC_MASCOT_SCENARIO:String = "Window_NPC_Heaven";
	private static inline var HELL_NPC_MASCOT_SCENARIO:String = "Window_NPC_Hell";
	private static inline var ON_ALPHA:Float = 1;
	private static inline var OFF_ALPHA:Float = 0.2;
	
	private var scenarioAngel:SmartComponent;
	private var scenarioHell:SmartComponent;
	private var actionAngel:SmartComponent;
	private var actionHell:SmartComponent;
	private var btnNext:SmartButton;
	private var btnEnd:SmartButton;
	private static var windowOpened:SmartComponent;
	
	//private var npc_name:TextSprite;
	private var npc_speach:TextSprite;
	private var npc_right:String;
	private var npc_left:String;
	public static var wasAction:Bool;
	
	public static var numberOfDialogue:Int;
	public static var firstToSpeak:String;
	
	//STATES
	private var scenarioAngelHappy:UISprite;
	private var scenarioAngelAngry:UISprite;
	private var scenarioAngelNeutral:UISprite;
	private var scenarioHellHappy:UISprite;
	private var scenarioHellAngry:UISprite;
	private var scenarioHellNeutral:UISprite;
	private var actionAngelHappy:UISprite;
	private var actionAngelAngry:UISprite;
	private var actionAngelNeutral:UISprite;
	private var actionHellHappy:UISprite;
	private var actionHellAngry:UISprite;
	private var actionHellNeutral:UISprite;
	
	//icons
	private var icon5:SmartComponent;
	private var icon6:SmartComponent;
	private var icon11:SmartComponent;
	private var icon12:SmartComponent;
	private var icon13:SmartComponent;
	private var icon15:SmartComponent;
	private var icon17:SmartComponent;
	private var icon18:SmartComponent;
	private var icon20:SmartComponent;
	private var icon22:SmartComponent;
	private var icon24:SmartComponent;
	private var icon25:SmartComponent;
	private var icon34:SmartComponent;
	private var icon38:SmartComponent;
	private var icon39:SmartComponent;
	private var icon40:SmartComponent;
	private var icon44:SmartComponent;
	private var icon45:SmartComponent;
	private var icon49:SmartComponent;
	private var icon52:SmartComponent;
	private var icon54:SmartComponent;
	
	//iconsEN
	private var iconEn5:SmartComponent;
	private var iconEn6:SmartComponent;
	private var iconEn11:SmartComponent;
	private var iconEn12:SmartComponent;
	private var iconEn13:SmartComponent;
	private var iconEn15:SmartComponent;
	private var iconEn17:SmartComponent;
	private var iconEn18:SmartComponent;
	private var iconEn20:SmartComponent;
	private var iconEn22:SmartComponent;
	private var iconEn24:SmartComponent;
	private var iconEn25:SmartComponent;
	private var iconEn34:SmartComponent;
	private var iconEn38:SmartComponent;
	private var iconEn39:SmartComponent;
	private var iconEn40:SmartComponent;
	private var iconEn44:SmartComponent;
	private var iconEn45:SmartComponent;
	private var iconEn49:SmartComponent;
	private var iconEn52:SmartComponent;
	private var iconEn54:SmartComponent;
	
	//Array of the dialogue
	public static var lNpc_dialogue_ftue:Array<Array<Array<String>>>;
	
	public static var allExpressionsArray:Array<String>;
	
	/**
	 * instance unique de la classe DialoguePoppin
	 */
	private static var instance: DialoguePoppin;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): DialoguePoppin {
		if (instance == null) instance = new DialoguePoppin();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		super(AssetName.FTUE);
		modal = null;
		setWireframe();
	}
	
	/**
	 * Close Ftue
	 */
	private function closeFtue() {
		DialogueManager.removeDialogue();
	}
	
	/**
	 * Set all the variables to the wireframe
	 */
	private function setWireframe():Void {
		scenarioAngel = cast(getChildByName(AssetName.FTUE_SCENARIO_WINDOW_HEAVEN), SmartComponent);
		scenarioHell = cast(getChildByName(AssetName.FTUE_SCENARIO_WINDOW_HELL), SmartComponent);
		actionAngel = cast(getChildByName(AssetName.FTUE_ACTION_HEAVEN), SmartComponent);
		actionHell = cast(getChildByName(AssetName.FTUE_ACTION_HELL), SmartComponent);
		
		//Expressions
		scenarioAngelHappy = cast(SmartCheck.getChildByName(scenarioAngel, HEAVEN_NPC_MASCOT_SCENARIO + HAPPY_EXPRESSION), UISprite);
		scenarioAngelAngry= cast(SmartCheck.getChildByName(scenarioAngel, HEAVEN_NPC_MASCOT_SCENARIO + ANGRY_EXPRESSION), UISprite);
		scenarioAngelNeutral= cast(SmartCheck.getChildByName(scenarioAngel, HEAVEN_NPC_MASCOT_SCENARIO + NEUTRAL_EXPRESSION), UISprite);
		scenarioHellHappy= cast(SmartCheck.getChildByName(scenarioHell, HELL_NPC_MASCOT_SCENARIO + HAPPY_EXPRESSION), UISprite);
		scenarioHellAngry= cast(SmartCheck.getChildByName(scenarioHell, HELL_NPC_MASCOT_SCENARIO + ANGRY_EXPRESSION), UISprite);
		scenarioHellNeutral= cast(SmartCheck.getChildByName(scenarioHell, HELL_NPC_MASCOT_SCENARIO + NEUTRAL_EXPRESSION), UISprite);
		actionAngelHappy= cast(SmartCheck.getChildByName(actionAngel, HEAVEN_NPC_MASCOT + HAPPY_EXPRESSION), UISprite);
		actionAngelAngry= cast(SmartCheck.getChildByName(actionAngel, HEAVEN_NPC_MASCOT + ANGRY_EXPRESSION), UISprite);
		actionAngelNeutral= cast(SmartCheck.getChildByName(actionAngel, HEAVEN_NPC_MASCOT + NEUTRAL_EXPRESSION), UISprite);
		actionHellHappy= cast(SmartCheck.getChildByName(actionHell, HELL_NPC_MASCOT + HAPPY_EXPRESSION), UISprite);
		actionHellAngry= cast(SmartCheck.getChildByName(actionHell, HELL_NPC_MASCOT + ANGRY_EXPRESSION), UISprite);
		actionHellNeutral= cast(SmartCheck.getChildByName(actionHell, HELL_NPC_MASCOT + NEUTRAL_EXPRESSION), UISprite);
		
		//IconsFR
		icon5 = cast(getChildByName(AssetName.FTUE_ICON_5), SmartComponent);
		icon6 = cast(getChildByName(AssetName.FTUE_ICON_6), SmartComponent);
		icon11= cast(getChildByName(AssetName.FTUE_ICON_11), SmartComponent);
		icon12 = cast(getChildByName(AssetName.FTUE_ICON_12), SmartComponent);
		icon13 = cast(getChildByName(AssetName.FTUE_ICON_13), SmartComponent);
		icon15 = cast(getChildByName(AssetName.FTUE_ICON_15), SmartComponent);
		icon17 = cast(getChildByName(AssetName.FTUE_ICON_17), SmartComponent);
		icon18 = cast(getChildByName(AssetName.FTUE_ICON_18), SmartComponent);
		icon20 = cast(getChildByName(AssetName.FTUE_ICON_20), SmartComponent);
		icon22 = cast(getChildByName(AssetName.FTUE_ICON_22), SmartComponent);
		icon24 = cast(getChildByName(AssetName.FTUE_ICON_24), SmartComponent);
		icon25 = cast(getChildByName(AssetName.FTUE_ICON_25), SmartComponent);
		icon34 = cast(getChildByName(AssetName.FTUE_ICON_34), SmartComponent);
		icon38 = cast(getChildByName(AssetName.FTUE_ICON_38), SmartComponent);
		icon39 = cast(getChildByName(AssetName.FTUE_ICON_39), SmartComponent);
		icon40 = cast(getChildByName(AssetName.FTUE_ICON_40), SmartComponent);
		icon44 = cast(getChildByName(AssetName.FTUE_ICON_44), SmartComponent);
		icon45 = cast(getChildByName(AssetName.FTUE_ICON_45), SmartComponent);
		icon49 = cast(getChildByName(AssetName.FTUE_ICON_49), SmartComponent);
		icon52 = cast(getChildByName(AssetName.FTUE_ICON_52), SmartComponent);
		icon54 = cast(getChildByName(AssetName.FTUE_ICON_54), SmartComponent);
		//IconsEN
		iconEn5 = cast(getChildByName(AssetName.FTUE_ICON_EN_5), SmartComponent);
		iconEn6 = cast(getChildByName(AssetName.FTUE_ICON_EN_6), SmartComponent);
		iconEn11= cast(getChildByName(AssetName.FTUE_ICON_EN_11), SmartComponent);
		iconEn12 = cast(getChildByName(AssetName.FTUE_ICON_EN_12), SmartComponent);
		iconEn13 = cast(getChildByName(AssetName.FTUE_ICON_EN_13), SmartComponent);
		iconEn15 = cast(getChildByName(AssetName.FTUE_ICON_EN_15), SmartComponent);
		iconEn17 = cast(getChildByName(AssetName.FTUE_ICON_EN_17), SmartComponent);
		iconEn18 = cast(getChildByName(AssetName.FTUE_ICON_EN_18), SmartComponent);
		iconEn20 = cast(getChildByName(AssetName.FTUE_ICON_EN_20), SmartComponent);
		iconEn22 = cast(getChildByName(AssetName.FTUE_ICON_EN_22), SmartComponent);
		iconEn24 = cast(getChildByName(AssetName.FTUE_ICON_EN_24), SmartComponent);
		iconEn25 = cast(getChildByName(AssetName.FTUE_ICON_EN_25), SmartComponent);
		iconEn34 = cast(getChildByName(AssetName.FTUE_ICON_EN_34), SmartComponent);
		iconEn38 = cast(getChildByName(AssetName.FTUE_ICON_EN_38), SmartComponent);
		iconEn39 = cast(getChildByName(AssetName.FTUE_ICON_EN_39), SmartComponent);
		iconEn40 = cast(getChildByName(AssetName.FTUE_ICON_EN_40), SmartComponent);
		iconEn44 = cast(getChildByName(AssetName.FTUE_ICON_EN_44), SmartComponent);
		iconEn45 = cast(getChildByName(AssetName.FTUE_ICON_EN_45), SmartComponent);
		iconEn49 = cast(getChildByName(AssetName.FTUE_ICON_EN_49), SmartComponent);
		iconEn52 = cast(getChildByName(AssetName.FTUE_ICON_EN_52), SmartComponent);
		iconEn54 = cast(getChildByName(AssetName.FTUE_ICON_EN_54), SmartComponent);
		
		btnNext = cast(getChildByName(AssetName.FTUE_SCENARIO_BUTTON), SmartButton);
		Interactive.addListenerClick(btnNext, nextStep);
		btnEnd = cast(getChildByName(AssetName.FTUE_SCENARIO_BUTTON_END), SmartButton);
		Interactive.addListenerClick(btnEnd, nextStep);
		setAllFalse();
	}
	
	private function nextStep():Void{
		DialogueManager.endOfaDialogue();
	}
	
	/**
	 * Create Text generated by the map
	 */
	public function createText(pNumber:Int, pNpc:String, pPicture:String, pExpression:String, isAction:Bool, dialogueSaved:Int):Void {
		setAllFalse();
		checkIfVisible(pNpc, pExpression, isAction, dialogueSaved);
		
		if(DialogueManager.isFR)
			checkIfIconsFr(pNumber);
		else
			checkIfIconsEn(pNumber);
		
		if (npc_speach != null)
		npc_speach.text = DialogueManager.actual_npc_dialogue_ftue[pNumber - 1][0][1];
		addEffectToDialogueSpawn(isAction,pNpc,pNumber);
	}
	
	/**
	 * Check what we have to pass visible
	 * @param	pNpc which NPC
	 * @param	pExpression which Expression
	 * @param	isAction is an Action ?
	 * @param	dialogueSaved number of dialogue
	 */
	private function checkIfVisible(pNpc:String, pExpression:String, isAction:Bool, dialogueSaved:Int):Void {
		var lPanel:SmartComponent;
		if (isAction) {
			if (pNpc == HELL_NPC){
				SoundManager.getSound("SOUND_DIALOG_DEMON").play();
				lPanel = actionHell;
			}
			else{
				SoundManager.getSound("SOUND_DIALOG_ANGEL").play();
				lPanel = actionAngel;
			}
		}
		else {
			if (pNpc == HELL_NPC){
				SoundManager.getSound("SOUND_DIALOG_DEMON").play();
				lPanel = scenarioHell;
			}
			else{
				SoundManager.getSound("SOUND_DIALOG_ANGEL").play();
				lPanel = scenarioAngel;
			}
			checkWichButton(dialogueSaved);
		}
		checkExpressions(isAction, pExpression,pNpc);
		lPanel.visible = true;
		setTextWf(isAction, lPanel);
	}
	
	/**
	 * Check wich button should be visible
	 * @param	dialogueSaved number of dialogue
	 */
	private function checkWichButton(dialogueSaved:Int) {
		if (DialogueManager.steps[dialogueSaved].endOfFtue || DialogueManager.steps[dialogueSaved].endOfSpecial || DialogueManager.steps[dialogueSaved].endOfAltar || DialogueManager.steps[dialogueSaved].endOfCollectors || DialogueManager.steps[dialogueSaved].endOfFactory || DialogueManager.steps[dialogueSaved].endOfMarketing || DialogueManager.steps[dialogueSaved].endOfSpecial)
			btnEnd.visible = true;
		else
			btnNext.visible = true;
		Hud.isHide = false;
	}
	
	/**
	 * Tween effect
	 * @param	pTypeOfDialogueIsAction
	 * @param	pNpc
	 * @param	pNumberOfDialogue
	 */
	private function addEffectToDialogueSpawn(pTypeOfDialogueIsAction:Bool, pNpc:String, pNumberOfDialogue:Int) {
		
		if (pTypeOfDialogueIsAction) {
			wasAction = true;
			TweenManager.upperToRealPos(this);
		}
		else if (wasAction) {
			TweenManager.scaleGrow(this,true);
			wasAction = false;
		}
	}
	
	/**
	 * Set text
	 * @param	isAction
	 * @param	pPanel
	 */
	private function setTextWf(isAction:Bool,pPanel:SmartComponent) {
		npc_speach = cast(SmartCheck.getChildByName(pPanel, AssetName.FTUE_SCENARIO_SPEACH), TextSprite);
	}
	
	/**
	 * Set Expression
	 * @param	isAction
	 * @param	pExpression
	 * @param	pNpc
	 */
	private function checkExpressions(isAction:Bool, pExpression:String,pNpc:String):Void {
		switch(pExpression) {
			case "_Happy" : {
				if (isAction) 
					pNpc == HELL_NPC ? actionHellHappy.visible = true : actionAngelHappy.visible = true;
				else
					pNpc == HELL_NPC ? scenarioHellHappy.visible = true : scenarioAngelHappy.visible = true;
			}
			case "_Neutral" : {
				if (isAction) 
					pNpc == HELL_NPC ? actionHellNeutral.visible = true : actionAngelNeutral.visible = true;
				else
					pNpc == HELL_NPC ? scenarioHellNeutral.visible = true : scenarioAngelNeutral.visible = true;
			}
			case "_Angry" : {
				if (isAction) 
					pNpc == HELL_NPC ? actionHellAngry.visible = true : actionAngelAngry.visible = true;
				else
					pNpc == HELL_NPC ? scenarioHellAngry.visible = true : scenarioAngelAngry.visible = true;
			}
		}
	}
	
	/**
	 * Check if we should put the Icons fr
	 * @param	pDialogueNumber
	 */
	private function checkIfIconsFr(pDialogueNumber:Int) {
		switch(pDialogueNumber) {
			case 5 : icon5.visible = true;
			case 6 : icon6.visible = true;
			case 11 : icon11.visible = true;
			case 12 : icon12.visible = true;
			case 13 : icon13.visible = true;
			case 15 : icon15.visible = true;
			case 17 : icon17.visible = true;
			case 18 : icon18.visible = true;
			case 20 : icon20.visible = true;
			case 22 : icon22.visible = true;
			case 24 : icon24.visible = true;
			case 25 : icon25.visible = true;
			case 34 : icon34.visible = true;
			case 38 : icon38.visible = true;
			case 39 : icon39.visible = true;
			case 40 : icon40.visible = true;
			case 44 : icon44.visible = true;
			case 45 : icon45.visible = true;
			case 49 : icon49.visible = true;
			case 52 : icon52.visible = true;
			case 54 : icon54.visible = true;
		}
	}
	
	/**
	 * Check if we should put the Icons en
	 * @param	pDialogueNumber
	 */
	private function checkIfIconsEn(pDialogueNumber:Int) {
		switch(pDialogueNumber) {
			case 5 : iconEn5.visible = true;
			case 6 : iconEn6.visible = true;
			case 11 : iconEn11.visible = true;
			case 12 : iconEn12.visible = true;
			case 13 : iconEn13.visible = true;
			case 15 : iconEn15.visible = true;
			case 17 : iconEn17.visible = true;
			case 18 : iconEn18.visible = true;
			case 20 : iconEn20.visible = true;
			case 22 : iconEn22.visible = true;
			case 24 : iconEn24.visible = true;
			case 25 : iconEn25.visible = true;
			case 34 : iconEn34.visible = true;
			case 38 : iconEn38.visible = true;
			case 39 : iconEn39.visible = true;
			case 40 : iconEn40.visible = true;
			case 44 : iconEn44.visible = true;
			case 45 : iconEn45.visible = true;
			case 49 : iconEn49.visible = true;
			case 52 : iconEn52.visible = true;
			case 54 : iconEn54.visible = true;
		}
	}
	
	/**
	 * Npc Heaven pos
	 * @return Npc Heaven pos
	 */
	public function getNpcHeavenPos():Point {
		var lNpc:UISprite = cast(SmartCheck.getChildByName(scenarioAngel, "Window_NPC_Heaven_Neutral"), UISprite);
		var lPos:Point = GameStage.getInstance().getFtueContainer().toLocal(lNpc.position);
		return lPos;
	}
	
	/**
	 * Set all flag var to false
	 */
	public function setAllFalse():Void {
		scenarioAngel.visible = false;
		scenarioHell.visible = false;
		actionAngel.visible = false;
		actionHell.visible = false;
		btnNext.visible = false;
		btnEnd.visible = false;
		
		scenarioAngelHappy.visible = false;
		scenarioAngelAngry.visible = false;
		scenarioAngelNeutral.visible = false;
		scenarioHellHappy.visible = false;
		scenarioHellAngry.visible = false;
		scenarioHellNeutral.visible = false;
		actionAngelHappy.visible = false;
		actionAngelAngry.visible = false;
		actionAngelNeutral.visible = false;
		actionHellHappy.visible = false;
		actionHellAngry.visible = false;
		actionHellNeutral.visible = false;
		
		icon5.visible = false;
		icon6.visible = false;
		icon11.visible = false;
		icon12.visible = false;
		icon13.visible = false;
		icon15.visible = false;
		icon17.visible = false;
		icon18.visible = false;
		icon20.visible = false;
		icon22.visible = false;
		icon24.visible = false;
		icon25.visible = false;
		icon34.visible = false;
		icon38.visible = false;
		icon39.visible = false;
		icon40.visible = false;
		icon44.visible = false;
		icon45.visible = false;
		icon49.visible = false;
		icon52.visible = false;
		icon54.visible = false;
		
		iconEn5.visible = false;
		iconEn6.visible = false;
		iconEn11.visible = false;
		iconEn12.visible = false;
		iconEn13.visible = false;
		iconEn15.visible = false;
		iconEn17.visible = false;
		iconEn18.visible = false;
		iconEn20.visible = false;
		iconEn22.visible = false;
		iconEn24.visible = false;
		iconEn25.visible = false;
		iconEn34.visible = false;
		iconEn38.visible = false;
		iconEn39.visible = false;
		iconEn40.visible = false;
		iconEn44.visible = false;
		iconEn45.visible = false;
		iconEn49.visible = false;
		iconEn52.visible = false;
		iconEn54.visible = false;
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		Interactive.removeListenerClick(btnNext, nextStep);
		Interactive.removeListenerClick(btnEnd, nextStep);
		instance = null;
	}

}