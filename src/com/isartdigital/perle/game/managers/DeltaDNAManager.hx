package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.game.managers.ServerManager.EventSuccessConnexion;
import com.isartdigital.services.deltaDNA.DeltaDNA;
import com.isartdigital.utils.Config;
import com.isartdigital.utils.system.DeviceCapabilities;
import js.Browser;

/**
 * ...
 * @author ambroise
 */
class DeltaDNAManager{

	
	public static function sendConnexionEvents (pEvent:EventSuccessConnexion):Void {
		DeltaDNA.init(
			Config.DELTA_DNA_KEY_DEV, 
			Config.DELTA_DNA_KEY_LIVE,
			Config.DELTA_DNA_URL_COLLECT,
			Config.DELTA_DNA_URL_ENGAGE,
			pEvent.userId,
			pEvent.userId + "_" + Date.now().getTime()
		);
		
		if (pEvent.isNewPlayer)
			DeltaDNA.addEvent(DeltaDNA.NEW_PLAYER);
		
		DeltaDNA.addEvent(DeltaDNA.GAME_STARTED);
		DeltaDNA.addEvent(DeltaDNA.CLIENT_DEVICE);
		DeltaDNA.send(Config.DELTA_DNA_IS_LIVE);
	}
	
	public static function listenToCloseGame ():Void {
		if (DeviceCapabilities.isCocoonJS)
			untyped Browser.window.Cocoon.App.on("suspended", onUnload);
		else
			Browser.window.onunload = onUnload;
	}
	
	private static function onUnload ():Void {
		Browser.window.alert("hello close");
		DeltaDNA.addEvent(DeltaDNA.GAME_ENDED);
		DeltaDNA.send(Config.DELTA_DNA_IS_LIVE);
	}
	
}