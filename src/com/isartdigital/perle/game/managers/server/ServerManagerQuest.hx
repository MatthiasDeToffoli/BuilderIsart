package com.isartdigital.perle.game.managers.server;
import com.isartdigital.perle.game.managers.SaveManager.TimeQuestDescription;
import com.isartdigital.perle.game.managers.server.ServerManager.DbAction;
import com.isartdigital.utils.Debug;

/**
 * ...
 * @author grenu
 */
class ServerManagerQuest
{
	
	public static function TimeQuestAction(pAction:DbAction, ?pTimeQuest:TimeQuestDescription=null, ?pBoosted:Int):Void {
		var actionCall:String = Std.string(pAction);
		
		switch (pAction) {
			case DbAction.UPDT:
				ServerManager.callPhpFile(onDataCallback, onErrorCallback, ServerFile.MAIN_PHP, [
					ServerManager.KEY_POST_FILE_NAME => ServerFile.TIME_QUEST,
					"funct" => actionCall,
					"idInt" => pTimeQuest.refIntern,
					"stepIndex" => pTimeQuest.stepIndex,
					"boost" => pBoosted
				]);
			case DbAction.REM:
				ServerManager.callPhpFile(onDataCallback, onErrorCallback, ServerFile.MAIN_PHP, [ServerManager.KEY_POST_FILE_NAME => ServerFile.TIME_QUEST, "funct" => actionCall, "idInt" => pTimeQuest.refIntern]);
			case DbAction.GET_SPE_JSON:
				ServerManager.callPhpFile(QuestsManager.getJson, onErrorCallback, ServerFile.MAIN_PHP, [ServerManager.KEY_POST_FILE_NAME => ServerFile.TIME_QUEST, "funct" => actionCall]);
			default: return;
		}
	}
	
	public static function addQuest(pTimeQuest:TimeQuestDescription, pPrice:Int):Void {
		ServerManager.callPhpFile(onSuccessAddQuest, onErrorAddQuest, ServerFile.MAIN_PHP, [
			ServerManager.KEY_POST_FILE_NAME => ServerFile.TIME_QUEST,
			"funct" => DbAction.ADD,
			"idInt" => pTimeQuest.refIntern,
			"step1" => pTimeQuest.steps[0],
			"step2" => pTimeQuest.steps[1],
			"step3" => pTimeQuest.steps[2],
			"price" => pPrice
		]);
	}
	
	public static function onSuccessAddQuest(pObject:Dynamic):Void {
		
	}
	
	public static function onErrorAddQuest(pObject:Dynamic):Void {
		Debug.error("Error php on addBuilding : " + pObject);
	}
		
	private static function onDataCallback(object:Dynamic):Void {//trace(Json.parse(object));
		
	}
	private static function onErrorCallback(object:Dynamic):Void {//trace(Json.parse(object));
		
	}
	
}