package com.isartdigital.perle.game.managers.server;
import com.isartdigital.perle.game.managers.server.ServerManager.DbAction;
import com.isartdigital.perle.game.sprites.Intern;
import com.isartdigital.perle.ui.UIManager;
import com.isartdigital.perle.ui.popin.listIntern.ListInternPopin;
import com.isartdigital.utils.Debug;
import haxe.Json;

typedef EventErrorBuyIntern = {
	var errorID:Int;
	var idIntern:Int;
}

/**
 * ...
 * @author grenu
 */
class ServerManagerInterns
{
	
	/**
	 * call server and ask him to execute a specifique fonction on Interns
	 * @param	pAction action to call
	 * @param	pIntern sometime you need an InternDescription
	 * @return 	
	 */
	public static function execute(pAction:DbAction, ?internId:Int=null, ?eventId:Int=null):Void {
		var actionCall:String = Std.string(pAction);
		
		switch (pAction) {
			case DbAction.ADD:
				if (internId != null) ServerManager.callPhpFile(onSuccessAddIntern, onErrorBuyIntern, ServerFile.MAIN_PHP, [ServerManager.KEY_POST_FILE_NAME => ServerFile.INTERNS, "funct" => actionCall, "idInt" => internId]);
			case DbAction.REM:
				if (internId != null) ServerManager.callPhpFile(onSucessRemoveIntern, onErrorRemoveIntern, ServerFile.MAIN_PHP, [ServerManager.KEY_POST_FILE_NAME => ServerFile.INTERNS, "funct" => actionCall, "idInt" => internId]);
			case DbAction.UPDT:
				if (internId != null) ServerManager.callPhpFile(onDataCallback, onErrorCallback, ServerFile.MAIN_PHP, [ServerManager.KEY_POST_FILE_NAME => ServerFile.INTER_ACTION, "funct" => actionCall, "idInt" => internId, "str" => Intern.getIntern(internId).stress]);
			case DbAction.UPDT_EVENT:
				ServerManager.callPhpFile(onDataCallback, onErrorCallback, ServerFile.MAIN_PHP, [ServerManager.KEY_POST_FILE_NAME => ServerFile.INTER_ACTION, "funct" => actionCall, "idInt" => internId, "idEvent" => eventId]);
			case DbAction.GET_SPE_JSON:
				ServerManager.callPhpFile(Intern.getPlayerInterns, onErrorCallback, ServerFile.MAIN_PHP, [ServerManager.KEY_POST_FILE_NAME => ServerFile.INTER_ACTION, "funct" => actionCall]);
			default: return;
		}
	}
	
	public static function onSuccessAddIntern(object:Dynamic):Void {
		if (object.charAt(0) == "{") {
			var lEvent:EventErrorBuyIntern = Json.parse(object);
			if (Reflect.hasField(lEvent, "errorID")) {
				RollBackManager.deleteIntern(lEvent.idIntern);
				ErrorManager.openPopin(Reflect.field(lEvent, "errorID"));
			}					
		}
	}	
	
	public static function onSucessRemoveIntern(object:Dynamic):Void {
		if (object.charAt(0) == "{") {
			var lEvent:EventErrorBuyIntern = Json.parse(object);
			if (Reflect.hasField(lEvent, "errorID")) {
				RollBackManager.deleteIntern(lEvent.idIntern);
				ErrorManager.openPopin(Reflect.field(lEvent, "errorID"));
			}					
		}
		else {
			Intern.destroyIntern(object);
			TimeManager.destroyTimeQuest(object);
			UIManager.getInstance().closePopin(ListInternPopin.getInstance());
			UIManager.getInstance().openPopin(ListInternPopin.getInstance());
		}
	}
	
	public static function onErrorBuyIntern(object:Dynamic):Void { Debug.error("Error php on buy intern : " + object); }
	public static function onErrorRemoveIntern(object:Dynamic):Void { Debug.error("Error php on buy intern : " + object); }
	
	public static function onDataCallback(object:Dynamic):Void {
		
	}
	public static function onErrorCallback(object:Dynamic):Void {
		
	}
}