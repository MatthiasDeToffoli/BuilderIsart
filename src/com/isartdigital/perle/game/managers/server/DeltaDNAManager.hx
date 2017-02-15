package com.isartdigital.perle.game.managers.server;
import com.isartdigital.perle.game.managers.server.ServerManager;
import com.isartdigital.perle.game.managers.server.ServerManager.EventSuccessConnexion;
import com.isartdigital.services.deltaDNA.DeltaDNA;
import com.isartdigital.utils.Config;
import com.isartdigital.utils.system.DeviceCapabilities;
import js.Browser;
import js.html.Event;

/**
 * ...
 * @author ambroise
 */
class DeltaDNAManager{

	// ##############################################################
    // INIT, GAME_STARTED, NEW_PLAYER, CLIENT_DEVICE, GAME_ENDED
    // ##############################################################
	
	public static function sendConnexionEvents (pEvent:EventSuccessConnexion):Void {
		DeltaDNA.init(
			Config.DELTA_DNA_KEY_DEV, 
			Config.DELTA_DNA_KEY_LIVE,
			Config.DELTA_DNA_URL_COLLECT,
			Config.DELTA_DNA_URL_ENGAGE,
			pEvent.ID,
			pEvent.ID + "_" + Date.now().getTime()
		);
		
		if (pEvent.isNewPlayer)
			DeltaDNA.addEvent(DeltaDNA.NEW_PLAYER);
		
		DeltaDNA.addEvent(DeltaDNA.GAME_STARTED);
		DeltaDNA.addEvent(DeltaDNA.CLIENT_DEVICE);
		DeltaDNA.send(Config.DELTA_DNA_IS_LIVE);
	}
	
	public static function listenToCloseGame ():Void {
		if (DeviceCapabilities.isCocoonJS)
			untyped Browser.window.Cocoon.App.on("suspended", onUnload); // todo : test.
		else
			Browser.window.onbeforeunload = onUnload;
	}
	
	private static function onUnload (pEvent:Event = null):String {
		DeltaDNA.addEvent(DeltaDNA.GAME_ENDED);
		DeltaDNA.send(Config.DELTA_DNA_IS_LIVE);
		return null;
	}
	
	
	// ##############################################################
    // FTUE, 
    // ##############################################################
	
	private static var stepFTUETStartTimeStamp:Float=0;
	
	public static function sendStepFTUE (pStepIndex:Int):Void {
		DeltaDNA.addEvent(DeltaDNAEventCustom.FTUE_STEP, {
			index:pStepIndex,
			timeSpent: Math.round(Date.now().getTime() - stepFTUETStartTimeStamp)
		});
		DeltaDNA.send(Config.DELTA_DNA_IS_LIVE);
		
		stepFTUETStartTimeStamp = Date.now().getTime();
	}
	
	public static function sendIsartPointExpense (pIdPack:Int, pPrice:Float):Void {
		DeltaDNA.addEvent(DeltaDNAEventCustom.EXPENSE_ISART_POINT, {
			packID:pIdPack,
			playerLevel:ResourcesManager.getLevel(),
			pricePaid:pPrice
		});
		DeltaDNA.send(Config.DELTA_DNA_IS_LIVE);
	}
	
	
}