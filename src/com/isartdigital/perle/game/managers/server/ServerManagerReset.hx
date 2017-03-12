package com.isartdigital.perle.game.managers.server;
import com.isartdigital.utils.Debug;

/**
 * ...
 * @author ambroise
 */
class ServerManagerReset{

	public static function reset ():Void {
		ServerManager.callPhpFile(onSuccessReset, onErrorReset, ServerFile.MAIN_PHP, [
			ServerManager.KEY_POST_FILE_NAME => ServerFile.RESET
		]);
	}
	
	private static function onSuccessReset (pObject:Dynamic):Void {
		trace("Reset successfull :" + onSuccessReset);
	}
	
	private static function onErrorReset (pObject:Dynamic):Void {
		Debug.error("Error on Reset :" + pObject);
	}
	
}