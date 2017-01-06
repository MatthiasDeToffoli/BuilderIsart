package com.isartdigital.perle.game.managers;
import haxe.Http;
import haxe.Json;

	
/**
 * Interface whit the server
 * @author ambroise
 */
class ServerManager {
	
	/**
	 * instance unique de la classe ServerManager
	 */
	private static var instance: ServerManager;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): ServerManager {
		if (instance == null) instance = new ServerManager();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() {
		
	}
	
	/**
	 * start player inscription or get his information
	 */
	public static function playerConnexion():Void {
		message(onDataCallback, onErrorCallback, ServerFile.CONNEXION);
	}
	
	/**
	 * call php file
	 * @param	onData callBack function on success
	 * @param	onError callback function on fail
	 * @param	mFile php file to call
	 */
	private static function message(onData:Dynamic->Void, onError:Dynamic->Void, mFile:String):Void
    {
		// create new http request
        var lCall:Http = new Http(mFile);
        lCall.onData = onData;
        lCall.onError = onError;
        lCall.request(true);
    }

	private static function onDataCallback(object:Dynamic):Void {
		trace(Json.parse(object));
	}

	private static function onErrorCallback(object:Dynamic):Void {
		trace("Error php");
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void {
		instance = null;
	}

}

class ServerFile {
	public static inline var CONNEXION:String = "action.php";
}