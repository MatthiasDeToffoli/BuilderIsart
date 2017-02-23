package com.isartdigital.perle.game.managers.server;
import com.isartdigital.perle.game.managers.server.ServerManager.DbAction;
import com.isartdigital.perle.game.sprites.Intern;

enum SpeLoadState { complete; inProgress; }

/**
 * ...
 * @author grenu
 */
class ServerManagerSpecial
{
	
	public static var specialFeatureLoadState:SpeLoadState;
	
	public static function startLoad():Void {
		specialFeatureLoadState = SpeLoadState.inProgress;
		ChoiceManager.init();
		ServerManager.ChoicesAction(DbAction.USED_ID);
	}
	
	public static function loadQuests():Void {
		QuestsManager.init();
		ServerManager.TimeQuestAction(DbAction.GET_SPE_JSON);
	}
	
	public static function loadInterns():Void {
		Intern.init();
	}
	
	public static function finishLoading():Void {
		specialFeatureLoadState = SpeLoadState.complete;
	}
	
	
}