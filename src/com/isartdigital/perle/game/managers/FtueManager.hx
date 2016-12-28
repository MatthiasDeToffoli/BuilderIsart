package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.ui.hud.ftue.FtueUI;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.loader.GameLoader;


/**
 * ...
 * @author Rafired
 */
class FtueManager
{
	public static var npc_dialogue_ftue:Array<Array<Array<String>>>;
	public static var dialogueSaved:Int;
	
	//create FTUE
	public static function createFtue():Void {
		npc_dialogue_ftue = [];
		parseJsonFtue(Main.DIALOGUE_FTUE_JSON_NAME); //json
		FtueUI.numberOfDialogue = npc_dialogue_ftue.length; //set length of the dialogue
		
		//check if frst time
		if (SaveManager.currentSave.ftueProgress > npc_dialogue_ftue.length-1)
			return;
		
		GameStage.getInstance().getHudContainer().addChild(FtueUI.getInstance());
		
		//check if FTUE wasn't over
		if(SaveManager.currentSave.ftueProgress!=null)
			FtueUI.actualDialogue = SaveManager.currentSave.ftueProgress;
		else
			FtueUI.actualDialogue = 0;
		
		FtueUI.firstToSpeak = npc_dialogue_ftue[0][0][0];
		FtueUI.getInstance().open();	
		FtueUI.getInstance().createText();	
	}
	
	//Parse of the json to set an array
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
	
	
	public static function removeFtue():Void {
		GameStage.getInstance().getHudContainer().removeChild(FtueUI.getInstance());	
	}
	
}