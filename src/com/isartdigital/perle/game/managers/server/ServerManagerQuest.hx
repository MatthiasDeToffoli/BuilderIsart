package com.isartdigital.perle.game.managers.server;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.SaveManager.TimeQuestDescription;
import com.isartdigital.perle.game.managers.server.ServerManager.DbAction;
import com.isartdigital.perle.game.managers.server.ServerManagerInterns.EventErrorIntern;
import com.isartdigital.perle.ui.popin.listIntern.ListInternPopin;
import com.isartdigital.utils.Debug;
import haxe.Json;
import js.Lib;

/**
 * ...
 * @author grenu
 */
class ServerManagerQuest
{
	
	public static function execute(pAction:DbAction, ?pTimeQuest:TimeQuestDescription=null, ?pBoosted:Int):Void {
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
				ServerManager.callPhpFile(onDataCallback, onErrorCallback, ServerFile.MAIN_PHP, [
					ServerManager.KEY_POST_FILE_NAME => ServerFile.TIME_QUEST,
					"funct" => actionCall,
					"idInt" => pTimeQuest.refIntern
				]);
			case DbAction.GET_SPE_JSON:
				ServerManager.callPhpFile(QuestsManager.getJson, onErrorCallback, ServerFile.MAIN_PHP, [
					ServerManager.KEY_POST_FILE_NAME => ServerFile.TIME_QUEST,
					"funct" => actionCall
				]);
			default: return;
		}
	}
	
	public static function addQuest(pTimeQuest:TimeQuestDescription, pPrice:Int):Void {
		ServerManager.callPhpFile(onSuccessAddQuest, onErrorAddQuest, ServerFile.MAIN_PHP, [
			ServerManager.KEY_POST_FILE_NAME => ServerFile.NEW_QUEST_FILE,
			"funct" => DbAction.ADD,
			"idInt" => pTimeQuest.refIntern,
			"step1" => pTimeQuest.steps[0],
			"step2" => pTimeQuest.steps[1],
			"step3" => pTimeQuest.steps[2],
			"price" => pPrice
		]);
	}
	
	public static function onSuccessAddQuest(object:Dynamic):Void {
		if (object.charAt(0) == "{") {
			var lEvent:EventErrorIntern = Json.parse(object);
			if (Reflect.hasField(lEvent, "errorID")) {
				RollBackManager.deleteQuest(lEvent.idIntern);
				ListInternPopin.getInstance().validSendInQuest(lEvent.idIntern);
				ErrorManager.openPopin(Reflect.field(lEvent, "errorID"));
			}		
			else {
				ListInternPopin.getInstance().validSendInQuest(lEvent.idIntern);
				ResourcesManager.spendTotal(GeneratorType.soft, lEvent.price);
			}
		}
	}
	
	public static function onErrorAddQuest(pObject:Dynamic):Void {
		Debug.error("Error php on add quest : " + pObject);
	}
	
	public static function skipQuest(pTimeQuest:TimeQuestDescription, pPrice:Int):Void {
		ServerManager.callPhpFile(onSuccessSkipQuest, onErrorSkipQuest, ServerFile.MAIN_PHP, [
			ServerManager.KEY_POST_FILE_NAME => ServerFile.NEW_QUEST_FILE,
			"idIntern" => pTimeQuest.refIntern
		]);
	}
	
	public static function onSuccessSkipQuest(object:Dynamic):Void {
		
	}
	
	public static function onErrorSkipQuest(pObject:Dynamic):Void {
		Debug.error("Error php on skip quest : " + pObject);
	}
	
	private static function onDataCallback(object:Dynamic):Void {//trace(Json.parse(object));
		
	}
	private static function onErrorCallback(object:Dynamic):Void {//trace(Json.parse(object));
		
	}
	
}