package com.isartdigital.perle.ui.hud.dialogue;

import com.isartdigital.perle.game.AssetName;
import com.isartdigital.perle.game.managers.DialogueManager;
import com.isartdigital.perle.game.managers.TweenManager;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartComponent;
import com.isartdigital.utils.ui.smart.SmartScreen;
import com.isartdigital.utils.ui.smart.TextSprite;

	
/**
 * ...
 * @author Alexis
 */
class DialoguePoppin extends SmartScreen 
{
	private static inline var NEUTRAL_EXPRESSION:String = "_Neutral";
	private static inline var ON_ALPHA:Float = 1;
	private static inline var OFF_ALPHA:Float = 0.2;
	private var btnNext:SmartButton;
	
	private var scenarioAngel:SmartComponent;
	private var scenarioHell:SmartComponent;
	private var actionAngel:SmartComponent;
	private var actionHell:SmartComponent;
	private static var windowOpened:SmartComponent;
	
	//private var npc_name:TextSprite;
	private var npc_speach:TextSprite;
	private var npc_right:String;
	private var npc_left:String;
	public static var wasAction:Bool;
	
	public static var numberOfDialogue:Int;
	public static var firstToSpeak:String;
	
	//Array of the dialogue
	public static var lNpc_dialogue_ftue:Array<Array<Array<String>>>;
	
	public static var allExpressionsArray:Array<String>;
	
	private static inline var ICON_D3:Int = 3;
	private static inline var ICON_D5:Int = 5;
	
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
		setAllFalse();
	}
	
	/**
	 * Create Text generated by the map
	 */
	public function createText(pNumber:Int, pNpc:String, pPicture:String, pExpression:String, isAction:Bool):Void {
		setAllFalse();
		checkIfVisible(pNpc, pExpression, isAction);
		addEffectToDialogueSpawn(isAction,pNpc,pNumber);
		/*if(npc_name!=null)
			npc_name.text = pNpc;*/
		if (npc_speach != null)
		npc_speach.text = DialogueManager.npc_dialogue_ftue[pNumber - 1][0][1];
		checkIfIcons(pNumber);
		//var lIcon:SmartComponent = IconsFtue.setIconOn(pNumber);
		//if(lIcon !=null)
		//	lIcon.position = this.position;
		//hideAllExpression();
		//changeAlpha(pPicture,pExpression);
	}
	
	private function checkIfVisible(pNpc:String, pExpression:String, isAction:Bool):Void {
		if (isAction) {
			if (pNpc == "Demona")
				actionHell.visible = true;
			else
				actionAngel.visible = true;
		}
		else {
			
			if (pNpc == "Demona")
				scenarioHell.visible = true;
			else
				scenarioAngel.visible = true;
		}
	}
	
	private function addEffectToDialogueSpawn(pTypeOfDialogueIsAction:Bool, pNpc:String, pNumberOfDialogue:Int) {
		
		if (pTypeOfDialogueIsAction) {
			wasAction = true;
			TweenManager.upperToRealPos(this);
		}
		else if(wasAction) {
			if (pNpc == "Demona")
				TweenManager.rigthLeftToRealPos(this, false);
			else
				TweenManager.rigthLeftToRealPos(this, true);
			
			if(pNumberOfDialogue != 1)
				wasAction = false;
		}
	}
	
	private function checkIfIcons(pDialogueNumber:Int) {
		switch(pDialogueNumber) {
			case ICON_D3 : trace("test");
			case ICON_D5 : trace("test");
		}
	}
	
	private function setAllFalse():Void {
		scenarioAngel.visible = false;
		scenarioHell.visible = false;
		actionAngel.visible = false;
		actionHell.visible = false;
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
	}

}