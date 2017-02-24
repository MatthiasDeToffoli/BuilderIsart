package com.isartdigital.perle.game.managers.server;
import com.isartdigital.perle.game.managers.SaveManager.GeneratorType;
import com.isartdigital.utils.Debug;
import haxe.Json;


typedef TableBuilding = {
	var iDTypeBuilding:Int;
	var startConstruction:Int; // timestamp
	var endConstruction:Int; // timestamp
	@:optional var nbResource:Int;
	@:optional var endForNextProduction:Int; // timestamp
	@:optional var nbSoul:Int;
	var regionX:Int;
	var regionY:Int;
	var x:Int;
	var y:Int;
}

typedef TableResources = {
	var type:GeneratorType;
	var quantity:Int;
}

typedef TablePlayer = {
	var dateInscription:String;
	var dateLastConnexion:String;
	var email:String;
	var numberRegionHell:Int;
	var numberRegionHeaven:Int;
	var ftueProgress:Int;
	var level:Int;
}

/**
 * ...
 * @author ambroise
 */
class ServerManagerLoad {
	
	private static inline var TABLE_BUILDING:String = "Building";
	private static inline var TABLE_RESOURCES:String = "Resources";
	private static inline var TABLE_PLAYER:String = "Player";
	
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
		return cast(serverSave[TABLE_BUILDING]);
	}
	
	public static function getResources ():Array<TableResources> {
		return cast(serverSave[TABLE_RESOURCES]);
	}
	
	public static function getPlayer ():TablePlayer {
		return cast(serverSave[TABLE_PLAYER][0]);
	}
	
	/**
	 * after game is loaded, you don't need serverSave anymore
	 */
	public static function deleteServerSave ():Void {
		serverSave = null;
	}
	
}