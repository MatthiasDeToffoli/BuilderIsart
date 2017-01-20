package com.isartdigital.perle.game.managers;
import com.isartdigital.perle.game.virtual.VTile.Index;
import com.isartdigital.services.facebook.Facebook;
import haxe.Http;
import haxe.Json;

	
/**
 * Interface whit the server
 * @author Vicktor Grenu et Ambroise Rabier
 */
class ServerManager {
	
	private static inline var KEY_POST_FILE_NAME:String = "module";
	private static inline var KEY_POST_FUNCTION_NAME:String = "action";
	
	/**
	 * start player inscription or get his information
	 */
	public static function playerConnexion():Void {
		callPhpFile(onDataCallback, onErrorCallback, ServerFile.MAIN_PHP, [KEY_POST_FILE_NAME => ServerFile.LOGIN]);
	}
	
	public static function refreshConfig ():Void { // todo : remplacer par cron ?
		callPhpFile(onDataCallback, onErrorCallback, ServerFile.MAIN_PHP, [KEY_POST_FILE_NAME => ServerFile.TEMP_GET_JSON]);
	}
	
	public static function addRegionToDataBase(typeName:String, mapPos:Index, firstTileMapPos:Index):Void {
		callPhpFile(onDataCallback, onErrorCallback, ServerFile.MAIN_PHP, [
			KEY_POST_FILE_NAME => ServerFile.REGIONS,
			"playerId" => Facebook.uid,
			"type" => typeName,
			"x" => mapPos.x,
			"y" => mapPos.y,
			"firstTileX" => firstTileMapPos.x,
			"firstTileY" => firstTileMapPos.y
			]
		);
	}
	
	/**
	 * call php file
	 * @param	onData callBack function on success
	 * @param	onError callback function on fail
	 * @param	mFile php file to call
	 */
	private static function callPhpFile(onData:Dynamic->Void, onError:Dynamic->Void, pFileName:String, ?pParams:Map<String, Dynamic>):Void {
		// create new http request
        var lCall:Http = new Http(pFileName);
        lCall.onData = onData;
        lCall.onError = onError;
		
		if (pParams != null)
			for (lKey in pParams.keys())
				lCall.setParameter(lKey, pParams[lKey]);
		
		lCall.request(true);
    }

	private static function onDataCallback(object:Dynamic):Void {
		//trace(object);
		//trace(Json.parse(object)); //n'est parfois pas un objet mais un string..
	}

	private static function onErrorCallback(object:Dynamic):Void {
		trace("Error php");
	}
	
	private function new() {
		
	}

}

class ServerFile {
	public static inline var MAIN_PHP:String = "actions.php";
	public static inline var LOGIN:String = "Login";
	public static inline var TEMP_GET_JSON:String = "JsonCreator";
	public static inline var REGIONS:String = "regions";
}