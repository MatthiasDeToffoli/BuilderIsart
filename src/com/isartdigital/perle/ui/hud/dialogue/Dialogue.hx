package com.isartdigital.perle.ui.hud.dialogue;

import com.isartdigital.perle.game.managers.DialogueManager;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.ui.smart.SmartButton;
import com.isartdigital.utils.ui.smart.SmartScreen;
import com.isartdigital.utils.ui.smart.TextSprite;



/**
 * ...
 * @author Alexis
 */
class Dialogue extends SmartScreen
{ 
	private static inline var NEUTRAL_EXPRESSION:String = "_Neutral";
	private static inline var ON_ALPHA:Float = 1;
	private static inline var OFF_ALPHA:Float = 0.2;
	private var btnNext:SmartButton;
	//private var npc_name:TextSprite;
	private var npc_speach:TextSprite;
	private var npc_right:String;
	private var npc_left:String;
	public static var numberOfDialogue:Int;
	public static var firstToSpeak:String;
	
	//Array of the dialogue
	public static var lNpc_dialogue_ftue:Array<Array<Array<String>>>;
	
	public static var allExpressionsArray:Array<String>;
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new(pAsset:String) 
	{
		super(pAsset);
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
		
	}
	
	/**
	 * Create Text generated by the map
	 */
	public function createText(pNumber:Int, pNpc:String, pPicture:String, pExpression:String):Void {
		/*if(npc_name!=null)
			npc_name.text = pNpc;*/
		if(npc_speach!=null)
		npc_speach.text = DialogueManager.npc_dialogue_ftue[pNumber - 1][0][1];
		hideAllExpression();
		changeAlpha(pPicture,pExpression);
	}
	
	/**
	 * function to hide All Expressions of the Npcs
	 */
	private function hideAllExpression() {
		for (i in 0...allExpressionsArray.length) {
			var lExpression:String = allExpressionsArray[i];
			if(getChildByName(npc_left + lExpression)!=null)
				getChildByName(npc_left + lExpression).visible = false;
				
			if(getChildByName(npc_right + lExpression)!=null)
				getChildByName(npc_right + lExpression).visible = false;
		}
	}
	
	/**
	 * Function to change expressiosn of NPCS
	 * @param	pExpression
	 * @param	pPicture of NPC
	 */
	private function changeExpression(pExpression:String, pPicture:String) {
		if(getChildByName(pPicture + pExpression)!=null)
			getChildByName(pPicture + pExpression).visible = true;
	}
	
	/**
	 * function to change the alpha of the NPC who talk
	 * @param	pName of NPC
	 */
	private function changeAlpha(pPicture:String,pExpression:String) {
		switch(pPicture) {
			case "left" : {
				if(getChildByName(npc_left)!=null)
					changeAlphaExpression(npc_left, ON_ALPHA);
				changeExpression(pExpression, npc_left);
				
				if(getChildByName(npc_right )!=null)
					changeAlphaExpression(npc_right, OFF_ALPHA);
				changeExpression(NEUTRAL_EXPRESSION,npc_right);
			}
			case "right" : {
				if(getChildByName(npc_left)!=null)
					changeAlphaExpression(npc_left, OFF_ALPHA);
				changeExpression(NEUTRAL_EXPRESSION, npc_left);
				
				if(getChildByName(npc_right)!=null)
					changeAlphaExpression(npc_right, ON_ALPHA);
				changeExpression(pExpression,npc_right);
			}
		}
	}
	
	/**
	 * Change alpha of the expression
	 * @param	pPicture
	 * @param	pAlpha
	 */
	private function changeAlphaExpression(pPicture:String, pAlpha:Float) {
		for (i in 0...allExpressionsArray.length) {
			var lExpression:String = allExpressionsArray[i];
			if(getChildByName(pPicture + lExpression)!=null)
				getChildByName(pPicture + lExpression).alpha = pAlpha;
		}
	}

	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		super.destroy();
	}
	
}