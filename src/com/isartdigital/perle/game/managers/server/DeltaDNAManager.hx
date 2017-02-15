package com.isartdigital.perle.game.managers.server;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.perle.game.managers.server.ServerManager;
import com.isartdigital.perle.game.managers.server.ServerManager.EventSuccessConnexion;
import com.isartdigital.services.deltaDNA.DeltaDNA;
import com.isartdigital.utils.Config;
import com.isartdigital.utils.Debug;
import com.isartdigital.utils.system.DeviceCapabilities;
import js.Browser;
import js.html.Event;

/**
 * ...
 * @author ambroise
 */
class DeltaDNAManager{

	private static var isReady:Bool;
	
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
		
		isReady = true;
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
		if (!isReady) {
			Debug.warn("DeltaDNA is not ready ! (wait for login !)");
			return;
		}
		
		DeltaDNA.addEvent(DeltaDNAEventCustom.FTUE_STEP, {
			index:pStepIndex,
			timeSpent: Math.round(Date.now().getTime() - stepFTUETStartTimeStamp)
		});
		DeltaDNA.send(Config.DELTA_DNA_IS_LIVE);
		
		stepFTUETStartTimeStamp = Date.now().getTime();
	}
	
	public static function sendIsartPointExpense (pIdPack:Int, pPrice:Float):Void {
		if (!isReady) {
			Debug.warn("DeltaDNA is not ready ! (wait for login !)");
			return;
		}
		
		DeltaDNA.addEvent(DeltaDNAEventCustom.EXPENSE_ISART_POINT, {
			packID:pIdPack,
			playerLevel:ResourcesManager.getLevel(),
			pricePaid:pPrice
		});
		DeltaDNA.send(Config.DELTA_DNA_IS_LIVE);
	}
	
	/*public static function sendTimeSkip (pTimeSkipped:Int, pKarmaSpent:Int):Void {
		DeltaDNA.addEvent(DeltaDNAEventCustom.TIME_SKIP, {
			timeWaited:pTimeSkipped,
			karmaSpent:pKarmaSpent
		});
		DeltaDNA.send(Config.DELTA_DNA_IS_LIVE);
	}*/
	
	/*public static function sendKarmaResourceBuy (pTimeSkipped:Int, pKarmaSpent:Int):Void {
		DeltaDNA.addEvent(DeltaDNAEventCustom.TIME_SKIP, {
			amount:pTimeSkipped,
			skipKarmaSpent:pKarmaSpent
		});
		DeltaDNA.send(Config.DELTA_DNA_IS_LIVE);
	}*/
	/*
	public static function sendGainXp (pType:GeneratorType, pAmount:Int):Void {
		DeltaDNA.addEvent(DeltaDNAEventCustom.GAIN_XP, {
			type:pType.getName(),
			amount:pAmount
		});
		DeltaDNA.send(Config.DELTA_DNA_IS_LIVE);
	}
	
	public static function sendLevelUp ():Void {
		DeltaDNA.addEvent(DeltaDNAEventCustom.LEVEL_UP, {
			currentLevel:ResourcesManager.getLevel()
		});
		DeltaDNA.send(Config.DELTA_DNA_IS_LIVE);
	}*/
	
}