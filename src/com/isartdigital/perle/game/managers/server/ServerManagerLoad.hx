package com.isartdigital.perle.game.managers.server;
import com.isartdigital.utils.Debug;
import haxe.Json;


typedef TableBuilding = {
	var iDTypeBuilding:Int;
	var startConstruction:Int; // timestamp
	var endConstruction:Int; // timestamp
	var nbResource:Int;
	var nbSoul:Int;
	var regionX:Int;
	var regionY:Int;
	var x:Int;
	var y:Int;
}

/**
 * ...
 * @author ambroise
 */
class ServerManagerLoad {
	
	private static inline var BUILDING:String = "Building";
	
	private static var serverSave:Map<String, Array<Dynamic>>;

	public static function load ():Void {
		ServerManager.callPhpFile(onSuccessLoad, onErrorLoad, ServerFile.MAIN_PHP, [
			ServerManager.KEY_POST_FILE_NAME => ServerFile.LOADING
		]);
	}
	
	private static function onSuccessLoad (pObject:Dynamic):Void {
		if (pObject.charAt(0) == "{") {
			serverSave = new Map<String, Array<Dynamic>>();
			GameConfig.parseJson(serverSave, Json.parse(pObject));
			Main.getInstance().configLoader.load(); // todo : temporary
		} else {
			Debug.error("Success on load but invalid format.");
		}
	}
	
	private static function onErrorLoad (pObject:Dynamic):Void {
		Debug.error("Error php on load: " + pObject);
	}
	
	public static function getBuilding ():Array<TableBuilding> {
		return cast(serverSave[BUILDING]);
	}
	
	/**
	 * after game is loaded, you don't need serverSave anymore
	 */
	public static function deleteServerSave ():Void {
		serverSave = null;
	}
	
}